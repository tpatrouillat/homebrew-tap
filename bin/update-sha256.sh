#!/usr/bin/env bash
# Update the sha256 of a formula after a new GitHub release tarball is published.
#
# Usage:
#   bin/update-sha256.sh <formula-name> <git-tag>
#
# Example:
#   bin/update-sha256.sh tokease v1.0.0
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <formula-name> <git-tag>" >&2
    exit 1
fi

FORMULA="$1"
TAG="$2"
OWNER="tpatrouillat"   # GitHub owner — update if you fork
FORMULA_FILE="Formula/${FORMULA}.rb"

if [[ ! -f "$FORMULA_FILE" ]]; then
    echo "No such formula: $FORMULA_FILE" >&2
    exit 1
fi

REPO="$FORMULA"
TARBALL_URL="https://github.com/${OWNER}/${REPO}/archive/refs/tags/${TAG}.tar.gz"

echo "Fetching $TARBALL_URL..."
TMPFILE="$(mktemp -t "${FORMULA}.XXXXXX").tar.gz"
trap 'rm -f "$TMPFILE"' EXIT
curl -fsSL -o "$TMPFILE" "$TARBALL_URL"

SHA="$(shasum -a 256 "$TMPFILE" | awk '{print $1}')"
echo "Computed sha256: $SHA"

# Update the url and sha256 lines in place. macOS sed needs -i ''.
sed -i '' -E \
    -e "s|^(\s*url\s+\").*\"|\1${TARBALL_URL}\"|" \
    -e "s|^(\s*sha256\s+\")[0-9a-f]+(\")|\1${SHA}\2|" \
    "$FORMULA_FILE"

echo "Updated $FORMULA_FILE — diff:"
git --no-pager diff "$FORMULA_FILE" || true
