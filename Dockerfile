# syntax=docker/dockerfile:1
#
# uv workspace image: installs ``agent-starter-python`` + workspace ``internal``.
#
# Build (always use the repository root as context):
#
#   docker build -f Dockerfile .
#
# LiveKit Cloud: ``lk`` uploads only the *working directory* you pass to it. You must run
# ``lk agent create`` / ``lk agent deploy`` from this directory (the monorepo root), e.g.:
#
#   cd /path/to/livekit-uv-workspace
#   lk agent create .
#
# Running ``lk`` from ``packages/agent`` alone cannot include ``../internal`` or the root
# ``uv.lock`` in the build context (Docker cannot COPY outside the context).

ARG PYTHON_VERSION=3.13
FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-bookworm-slim AS base

ENV PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1

FROM base AS build

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml uv.lock ./
COPY src/livekit_uv_workspace ./src/livekit_uv_workspace/
COPY packages/internal ./packages/internal/
COPY packages/agent ./packages/agent/

RUN uv sync --locked --package agent-starter-python --no-dev

RUN uv run --package agent-starter-python python packages/agent/src/agent.py download-files

FROM base

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/app" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    appuser

COPY --from=build --chown=appuser:appuser /app /app

WORKDIR /app
USER appuser

CMD ["uv", "run", "--package", "agent-starter-python", "python", "packages/agent/src/agent.py", "start"]
