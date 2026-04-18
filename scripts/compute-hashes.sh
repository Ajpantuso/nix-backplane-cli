#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 v0.8.0"
  exit 1
fi

VERSION_NUM="${VERSION#v}"

echo "Computing hashes for ocm-backplane version ${VERSION_NUM}..."
echo ""

PLATFORMS=(
  "Linux_x86_64:x86_64-linux"
  "Linux_arm64:aarch64-linux"
  "Darwin_x86_64:x86_64-darwin"
  "Darwin_arm64:aarch64-darwin"
)

for platform_info in "${PLATFORMS[@]}"; do
  IFS=':' read -r platform_name nix_platform <<< "$platform_info"

  url="https://github.com/openshift/backplane-cli/releases/download/v${VERSION_NUM}/ocm-backplane_${VERSION_NUM}_${platform_name}.tar.gz"

  echo "Fetching ${nix_platform}..."
  hash=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
  sri_hash=$(nix hash convert --to sri "sha256:${hash}")

  echo "  ${nix_platform} = {"
  echo "    url = \"${url}\";"
  echo "    sha256 = \"${sri_hash}\";"
  echo "  };"
  echo ""
done

echo "Done! Copy the hashes above into flake.nix"
