.open:

.PHONY: open clean code

DEFAULT_FILE = $(CURDIR)/Rust_Setup.thy

open:
	isabelle jedit -d . $(DEFAULT_FILE)

code:
	isabelle build -v -e -d . $(THEORY)
clean :
	@echo $@
	find . -name "*\.thy~" -exec rm {} \;
	find . -name "*\.cmi" -exec rm {} \;
	find . -name "*\.cmo" -exec rm {} \;
