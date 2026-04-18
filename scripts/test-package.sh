#!/usr/bin/env bash
set -euo pipefail

echo "Building ocm-backplane package..."
nix build .#ocm-backplane

echo ""
echo "Testing ocm-backplane binary..."
./result/bin/ocm-backplane version

echo ""
echo "Checking binary is executable..."
if [ -x ./result/bin/ocm-backplane ]; then
  echo "OK: Binary is executable"
else
  echo "ERROR: Binary is not executable"
  exit 1
fi

echo ""
echo "All tests passed"
