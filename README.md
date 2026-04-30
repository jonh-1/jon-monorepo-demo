# Workspaces Monorepo

Quick example of a uv workspaces monorepo with an `agents` package that consumes an `internal` package. 

## Setup

### Environment

Create a `.env.local` at the root of the project with your LiveKit credentials:
```
LIVEKIT_API_KEY=
LIVEKIT_API_SECRET=
LIVEKIT_URL=
```

### Installation

Install the project dependenices with `uv sync`.

## Running the agent

Run the agent in the console with:
```
uv run --package agent python packages/agent/src/agent.py console
```

## Deploying the agent

Deploy the agent to LiveKit Cloud by running `lk agent create` at the root of the monorepo.