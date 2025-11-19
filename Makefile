.open:

.PHONY: open clean

DEFAULT_FILE = $(CURDIR)/Rust_Setup.thy

open:
	isabelle jedit -d . $(DEFAULT_FILE)

ROOT_FILE := ROOT
ISABELLE_BUILD := isabelle build -v -e -d . Test

build: 
	@echo "Generating ROOT file for $(TEST_THEORY)..."
	@sed \
	  -e 's|@TEST_DIR@|$(TEST_DIR)|g' \
	  -e 's|@TEST_THEORY@|$(TEST_THEORY)|g' \
	  ROOT.template > ROOT
	@echo "Building Isabelle session with theory: $(TEST_THEORY)"
	@$(ISABELLE_BUILD)

code:
	@$(ISABELLE_BUILD)

clean :
	@echo $@
	find . -name "*\.thy~" -exec rm {} \;
	find . -name "*\.cmi" -exec rm {} \;
	find . -name "*\.cmo" -exec rm {} \;
