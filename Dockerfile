FROM python:3.14-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsodium23 \
    wget \
    build-essential \
    libffi-dev \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Environment variables
ENV UV_SYSTEM_PYTHON=0 \
    UV_NO_CACHE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON=python3 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/root/.local/bin:$PATH" \
    PYTHONPATH="${PYTHONPATH}:/app"

# Install uv (instead of Poetry)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy dependency files
COPY pyproject.toml uv.lock /app/

# Install dependencies
RUN uv sync --frozen --no-install-project

# Copy source
COPY observability_service/ /app/observability_service/
