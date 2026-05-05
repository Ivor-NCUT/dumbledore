#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"
SLUG="${2:-}"
RAW_DIR="${DUMBLEDORE_RAW_DIR:-raw}"
TMP_ROOT="${DUMBLEDORE_TMP_DIR:-.dumbledore/tmp/wechat}"

if [ -z "$URL" ]; then
  echo "Usage: scripts/fetch-wechat-article.sh <mp.weixin.qq.com URL> [slug]" >&2
  exit 1
fi

case "$URL" in
  *mp.weixin.qq.com/*) ;;
  *)
    echo "Not a WeChat article URL: ${URL}" >&2
    exit 1
    ;;
esac

if command -v wechat-article-to-markdown >/dev/null 2>&1; then
  CONVERTER=(wechat-article-to-markdown)
elif command -v uvx >/dev/null 2>&1; then
  CONVERTER=(uvx wechat-article-to-markdown)
elif command -v uv >/dev/null 2>&1; then
  CONVERTER=(uv tool run wechat-article-to-markdown)
else
  echo "Missing converter. Install it with one of:" >&2
  echo "  uv tool install wechat-article-to-markdown" >&2
  echo "  pipx install wechat-article-to-markdown" >&2
  echo "Or install the agent skill:" >&2
  echo "  npx skills add jackwener/wechat-article-to-markdown" >&2
  exit 1
fi

DATE_PREFIX="$(date +"%Y%m%d")"
RUN_DIR="${TMP_ROOT}/${DATE_PREFIX}-$$"
mkdir -p "$RUN_DIR" "$RAW_DIR"

echo "Fetching WeChat article..."
"${CONVERTER[@]}" "$URL" -o "$RUN_DIR"

MD_PATH="$(find "$RUN_DIR" -type f -name "*.md" | head -n 1)"
if [ -z "$MD_PATH" ]; then
  echo "Converter did not produce a Markdown file." >&2
  exit 1
fi

TITLE="$(sed -n 's/^# //p' "$MD_PATH" | head -n 1)"
if [ -z "$TITLE" ]; then
  TITLE="$(basename "$MD_PATH" .md)"
fi

if [ -z "$SLUG" ]; then
  SLUG="$(printf "%s" "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9一-龥]/-/g; s/-\{2,\}/-/g; s/^-//; s/-$//' | cut -c 1-60)"
fi

if [ -z "$SLUG" ]; then
  SLUG="wechat-article"
fi

TARGET_BASENAME="${DATE_PREFIX}_${SLUG}"
TARGET_MD="${RAW_DIR}/${TARGET_BASENAME}.md"
TARGET_IMAGES="${RAW_DIR}/${TARGET_BASENAME}_images"

cp "$MD_PATH" "$TARGET_MD"

SOURCE_IMAGES="$(dirname "$MD_PATH")/images"
if [ -d "$SOURCE_IMAGES" ]; then
  rm -rf "$TARGET_IMAGES"
  cp -R "$SOURCE_IMAGES" "$TARGET_IMAGES"
  sed -i.bak "s#](images/#](${TARGET_BASENAME}_images/#g" "$TARGET_MD"
  rm -f "${TARGET_MD}.bak"
fi

echo "Saved Markdown: ${TARGET_MD}"
if [ -d "$TARGET_IMAGES" ]; then
  echo "Saved images: ${TARGET_IMAGES}"
fi
