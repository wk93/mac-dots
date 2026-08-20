#!/usr/bin/env bash
set -euo pipefail

BASE="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
PIN="$(cd "$(dirname "$0")/.." && pwd)/modules/claude-code-pin.nix"

VERSION=$(curl -fsSL "$BASE/latest")
CURRENT=$(awk -F'"' '/version =/ {print $2}' "$PIN")

if [[ "$VERSION" == "$CURRENT" ]]; then
  echo "claude-code already at $VERSION"
  exit 0
fi

HASH=$(nix-prefetch-url --type sha256 "$BASE/$VERSION/darwin-arm64/claude")
SRI=$(nix hash convert --hash-algo sha256 --to sri "$HASH" 2>/dev/null \
  || nix hash to-sri --type sha256 "$HASH")

cat > "$PIN" <<EOF
{
  version = "$VERSION";
  hash = "$SRI";
}
EOF

echo "claude-code: $CURRENT -> $VERSION"
