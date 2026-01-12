# Makefile

ARCH := $(shell uname -m)

# Detect architecture (arm64 vs amd64)
ifeq ($(ARCH),arm64)
  LOKI_PLUGIN_TAG := grafana/loki-docker-driver:3.3.2-arm64
else
  LOKI_PLUGIN_TAG := grafana/loki-docker-driver:3.3.2-amd64
endif

.PHONY: loki-plugin
loki-plugin:
	@echo "Checking if Loki Docker driver plugin is installed..."
	@if ! docker plugin ls --format '{{.Name}}' | grep -q '^loki:'; then \
		echo "Installing Loki plugin for $(ARCH)..."; \
		docker plugin install $(LOKI_PLUGIN_TAG) --alias loki --grant-all-permissions; \
	else \
		echo "Loki plugin already installed."; \
	fi

.PHONY: start
start: loki-plugin
	@echo "🚀 Starting all services..."
	docker compose up

.PHONY: stop
stop:
	@echo "🛑 Stopping all services..."
	docker compose down

.PHONY: rebuild
rebuild: loki-plugin
	@echo "🔄 Rebuilding containers..."
	docker compose build --no-cache
	docker compose up -d

.PHONY: lint
lint:
	@docker compose run --rm --no-deps observability-service sh -c "ruff format . ; ruff check . ; mypy ."

.PHONY: update-dependencies
update-dependencies:
	@docker compose run --rm --no-deps observability-service uv lock

.PHONY: test-siege
test-siege: ## Run siege load test
	@echo "Running siege load test..."
	bash request-script.sh

.PHONY: test-curl
test-curl: ## Run single curl request with trace
	@echo "Running curl with trace injection..."
	bash trace.sh

.PHONY: test-locust
test-locust: ## Run locust load test (10 users, 5 min)
	@echo "Running locust load test..."
	@command -v locust >/dev/null 2>&1 || { echo "Installing locust..."; pip3 install locust; }
	locust -f locustfile.py --headless --users 10 --spawn-rate 1 -H http://localhost:8000 --run-time 5m

.PHONY: test-k6
test-k6: ## Run k6 load test (1 user, 5 min)
	@echo "Running k6 load test..."
	docker run --rm -i --network=host grafana/k6:latest run --vus 1 --duration 5m - <k6-script.js
	@command -v k6 >/dev/null 2>&1 || { echo "Error: k6 is not installed. Install from https://k6.io/docs/get-started/installation/"; exit 1; }
	k6 run --vus 1 --duration 5m k6-script.js
