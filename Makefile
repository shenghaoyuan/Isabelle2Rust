.open:

.PHONY: open clean

DEFAULT_FILE = $(CURDIR)/Rust_Setup.thy

open:
	isabelle jedit -d . $(DEFAULT_FILE)

clean :
	@echo $@
	find . -name "*\.thy~" -exec rm {} \;
	find . -name "*\.cmi" -exec rm {} \;
	find . -name "*\.cmo" -exec rm {} \;
