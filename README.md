# lab-cicd-pipeline-debug-sim

CI/CD Pipeline Debug & Release Simulation — a hands-on lab where you fix a broken pipeline, add missing stages, and ship a release candidate.

## What you'll do

You'll work through a simulated on-call scenario: the pipeline is red, tests are flaky, and the Docker build is failing. Your job is to:

- Clone the repo and create a working branch
- Fix the pipeline configuration (`ci/ci.yaml`)
- Make tests deterministic
- Add lint and build stages
- Dockerize the app correctly
- Add caching, artifacts, and security audit
- Run the full pipeline end-to-end
- Document changes and tag a release candidate

## Prerequisites

- Node.js 18+
- Docker
- Git

## Setup

```bash
git clone https://github.com/MasterDev626/lab-cicd-pipeline-debug-sim.git
cd lab-cicd-pipeline-debug-sim
npm install
```

## Run the pipeline locally

The lab uses a local CI simulation script:

```bash
./scripts/ci-sim.sh
```

Initially this will fail. Work through the lab steps to fix each stage until the pipeline passes.

## Project structure

- `src/` — application code
- `tests/` — Jest tests
- `ci/ci.yaml` — pipeline config (GitHub Actions style, used as reference)
- `scripts/ci-sim.sh` — local pipeline runner
- `Dockerfile` — container definition

## License

MIT

---

**Built by [Tawanda Mashoko](https://github.com/TawandaMashoko)**
