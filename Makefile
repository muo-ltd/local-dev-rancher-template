usage:
	@echo 'Usage: make [Target] [Parameters]'
	@echo ''
	@echo 'Targets:'
	@echo ''
	@echo '  up'
	@echo '  down'
	@echo '  generate-rancher-env'
	@echo ''

up:
	@./scripts/rancher-setup.sh up

down:
	@./scripts/rancher-setup.sh down
	
generate-rancher-env:
	@./scripts/rancher-setup.sh createRancherApiKey