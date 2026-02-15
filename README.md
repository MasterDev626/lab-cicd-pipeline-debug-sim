# CI/CD Pipeline Debug & Release Simulation Lab

A hands-on DevOps lab where you'll fix a broken CI/CD pipeline, make flaky tests deterministic, build Docker images, and manage releases.

## Overview 🎯

**Objective:** Build, test, and deploy a web application automatically using a complete CI/CD pipeline.

**Technologies:** Node.js, Express, Jest, Docker, GitHub Actions (or local simulator)

**Duration:** ~75 minutes

**Difficulty:** Intermediate

## What You'll Learn 📚

- CI/CD pipeline architecture and execution
- Debugging failing tests and fixing flakiness
- Docker containerization in CI/CD
- Build artifacts and release management
- Pipeline orchestration and automation

## Lab Structure

```
lab-cicd-pipeline-debug-sim/
├── .gitignore                 # Git ignore rules
├── Dockerfile                 # Container image definition
├── README.md                  # This file
├── package.json              # Node.js dependencies & scripts
├── package-lock.json         # Dependency lock file
├── jest.config.js            # Jest test configuration
├── ci/
│   └── ci.yaml              # GitHub Actions pipeline (YAML)
├── scripts/
│   └── ci-sim.sh            # Local pipeline simulator (bash)
├── src/
│   ├── app.js               # Express API application
│   └── index.js             # Application entry point
├── tests/
│   └── app.test.js          # Jest unit tests
└── artifacts/               # Build output (generated)
    └── dist.tar.gz          # Compressed distributions
```

## Quick Start 🚀

### 1. Clone and setup

```bash
cd /Users/masterdevops/Documents/Testing
git clone https://github.com/MasterDev626/lab-cicd-pipeline-debug-sim.git
cd lab-cicd-pipeline-debug-sim
git checkout -b fix/pipeline
npm install
```

### 2. Run the pipeline (will show failures)

```bash
./scripts/ci-sim.sh
```

**Expected outcome:** Pipeline fails on missing lint/build scripts or flaky tests.

### 3. Fix issues (follow steps below)

### 4. Run the pipeline again

```bash
./scripts/ci-sim.sh
```

**Expected outcome:** All 7 stages pass ✓

### 5. Commit and tag release

```bash
git add .
git commit -m "fix: pipeline - add lint/build, fix flaky tests"
git tag v0.1.0-rc1
git log --oneline
```

## Pipeline Stages (7 steps)

The `./scripts/ci-sim.sh` runs these stages in order:

| # | Stage | Command | Purpose |
|---|-------|---------|---------|
| 1 | Install | `npm ci --silent` | Install locked dependencies |
| 2 | Lint | `npm run lint` | Check code quality |
| 3 | Test | `npm test` | Run unit tests with Jest |
| 4 | Build | `npm run build` | Compile/package application |
| 5 | Docker | `docker build -t md-cicd-sim:local .` | Build container image |
| 6 | Artifacts | `tar -czf artifacts/dist.tar.gz` | Package distribution |
| 7 | Audit | `npm audit` | Security vulnerability check |

### Expected Failures & Fixes

#### ❌ Stage 2 Fails (Lint)
**Problem:** `npm run lint` not defined in `package.json`  
**Fix:** Add to `package.json` scripts:
```json
"lint": "node -e \"require('fs').readFileSync('src/app.js'); require('fs').readFileSync('src/index.js'); process.exit(0)\""
```

Or use ESLint:
```bash
npm install --save-dev eslint
npx eslint --init
# Then update package.json:
"lint": "eslint src/"
```

#### ❌ Stage 3 Fails (Tests)
**Problem:** Tests are flaky (timing-dependent, non-deterministic)  
**Fix:** In `tests/app.test.js`:
- Remove or relax timing assertions (e.g., `expect(ms).toBeLessThan(100)`)
- Avoid asserting on `Date.now()` or `new Date()`
- Use loose assertions: `expect(result).toBeDefined()`
- Each test should be independent (no shared state)

#### ❌ Stage 4 Fails (Build)
**Problem:** `npm run build` not defined in `package.json`  
**Fix:** Add to `package.json` scripts:
```json
"build": "mkdir -p dist && cp -r src dist/ && cp package*.json dist/"
```

#### ❌ Stage 5 Fails (Docker)
**Problem:** Dockerfile missing or incorrect  
**Fix:** Ensure `Dockerfile` exists:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY src ./src
EXPOSE 3000
CMD ["node", "src/index.js"]
```

Also ensure `package-lock.json` is committed:
```bash
npm install  # generates package-lock.json
git add package-lock.json
```

#### ❌ Stage 6 Fails (Artifacts)
**Problem:** `dist/` folder doesn't exist after build  
**Fix:** Ensure `npm run build` creates the `dist/` directory:
```bash
npm run build
ls -R dist/  # Should show src/ and package.json
```

## Key Commands 📋

```bash
# Install dependencies
npm install

