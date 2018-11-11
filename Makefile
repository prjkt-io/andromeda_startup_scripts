SCRIPTS_TO_TEST := Linux/start_andromeda.sh Linux/uninstall_overlays.sh Linux/enable_overlays.sh Linux/disable_overlays.sh macOS/start_andromeda.sh

.DEFAULT_GOAL := package

test:
		@shellcheck ${SCRIPTS_TO_TEST}

package:
		@./package.sh

installhook:
		@cp -v shellcheck-hook .git/hooks/pre-commit
		@chmod +x .git/hooks/pre-commit
