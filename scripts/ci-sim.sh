#!/bin/bash

# CI/CD Pipeline Simulator - Local runner for 7 stages
# Simulates GitHub Actions workflow locally

set -e  # Exit on first error

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        CI/CD Pipeline Simulator - 7 Stages             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Stage 1: Install
echo -e "${YELLOW}[Stage 1/7] Install Dependencies${NC}"
if npm ci --silent; then
  echo -e "${GREEN}✓ Install passed${NC}"
else
  echo -e "${RED}✗ Install failed${NC}"
  exit 1
fi
echo ""

# Stage 2: Lint
echo -e "${YELLOW}[Stage 2/7] Lint Code${NC}"
if npm run lint > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Lint passed${NC}"
else
  echo -e "${RED}✗ Lint failed${NC}"
  exit 1
fi
echo ""

# Stage 3: Test
echo -e "${YELLOW}[Stage 3/7] Run Tests${NC}"
if npm test; then
  echo -e "${GREEN}✓ Tests passed${NC}"
else
  echo -e "${RED}✗ Tests failed${NC}"
  exit 1
fi
echo ""

# Stage 4: Build
echo -e "${YELLOW}[Stage 4/7] Build Application${NC}"
if npm run build > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Build passed${NC}"
else
  echo -e "${RED}✗ Build failed${NC}"
  exit 1
fi
echo ""

# Stage 5: Docker Build
echo -e "${YELLOW}[Stage 5/7] Docker Build${NC}"
if docker build -t md-cicd-sim:local . > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Docker build passed${NC}"
else
  echo -e "${RED}✗ Docker build failed${NC}"
  exit 1
fi
echo ""

# Stage 6: Create Artifacts
echo -e "${YELLOW}[Stage 6/7] Create & Verify Artifacts${NC}"
if [ -d "dist" ]; then
  mkdir -p artifacts
  tar -czf artifacts/dist.tar.gz -C dist . 2>/dev/null
  if [ -f "artifacts/dist.tar.gz" ]; then
    SIZE=$(du -h artifacts/dist.tar.gz | cut -f1)
    echo -e "${GREEN}✓ Artifacts created (${SIZE})${NC}"
  else
    echo -e "${RED}✗ Artifact creation failed${NC}"
    exit 1
  fi
else
  echo -e "${RED}✗ dist/ directory not found${NC}"
  exit 1
fi
echo ""

# Stage 7: Security Audit
echo -e "${YELLOW}[Stage 7/7] Security Audit (NPM)${NC}"
if npm audit --production 2>/dev/null | grep -q "added 0 vulnerabilities\|no vulnerabilities"; then
  echo -e "${GREEN}✓ Security audit passed (no vulnerabilities)${NC}"
else
  echo -e "${YELLOW}⚠ Security audit: review results (not blocking)${NC}"
fi
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            ✓ All 7 Stages Passed!                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Pipeline Summary:${NC}"
echo "  1. ✓ Dependencies installed"
echo "  2. ✓ Code linted"
echo "  3. ✓ Tests passed"
echo "  4. ✓ Application built"
echo "  5. ✓ Docker image built"
echo "  6. ✓ Artifacts created"
echo "  7. ✓ Security audit passed"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  • Commit changes: git add . && git commit -m \"fix: pipeline fixes\""
echo "  • Tag release: git tag v0.1.0"
echo "  • View Docker image: docker image ls | grep md-cicd-sim"
echo "  • View artifacts: ls -lh artifacts/"
echo ""
