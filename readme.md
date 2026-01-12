# FastAPI with Observability

Observe the FastAPI application with three pillars of observability on [Grafana](https://github.com/grafana/grafana):

1. Traces with [Tempo](https://github.com/grafana/tempo) and [OpenTelemetry Python SDK](https://github.com/open-telemetry/opentelemetry-python)
2. Metrics with [Prometheus](https://prometheus.io/) and [Prometheus Python Client](https://github.com/prometheus/client_python)
3. Logs with [Loki](https://github.com/grafana/loki)

![Observability Architecture](./images/observability-arch.jpg)

## Prerequisites

* Python 3.14 or higher
* UV package manager
* Installing UV
If you don't have UV installed, install it using one of these methods:

```bash
    # macOS/Linux
    curl -LsSf https://astral.sh/uv/install.sh | sh
```
```bash
    # Or using pip
    pip install uv
```
```bash
    # Or using Homebrew (macOS)
    brew install uv
```

uv sync
uv run main.py

## Quick Start
1. Clone this repository

   ```bash
   git clone
   
2. Start all services with docker-compose

   ```bash
   make start
   ```

3. Send requests with [siege](https://linux.die.net/man/1/siege) and curl to the FastAPI app

   ```bash
    make test-siege
   ```

   Or you can use [Locust](https://locust.io/) to send requests:

   ```bash
    make  test-locust 
   ```

   Or you can send requests with [k6](https://k6.io/):

   ```bash
   make test-k6
   ```

4. Check predefined dashboard `FastAPI Observability` on Grafana [http://localhost:3000/](http://localhost:3000/) login with `admin:admin`

   Dashboard screenshot:

   ![FastAPI Monitoring Dashboard](./images/dashboard.png)

   The dashboard is also available on [Grafana Dashboards](https://grafana.com/grafana/dashboards/16110).
