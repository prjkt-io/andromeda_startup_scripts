SCRIPTS_TO_TEST := Linux/start_andromeda.sh Linux/uninstall_overlays.sh Linux/enable_overlays.sh Linux/disable_overlays.sh macOS/start_andromeda.sh

test:
		@shellcheck ${SCRIPTS_TO_TEST}

installhook:
		@cp -v shellcheck-hook .git/hooks/pre-commit
		@chmod +x .git/hooks/pre-commit

.PHONY: test