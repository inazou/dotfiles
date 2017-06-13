
SCRIPT_DIR=$$(pwd)/scripts

.PHONY: all
all: setup


.PHONY: setup
setup:
	@$(SCRIPT_DIR)/LinkFiles.sh
	@$(SCRIPT_DIR)/SetupVim.sh
