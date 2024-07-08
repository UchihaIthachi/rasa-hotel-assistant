# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows-specific commands
    INIT_SCRIPT := scripts/init.bat
    START_SCRIPT := scripts/start.bat
    STOP_SCRIPT := scripts/stop.bat
    SQL_SCRIPT := scripts/startSql.bat
else
    # Linux/macOS commands
    INIT_SCRIPT := scripts/init.sh
    START_SCRIPT := scripts/start.sh
    STOP_SCRIPT := scripts/stop.sh
    SQL_SCRIPT := scripts/startSql.sh
endif

# Common paths
DOCKER_COMPOSE := docker/docker-compose.yml

# Phony targets
.PHONY: init docker-start docker-stop docker-up docker-down docker-rm docker-clean sql train train-nlu run-actions shell run validate help

# Targets
init: ## Initialize permissions and folder structure
	$(INIT_SCRIPT)

docker-start: ## Start Docker containers
	$(START_SCRIPT)

docker-stop: ## Stop Docker containers
	$(STOP_SCRIPT)

docker-up: ## Bring up Docker containers
	@echo "Starting Docker containers..."
	docker-compose -f $(DOCKER_COMPOSE) up -d

docker-down: ## Bring down Docker containers
	@echo "Stopping Docker containers..."
	docker-compose -f $(DOCKER_COMPOSE) down

docker-rm: ## Remove Docker containers
	@echo "Removing Docker containers..."
	docker-compose -f $(DOCKER_COMPOSE) rm -f

docker-clean: ## Clean Docker resources
	@echo "Cleaning Docker resources..."
	docker system prune --volumes -f

sql: ## Start SQL database access
	$(SQL_SCRIPT)

train: ## Train the full Rasa model
	rasa train --domain domain.yml --data data --config configs/config_supervised.yml --out models

train-nlu: ## Train only the NLU model
	rasa train nlu --nlu data/nlu.yml --config configs/config_supervised.yml --out models/nlu

run-actions: ## Run the action server
	rasa run actions --actions actions --cors "*" --debug

shell: ## Run an interactive Rasa shell
	$(MAKE) run-actions &
	rasa shell -m models --endpoints endpoints.yml

run: ## Run the Rasa server with React web app
	$(MAKE) run-actions &
	rasa run --enable-api -m models --cors "*" --debug

validate: ## Validate the Rasa files
	rasa data validate --domain domain.yml --data data --config configs/config_supervised.yml

help: ## Display help
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
