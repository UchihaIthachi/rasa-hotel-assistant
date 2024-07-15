# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows-specific commands
    INIT_SCRIPT := scripts/init.bat
    START_SCRIPT := scripts/start.bat
    STOP_SCRIPT := scripts/stop.bat
    SQL_SCRIPT := scripts/startSql.bat
    RM := del /Q
    RM_DIR := rmdir /S /Q
else
    # Linux/macOS commands
    INIT_SCRIPT := scripts/init.sh
    START_SCRIPT := scripts/start.sh
    STOP_SCRIPT := scripts/stop.sh
    SQL_SCRIPT := scripts/startSql.sh
    RM := rm -rf
endif

# Common paths
DOCKER_COMPOSE := docker/docker-compose.yml
config_supervised := app/configs/config_supervised.yml
config_bert := app/configs/config_bert.yml
config_spacy := app/configs/config_spacy.yml
config_custom := app/configs/config_custom.yml
ACTION := app/actions
MODEL := app/models
DATA := app/data
ENDPOINT := app/endpoints.yml
DOMAIN := app/domain.yml

# Phony targets
.PHONY: init docker-start docker-stop docker-up docker-down docker-rm docker-clean sql train train-nlu run-actions shell run validate help clean

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

docker-clean-full: ## Clean Docker resources
	@echo "Cleaning Docker resources..."
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	docker images -a
	docker rmi -f $(docker images -aq) || true
	docker network ls
	docker network prune
	docker volume ls
	docker volume prune
	docker system prune -a --volumes
	docker system prune --volumes -f

docker-clean: ## Clean Docker resources
	@echo "Cleaning Docker resources..."
	docker system prune --volumes -f

sql: ## Start SQL database access
	$(SQL_SCRIPT)

train: ## Train the full Rasa model
	rasa train --domain $(DOMAIN) --data $(DATA) --config $(config_supervised) --out $(MODEL)

train-nlu: ## Train only the NLU model
	rasa train nlu --nlu $(DATA)/nlu --config $(config_supervised) --out $(MODEL)/nlu

run-actions: ## Run the action server
	rasa run actions --actions $(ACTION) --cors "*" --debug

shell: ## Run an interactive Rasa shell
	$(MAKE) run-actions &
	rasa shell -m $(MODEL) --endpoints $(ENDPOINT)

run: ## Run the Rasa server with React web app
	$(MAKE) run-actions &
	rasa run --enable-api -m $(MODEL) --cors "*" --debug

validate: ## Validate the Rasa files
	rasa data validate --domain $(DOMAIN) --data $(DATA) --config $(config_supervised)

clean: ## Clean up generated files and caches
	@echo "Cleaning up generated files and caches..."
	$(RM) $(MODEL)/*
	$(RM_DIR) __pycache__
	$(RM_DIR) .rasa
	$(RM_DIR) .keras

help: ## Display help
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
