help: ## Prints this help command
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
setup: ## Setup and install opa in current context
	bin/setup.sh
test: ## Test opa
	bin/test.sh
logs: ## View logs of opa
	kubectl logs -l app=opa -c opa
cleanup: ## Uninstall opa and all tests
	bin/cleanup.sh
