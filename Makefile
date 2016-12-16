ports="80;5432"

usage:
	@echo 'Usage: make [Target] [Parameters]'
	@echo ''
	@echo 'Targets:'
	@echo ''
	@echo '  up'
	@echo '  down'
	@echo '  '
	@echo '  build-proxy'
	@echo '  run-proxy'
	@echo '  remove-proxy'
	@echo '  '
	@echo '  generate-rancher-env'
	@echo ''

up:
	@./scripts/rancher-setup.sh up $(ports)

down:
	@./scripts/rancher-setup.sh down

build-proxy:
	@./scripts/rancher-setup.sh buildProxy $(ports)

run-proxy:
	@./scripts/rancher-setup.sh runProxy $(ports) 

remove-proxy:
	@./scripts/rancher-setup.sh stopAndRemoveProxy
	
generate-rancher-env:
	@./scripts/rancher-setup.sh createRancherApiKey