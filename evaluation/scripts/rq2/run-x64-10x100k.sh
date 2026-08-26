#!/usr/bin/env bash
set -euo pipefail

# Run the canonical x86-64 differential validation in independent batches.
#
# Default campaign: 10 batches * 100,000 vectors = 1,000,000 vectors.
# Each batch uses the raw Stage-1 Rust encoder to prepare machine code, then
# checks the OCaml, raw Stage-1 Rust, and full Stage-2 Rust steppers against
# native x86-64 execution.
#
# Optional environment overrides:
#   ROUNDS=10
#   CASES_PER_ROUND=100000
#   SEED_BASE=5984326      # round n uses SEED_BASE + n - 1
#   REBUILD=1              # force regeneration before the campaign
#   ARCHIVE_CORPUS=0       # archive each batch's step1--step4 files when 1
#   RESULT_DIR=/path/to/results

if [[ ${1:-} == "--help" ]]; then
  sed -n '4,16p' "$0"
  exit 0
elif (($# != 0)); then
  printf 'usage: %s [--help]\n' "$0" >&2
  exit 2
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)
validation_dir="$repo_root/test/x64/x64-validation"
data_dir="$validation_dir/0-data"
stage1_export_root="$repo_root/test/x64/theory/stage1/x64_generator_bigint"
stage2_export_root="$repo_root/test/x64/theory/stage2/x64_generator_bigint"
stage1_encoder_export="$stage1_export_root/x64_encode"
stage1_stepper_export="$stage1_export_root/x64_step_test"
stage2_stepper_export="$stage2_export_root/x64_step_test"

rounds=${ROUNDS:-10}
cases_per_round=${CASES_PER_ROUND:-100000}
seed_base=${SEED_BASE:-5984326}
rebuild=${REBUILD:-0}
archive_corpus=${ARCHIVE_CORPUS:-0}
timestamp=$(date +%Y%m%d-%H%M%S)
result_dir=${RESULT_DIR:-$repo_root/evaluation/.work/rq2/x64-${rounds}x${cases_per_round}-${timestamp}}
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
if [[ $(uname -m) != x86_64 ]]; then
  printf 'ERROR: native x86-64 validation requires an x86_64 host.\n' >&2
  exit 2
fi
for tool in awk cargo flock git grep isabelle make ocamlopt python3 rustc sha256sum tee; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'ERROR: required command not found: %s\n' "$tool" >&2
    exit 2
  fi
done
if [[ $archive_corpus == 1 ]] && ! command -v tar >/dev/null 2>&1; then
  printf 'ERROR: ARCHIVE_CORPUS=1 requires tar.\n' >&2
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
printf 'round\tseed\tcases\tstep1_sha256\tstep2_sha256\tstep3_sha256\tstep4_sha256\tstage1_ocaml_failed\tstage1_rust_failed\tstage2_rust_failed\tcorpus_archive\n' >"$summary_tsv"

{
  printf 'campaign=x64 instruction-level differential validation\n'
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
  printf 'numeric_profile=BigInt\n'
} >"$result_dir/environment.txt"

clean_env=(
  env
  -u CARGO
  -u CARGO_PROFILE_DEV_OPT_LEVEL
  -u CC
  -u OCAMLC
  -u OCAMLFIND
  -u REBUILD
  -u RUSTC_BOOTSTRAP
  -u RUSTFLAGS
  -u RUST_TOOLCHAIN
  -u X
  -u X64_JANSSON_LIBS
  -u X64_OCAML_PACKAGES
  -u X64_ENCODER_INPUT
  -u X64_RUST_BUILD_DIR
  -u X64_RUST_EXPORT_ROOT
  -u X64_SEED
  -u X64_STEPPER_INPUT
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
        /Complete test cases generated/ ||
        /Summary:/ ||
        /Rust semantics vs CPU:/ {
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

stage1_encoder_manifest="$stage1_encoder_export/Cargo.toml"
stage1_stepper_manifest="$stage1_stepper_export/Cargo.toml"
stage2_stepper_manifest="$stage2_stepper_export/Cargo.toml"

printf 'Preparing or reusing both x86-64 Rust stages.\n'
run_logged "$result_dir/prepare-stage1.log" \
  "${clean_env[@]}" make x64-rust-export REBUILD="$rebuild"

for manifest in \
  "$stage1_encoder_manifest" "$stage1_stepper_manifest" \
  "$stage2_stepper_manifest"; do
  if [[ ! -f $manifest ]]; then
    printf 'ERROR: required x86-64 export is missing: %s\n' "$manifest" >&2
    printf 'Set REBUILD=1 to regenerate the canonical exports.\n' >&2
    exit 2
  fi
done

declare -A seen_step4_hashes=()
for ((round = 1; round <= rounds; round++)); do
  round_id=$(printf '%02d' "$round")
  log_file="$result_dir/round-${round_id}.log"
  seed=$((seed_base + round - 1))
  printf '\n=== x64 round %d/%d: %d vectors ===\n' "$round" "$rounds" "$cases_per_round"
  printf 'Full log: %s\n' "$log_file"

  run_logged "$log_file" \
    "${clean_env[@]}" make x64 X="$cases_per_round" SEED="$seed"

  grep -Eq "Summary: .*${cases_per_round} passed.* / .*0 failed" "$log_file" || {
    printf 'ERROR: missing successful OCaml semantics summary in %s\n' "$log_file" >&2
    exit 1
  }
  rust_summaries=$(grep -Fc "Rust semantics vs CPU: $cases_per_round passed / 0 failed (0 panicked)" "$log_file" || true)
  if [[ $rust_summaries != 2 ]]; then
    printf 'ERROR: expected successful Stage-1 and Stage-2 Rust summaries in %s\n' "$log_file" >&2
    exit 1
  fi

  for data_file in step1.in step2.in step3.json step4.json; do
    if [[ ! -s $data_dir/$data_file ]]; then
      printf 'ERROR: expected x64 corpus file is missing or empty: %s\n' "$data_dir/$data_file" >&2
      exit 1
    fi
  done
  observed_cases=$(grep -c '^[[:space:]]*"ins"[[:space:]]*:' "$data_dir/step4.json")
  if [[ $observed_cases != "$cases_per_round" ]]; then
    printf 'ERROR: step4.json contains %s cases; expected %s\n' "$observed_cases" "$cases_per_round" >&2
    exit 1
  fi

  step1_sha=$(sha256_file "$data_dir/step1.in")
  step2_sha=$(sha256_file "$data_dir/step2.in")
  step3_sha=$(sha256_file "$data_dir/step3.json")
  step4_sha=$(sha256_file "$data_dir/step4.json")
  if [[ ${seen_step4_hashes[$step4_sha]+present} ]]; then
    printf 'ERROR: round %d reproduced an earlier step4 corpus (%s).\n' "$round" "$step4_sha" >&2
    exit 1
  fi
  seen_step4_hashes[$step4_sha]=$round

  archive_name='not-archived'
  if [[ $archive_corpus == 1 ]]; then
    archive_name="round-${round_id}-corpus.tar.gz"
    printf 'Archiving batch corpus as %s\n' "$result_dir/$archive_name"
    tar -czf "$result_dir/$archive_name" -C "$data_dir" \
      step1.in step2.in step3.json step4.json
  fi

  printf '%d\t%d\t%d\t%s\t%s\t%s\t%s\t0\t0\t0\t%s\n' \
    "$round" "$seed" "$cases_per_round" "$step1_sha" "$step2_sha" \
    "$step3_sha" "$step4_sha" "$archive_name" >>"$summary_tsv"
done

total_vectors=$((rounds * cases_per_round))
{
  printf 'status=PASS\n'
  printf 'completed_at=%s\n' "$(date --iso-8601=seconds)"
  printf 'rounds=%d\n' "$rounds"
  printf 'cases_per_round=%d\n' "$cases_per_round"
  printf 'total_test_vectors=%d\n' "$total_vectors"
  printf 'ocaml_failed=0\n'
  printf 'stage1_rust_failed=0\n'
  printf 'stage2_full_rust_failed=0\n'
} >"$result_dir/summary.txt"

printf '\nPASS: %d x86-64 vectors validated in %d independent batches.\n' "$total_vectors" "$rounds"
printf 'Results: %s\n' "$result_dir"
