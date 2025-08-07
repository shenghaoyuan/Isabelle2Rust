.open:

.PHONY: open clean code

DEFAULT_FILE = $(CURDIR)/Rust_Setup.thy

code:
	isabelle build -v -e -d . $(THEORY)

open:
	isabelle jedit -d . $(DEFAULT_FILE)

clean :
	@echo $@
	find . -name "*\.thy~" -exec rm {} \;
	find . -name "*\.cmi" -exec rm {} \;
	find . -name "*\.cmo" -exec rm {} \;
