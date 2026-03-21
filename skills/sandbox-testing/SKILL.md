---
name: sandbox-testing
description: Use when running tests in a Docker sandbox environment — isolated containers for integration testing, E2E testing with Playwright, or testing against mock services. Use when you need a clean, reproducible test environment.
---

# Sandbox Testing

## Overview

Run tests inside a Docker-based sandbox that provides an isolated, reproducible environment. The sandbox spins up the application and its dependencies (databases, mock services, etc.) via Docker Compose, then runs tests against them. This prevents test pollution and ensures CI/CD parity.

## Prerequisites

- Docker and Docker Compose installed and running
- A sandbox setup script (e.g., `scripts/sandbox.sh`, `scripts/test-sandbox.sh`, or equivalent)
- A `docker-compose.yml` (or `docker-compose.test.yml`) defining the test environment
- Playwright or similar E2E framework if running browser tests

## Workflow

### 1. Start the Sandbox

```bash
# Using a project sandbox script (check your project for the exact name)
./scripts/sandbox.sh up

# Or directly with Docker Compose
docker compose -f docker-compose.test.yml up -d
```

Wait for all services to be healthy before running tests. Check with:

```bash
docker compose -f docker-compose.test.yml ps
```

### 2. Run Tests

#### Unit / Integration Tests

```bash
# Run tests inside the app container
docker compose -f docker-compose.test.yml exec app npm test

# Or run from host if the app connects to containerized services
npm test
```

#### E2E Tests (Playwright)

```bash
# Run Playwright tests against the sandboxed app
npx playwright test

# Or inside the container if Playwright is containerized
docker compose -f docker-compose.test.yml exec playwright npx playwright test
```

#### Targeted Test Runs

```bash
# Run a specific test file
npx playwright test tests/feature-name.spec.ts

# Run tests matching a pattern
npx playwright test --grep "feature description"
```

### 3. Inspect Failures

```bash
# View container logs
docker compose -f docker-compose.test.yml logs app
docker compose -f docker-compose.test.yml logs -f app  # follow mode

# Open a shell in the app container for debugging
docker compose -f docker-compose.test.yml exec app sh

# View Playwright report (if tests ran on host)
npx playwright show-report
```

### 4. Reset State

If tests leave dirty state, reset without full teardown:

```bash
# Restart a specific service
docker compose -f docker-compose.test.yml restart app

# Or recreate containers (keeps volumes)
docker compose -f docker-compose.test.yml up -d --force-recreate

# Nuclear option — tear down and rebuild everything including volumes
docker compose -f docker-compose.test.yml down -v
docker compose -f docker-compose.test.yml up -d --build
```

### 5. Tear Down

```bash
# Stop and remove containers
docker compose -f docker-compose.test.yml down

# Also remove volumes (database data, caches, etc.)
docker compose -f docker-compose.test.yml down -v

# Clean up project sandbox script (if available)
./scripts/sandbox.sh down
```

## Common Docker Compose Services

A typical test sandbox includes some combination of:

| Service | Purpose |
|---------|---------|
| `app` | The application under test |
| `db` / `postgres` / `mysql` | Database with test schema |
| `redis` | Cache / queue for integration tests |
| `mock-api` | Mock of external APIs the app depends on |
| `playwright` | Browser test runner (if containerized) |

## Tips

- **Port conflicts:** If the sandbox uses the same ports as your dev environment, stop the dev server first or use different port mappings in the test compose file.
- **Build caching:** Use `docker compose build` separately before `up` to leverage layer caching and speed up iteration.
- **Volume mounts:** Mount source code as a volume for fast iteration without rebuilding: `volumes: ["./src:/app/src"]`
- **Environment variables:** Use a `.env.test` file or `env_file` in compose to configure test-specific settings.
- **Parallel test runs:** Playwright supports `--workers` flag to parallelize browser tests.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Running tests before services are healthy | Use `depends_on` with health checks in compose, or poll the health endpoint |
| Forgetting to rebuild after code changes | Run `docker compose build` or use `up --build` flag |
| Port conflicts with dev environment | Use a separate compose file with different port mappings for tests |
| Stale volumes causing test pollution | Use `down -v` between test runs that need clean state |
| Running E2E tests against wrong URL | Check `baseURL` in Playwright config matches the sandbox's exposed port |
| Leaving sandbox running after tests | Always tear down — orphaned containers waste resources and cause port conflicts |
