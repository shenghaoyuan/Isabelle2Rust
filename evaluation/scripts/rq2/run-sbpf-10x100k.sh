#!/usr/bin/env bash
set -euo pipefail

# Run the SBPF program- and instruction-level differential validation.
#
# The 146-case program suite is checked once with the OCaml, Stage-1 Rust, and
# full Stage-2 Rust exports.  The instruction campaign then runs 10 batches *
# 100,000 vectors = 1,000,000 vectors. Each batch independently generates a
# fresh random corpus and checks the same three exports. By default only counts,
# result status, and corpus provenance are retained; generated instruction
# vectors are not.
#
# Optional environment overrides:
#   ROUNDS=10
#   CASES_PER_ROUND=100000
#   SEED_BASE=5984326      # round n uses SEED_BASE + n - 1
#   REBUILD=1              # force regeneration before the campaign
#   ARCHIVE_CORPUS=0       # retain each generated corpus as .json.gz when 1
#   RESULT_DIR=/path/to/results

if [[ ${1:-} == "--help" ]]; then
  sed -n '4,18p' "$0"
  exit 0
elif (($# != 0)); then
  printf 'usage: %s [--help]\n' "$0" >&2
  exit 2
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)

rounds=${ROUNDS:-10}
cases_per_round=${CASES_PER_ROUND:-100000}
seed_base=${SEED_BASE:-5984326}
rebuild=${REBUILD:-0}
archive_corpus=${ARCHIVE_CORPUS:-0}
timestamp=$(date +%Y%m%d-%H%M%S)
result_dir=${RESULT_DIR:-$repo_root/evaluation/.work/rq2/sbpf-${rounds}x${cases_per_round}-${timestamp}}
if [[ $result_dir != /* ]]; then
  result_dir="$repo_root/$result_dir"
fi

require_positive_integer() {
  local name=$1 value=$2
  if [[ ! $value =~ ^[1-9][0-9]*$ ]]; then
    printf 'ERROR: %s must be a positive integer, got %q\n' "$name" "$value" >&2
    exit 2
  fi
}

require_positive_integer ROUNDS "$rounds"
require_positive_integer CASES_PER_ROUND "$cases_per_round"
require_positive_integer SEED_BASE "$seed_base"
if [[ $rebuild != 0 && $rebuild != 1 ]]; then
  printf 'ERROR: REBUILD must be 0 or 1, got %q\n' "$rebuild" >&2
  exit 2
fi
if [[ $archive_corpus != 0 && $archive_corpus != 1 ]]; then
  printf 'ERROR: ARCHIVE_CORPUS must be 0 or 1, got %q\n' "$archive_corpus" >&2
  exit 2
fi
for tool in awk cargo flock git grep isabelle make ocamlopt python3 rustc sha256sum tee; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'ERROR: required command not found: %s\n' "$tool" >&2
    exit 2
  fi
done
if [[ $archive_corpus == 1 ]] && ! command -v gzip >/dev/null 2>&1; then
  printf 'ERROR: ARCHIVE_CORPUS=1 requires gzip.\n' >&2
  exit 2
fi
if [[ -e $result_dir ]]; then
  printf 'ERROR: result directory already exists: %s\n' "$result_dir" >&2
  exit 2
fi

lock_id=$(printf '%s' "$repo_root" | sha256sum | awk '{print substr($1, 1, 16)}')
lock_file="/tmp/isabelle2rust-rq2-${lock_id}.lock"
exec 9>"$lock_file"
if ! flock -n 9; then
  printf 'ERROR: another RQ2 validation campaign holds %s\n' "$lock_file" >&2
  exit 2
fi

mkdir -p "$result_dir"
summary_tsv="$result_dir/batches.tsv"
printf 'round\tseed\tcases\tcorpus_sha256\tstage1_ocaml_failed\tstage1_rust_failed\tstage2_rust_failed\tcorpus_file\n' >"$summary_tsv"
program_tsv="$result_dir/program.tsv"
printf 'implementation\tcases\tfailed\n' >"$program_tsv"

{
  printf 'campaign=SBPF program- and instruction-level differential validation\n'
  printf 'started_at=%s\n' "$(date --iso-8601=seconds)"
  printf 'git_commit=%s\n' "$(git -C "$repo_root" rev-parse HEAD)"
  if [[ -n $(git -C "$repo_root" status --porcelain) ]]; then
    printf 'git_dirty=yes\n'
  else
    printf 'git_dirty=no\n'
  fi
  printf 'host_arch=%s\n' "$(uname -m)"
  printf 'cpu_model=%s\n' "$(awk -F: '/model name/{sub(/^[[:space:]]+/, "", $2); print $2; exit}' /proc/cpuinfo)"
  printf 'memory_kib=%s\n' "$(awk '/MemTotal/{print $2; exit}' /proc/meminfo)"
  printf 'kernel=%s\n' "$(uname -sr)"
  printf 'isabelle=%s\n' "$(isabelle version)"
  printf 'rustc=%s\n' "$(rustc +1.94.0 --version)"
  printf 'cargo=%s\n' "$(cargo +1.94.0 --version)"
  printf 'ocaml=%s\n' "$(ocamlopt -version)"
  printf 'python=%s\n' "$(python3 --version 2>&1)"
  printf 'rounds=%s\n' "$rounds"
  printf 'cases_per_round=%s\n' "$cases_per_round"
  printf 'total_vectors=%s\n' "$((rounds * cases_per_round))"
  printf 'seed_base=%s\n' "$seed_base"
  printf 'rebuild=%s\n' "$rebuild"
  printf 'archive_corpus=%s\n' "$archive_corpus"
  printf 'numeric_profile=default BigInt export\n'
} >"$result_dir/environment.txt"

clean_env=(
  env
  -u CARGO
  -u CARGO_PROFILE_DEV_OPT_LEVEL
  -u OCAML_REBUILD
  -u OCAML_VERSION
  -u REBUILD
  -u RUSTC_BOOTSTRAP
  -u RUSTFLAGS
  -u RUST_TOOLCHAIN
  -u SBPF_EXPORT_DIR
  -u SBPF_NO_BIGINT
  -u SBPF_STAGE
  -u SBPF_STEP_JSON
  -u SBPF_THEORY
  -u X
  -u num
)

run_logged() {
  local log_file=$1
  shift
  local -a status

  {
    printf 'command:'
    printf ' %q' "$@"
    printf '\n'
  } >"$log_file"
  set +e
  (
    cd "$repo_root"
    "$@"
  ) 2>&1 \
    | tee -a "$log_file" \
    | awk '
        /^>>>/ ||
        /Successfully generated/ ||
        /summary/ ||
        /Summary/ ||
        /Passed:/ ||
        /Failed:/ ||
        /Overall:/ {
          print
          fflush()
        }
      '
  status=("${PIPESTATUS[@]}")
  set -e

  if ((status[0] != 0 || status[1] != 0 || status[2] != 0)); then
    printf 'ERROR: command failed; tail of %s follows.\n' "$log_file" >&2
    tail -n 80 "$log_file" >&2
    return 1
  fi
}

sha256_file() {
  sha256sum "$1" | awk '{print $1}'
}

program_log="$result_dir/program.log"
printf '\n=== SBPF program suite: 146 cases ===\n'

run_logged "$program_log" \
  "${clean_env[@]}" make macro_sbpf REBUILD="$rebuild"
grep -Fq 'OCaml export: Passed 146 / Failed 0 / Total 146' "$program_log" || {
  printf 'ERROR: missing successful program-level OCaml summary in %s\n' "$program_log" >&2
  exit 1
}
grep -Fq 'Stage-1 Rust export: Passed 146 / Failed 0 / Total 146' "$program_log" || {
  printf 'ERROR: missing successful program-level Stage-1 Rust summary in %s\n' "$program_log" >&2
  exit 1
}
grep -Fq 'Stage-2 Rust export: Passed 146 / Failed 0 / Total 146' "$program_log" || {
  printf 'ERROR: missing successful program-level Stage-2 Rust summary in %s\n' "$program_log" >&2
  exit 1
}
printf 'OCaml\t146\t0\nStage-1 Rust\t146\t0\nStage-2 Full Rust\t146\t0\n' >>"$program_tsv"

declare -A seen_corpus_hashes=()
for ((round = 1; round <= rounds; round++)); do
  round_id=$(printf '%02d' "$round")
  corpus="$result_dir/round-${round_id}.json"
  round_log="$result_dir/round-${round_id}.log"
  seed=$((seed_base + round - 1))

  printf '\n=== SBPF round %d/%d: %d vectors ===\n' \
    "$round" "$rounds" "$cases_per_round"

  run_logged "$round_log" \
    "${clean_env[@]}" make micro_sbpf X="$cases_per_round" \
      SBPF_STEP_JSON="$corpus" SBPF_STEP_SEED="$seed"
  grep -Fq "Successfully generated $cases_per_round random test cases" "$round_log" || {
    printf 'ERROR: generator did not confirm the requested count in %s\n' "$round_log" >&2
    exit 1
  }
  grep -Fq "OCaml export: Passed $cases_per_round / Failed 0 / Total $cases_per_round" "$round_log" || {
    printf 'ERROR: missing successful OCaml summary in %s\n' "$round_log" >&2
    exit 1
  }
  grep -Fq "Stage-1 Rust export: Passed $cases_per_round / Failed 0 / Total $cases_per_round" "$round_log" || {
    printf 'ERROR: missing successful Stage-1 Rust summary in %s\n' "$round_log" >&2
    exit 1
  }
  grep -Fq "Stage-2 Rust export: Passed $cases_per_round / Failed 0 / Total $cases_per_round" "$round_log" || {
    printf 'ERROR: missing successful Stage-2 Rust summary in %s\n' "$round_log" >&2
    exit 1
  }

  observed_cases=$(grep -c '^[[:space:]]*"dis"[[:space:]]*:' "$corpus")
  if [[ $observed_cases != "$cases_per_round" ]]; then
    printf 'ERROR: corpus contains %s cases; expected %s\n' "$observed_cases" "$cases_per_round" >&2
    exit 1
  fi

  corpus_sha=$(sha256_file "$corpus")
  if [[ ${seen_corpus_hashes[$corpus_sha]+present} ]]; then
    printf 'ERROR: round %d reproduced an earlier corpus (%s).\n' "$round" "$corpus_sha" >&2
    exit 1
  fi
  seen_corpus_hashes[$corpus_sha]=$round

  corpus_name=not-retained
  if [[ $archive_corpus == 1 ]]; then
    corpus_name=$(basename "$corpus")
    printf 'Compressing retained corpus %s\n' "$corpus"
    gzip -n "$corpus"
    corpus_name="${corpus_name}.gz"
  else
    rm -f -- "$corpus"
  fi

  printf '%d\t%d\t%d\t%s\t0\t0\t0\t%s\n' \
    "$round" "$seed" "$cases_per_round" "$corpus_sha" "$corpus_name" >>"$summary_tsv"
done

total_vectors=$((rounds * cases_per_round))
{
  printf 'status=PASS\n'
  printf 'completed_at=%s\n' "$(date --iso-8601=seconds)"
  printf 'rounds=%d\n' "$rounds"
  printf 'cases_per_round=%d\n' "$cases_per_round"
  printf 'total_test_vectors=%d\n' "$total_vectors"
  printf 'program_cases=146\n'
  printf 'program_ocaml_failed=0\n'
  printf 'program_stage1_rust_failed=0\n'
  printf 'program_stage2_full_rust_failed=0\n'
  printf 'ocaml_failed=0\n'
  printf 'stage1_rust_failed=0\n'
  printf 'stage2_full_rust_failed=0\n'
} >"$result_dir/summary.txt"

printf '\nPASS: %d SBPF vectors validated in %d independent batches.\n' "$total_vectors" "$rounds"
printf 'Results: %s\n' "$result_dir"
