#!/usr/bin/env bash
# set_cover.sh — convert any image to repo cover.png and push
# Usage: ./scripts/set_cover.sh /path/to/image
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/image" >&2
  exit 1
fi

SRC="$1"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DST="$REPO_DIR/cover.png"

# Ensure source exists
if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC" >&2
  exit 1
fi

# Convert to PNG suitable for GitHub README
# Try sips (built-in). If it fails, try ImageMagick if present. Otherwise copy as-is.
if command -v sips >/dev/null 2>&1; then
  if ! sips -s format png "$SRC" --out "$DST" >/dev/null 2>&1; then
    if command -v magick >/dev/null 2>&1; then
      magick "$SRC" -strip -resize 2000x2000\> "$DST"
    else
      cp "$SRC" "$DST"
    fi
  fi
elif command -v magick >/dev/null 2>&1; then
  magick "$SRC" -strip -resize 2000x2000\> "$DST"
else
  cp "$SRC" "$DST"
fi

# Verify PNG bytes
if ! file "$DST" | grep -qi 'PNG image data'; then
  echo "Warning: output may not be a valid PNG. Consider installing ImageMagick (magick)." >&2
fi

# Commit and push
git -C "$REPO_DIR" add cover.png
if ! git -C "$REPO_DIR" commit -m "Set README cover image" >/dev/null 2>&1; then
  echo "No commit needed (cover unchanged)."
fi

git -C "$REPO_DIR" push origin main

echo "Cover set. Preview: https://github.com/Eriiiick/ai-agents-best-practices/blob/main/cover.png"
