setup:
	bin/setup.sh
logs:
	kubectl logs -l app=opa -c opa
test:
	bin/test.sh
cleanup:
	bin/cleanup.sh
