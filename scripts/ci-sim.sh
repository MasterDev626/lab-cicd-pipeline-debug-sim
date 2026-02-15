#!/usr/bin/env bash
# CI/CD Pipeline Simulation — runs locally, mimics a real pipeline.
# Fix the repo so this script passes all stages.

set -e
on_fail() { echo ""; echo "=== PIPELINE FAILED ==="; exit 1; }
trap on_fail ERR
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "=== CI SIM: Starting pipeline ==="

# Stage 1: Install
echo "[1/7] Install dependencies..."
npm ci --silent
echo "  ✓ Install OK"

# Stage 2: Lint
echo "[2/7] Lint..."
npm run lint --silent
echo "  ✓ Lint OK"

# Stage 3: Test
echo "[3/7] Test..."
npm test --silent
echo "  ✓ Test OK"

# Stage 4: Build
echo "[4/7] Build..."
npm run build --silent
echo "  ✓ Build OK"

# Stage 5: Docker
echo "[5/7] Docker build..."
docker build -t md-cicd-sim:local .
echo "  ✓ Docker OK"

# Stage 6: Artifacts
echo "[6/7] Produce artifacts..."
mkdir -p artifacts
tar -czf artifacts/dist.tar.gz -C dist . || { echo "  ✗ Artifacts FAILED (dist/ missing?)"; exit 1; }
echo "  ✓ Artifacts OK"

# Stage 7: Audit
echo "[7/7] Security audit..."
npm audit --json > artifacts/audit-report.json 2>/dev/null || npm audit 2>&1 | tee artifacts/audit-report.txt
echo "  ✓ Audit OK"

echo ""
echo "=== PIPELINE PASSED ==="
echo "All stages completed successfully."