# Run all tests
npm test

# Run linter
npm run lint

# Build application
npm run build

# Start application (local)
npm start

# Run full CI/CD pipeline
./scripts/ci-sim.sh

# Build Docker image
docker build -t md-cicd-sim:local .

# Run container
docker run -p 3000:3000 md-cicd-sim:local

# Check Docker image
docker image ls | grep md-cicd-sim

# View build artifacts
ls -lh artifacts/

# Extract and inspect artifacts
tar -tzf artifacts/dist.tar.gz | head -20

# Security audit
npm audit
npm audit --fix  # Auto-fix vulnerable packages
```

## Application Features 🔧

The Express API includes:

### GET /health
Health check endpoint
```bash
curl http://localhost:3000/health
```
Response:
```json
{
  "status": "ok",
  "timestamp": "2026-02-15T10:00:00.000Z",
  "version": "0.1.0"
}
```

### GET /api/version
Version information
```bash
curl http://localhost:3000/api/version
```

### POST /api/echo
Echo a message back
```bash
curl -X POST http://localhost:3000/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, CI/CD!"}'
```

### POST /api/add
Add two numbers
```bash
curl -X POST http://localhost:3000/api/add \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'
```
Response:
```json
{
  "result": 8,
  "operands": { "a": 5, "b": 3 }
}
```

## Testing 🧪

Run tests with Jest:

```bash
# Run all tests
npm test

# Run tests with coverage
npm test -- --coverage

# Run specific test file
npm test app.test.js

# Watch mode (re-run on file changes)
npm test -- --watch
```

## Docker Usage 🐳

Build and run the application in a container:

```bash
# Build image
docker build -t md-cicd-sim:local .

# Run container
docker run -p 3000:3000 md-cicd-sim:local

# Test health endpoint
curl http://localhost:3000/health

# Stop container
docker stop <container-id>
```

## Git Workflow 🔄

```bash
# Create feature branch
git checkout -b fix/pipeline

# Make changes and commit
git add .
git commit -m "fix: pipeline - add lint/build scripts"

# Review changes
git log --oneline -5
git diff main

# Tag release
git tag v0.1.0-rc1
git tag -l

# (Optional) Push to remote
git push origin fix/pipeline
git push origin v0.1.0-rc1
```

## Troubleshooting 🔧

| Issue | Solution |
|-------|----------|
| `npm ci` fails | Delete `node_modules/` and `package-lock.json`, then run `npm install` |
| Tests are flaky | Make tests deterministic: avoid timing assertions, use mocks |
| Build creates no artifacts | Ensure `npm run build` runs successfully and creates `dist/` |
| Docker build fails | Check Dockerfile syntax, ensure base image exists, verify `package*.json` |
| Port 3000 already in use | Kill existing process: `lsof -i :3000` then `kill -9 <PID>` |

## Next Steps 🎓

After completing the lab:

1. **Extend tests:** Add more test cases for edge cases and error handling
2. **Add CI stages:** Add code coverage checks, performance tests, security scans
3. **Deploy:** Push to GitHub and trigger the real GitHub Actions workflow
4. **Monitor:** Add logging and monitoring endpoints for production
5. **Scale:** Add database, caching, load balancing

## Resources 📖

- [Jest Documentation](https://jestjs.io/)
- [Express.js Guide](https://expressjs.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [GitHub Actions](https://docs.github.com/en/actions)

## Lab Checklist ✅

Complete these to finish the lab:

- [ ] Clone repo and create feature branch
- [ ] Run `./scripts/ci-sim.sh` (see failures)
- [ ] Add `lint` script to `package.json`
- [ ] Add `build` script to `package.json`
- [ ] Fix flaky tests in `tests/app.test.js`
- [ ] Run `./scripts/ci-sim.sh` again (all pass)
- [ ] Build Docker image locally
- [ ] Run container and test endpoints
- [ ] Create build artifacts
- [ ] Commit changes with meaningful message
- [ ] Tag release (e.g., `v0.1.0`)
- [ ] Review git log and tags

## Summary

This lab teaches you how CI/CD pipelines work in practice:

- **Build:** Compile and package your code
- **Test:** Verify functionality with automated tests
- **Lint:** Check code quality and consistency
- **Container:** Package with Docker for deployment
- **Release:** Tag and version your builds
- **Automate:** Run all steps on every push

By the end, you'll have a fully functional pipeline that can build, test, and package your application automatically! 🚀

---

**Status:** ✅ Complete lab with all 7 stages passing  
**Last Updated:** February 15, 2026  
**Tested With:** Node 18+, Docker, npm
