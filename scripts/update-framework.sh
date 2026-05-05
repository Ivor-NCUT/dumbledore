#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${DUMBLEDORE_STATE_FILE:-.dumbledore/state.json}"
DEFAULT_REPO="Ivor-NCUT/dumbledore"
DEFAULT_BRANCH="main"
YES="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --yes|-y)
      YES="true"
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage: scripts/update-framework.sh [--yes]

Updates framework-owned Dumbledore files from the upstream repository while
preserving user knowledge directories such as raw/, atoms/, and user-created
brain pages. A backup archive is created before files are replaced.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

json_value() {
  local key="$1"
  local file="$2"
  sed -n "s/.*\"${key}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file" | head -n 1
}

has_tty() {
  [ -t 0 ]
}

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: ${command_name}" >&2
    exit 1
  fi
}

update_state() {
  local repo="$1"
  local branch="$2"
  local commit="$3"
  local checked_at="$4"

  if ! command -v node >/dev/null 2>&1; then
    echo "Updated files, but could not update ${STATE_FILE}: node is not installed." >&2
    return 0
  fi

  STATE_FILE="$STATE_FILE" \
  REPO="$repo" \
  BRANCH="$branch" \
  COMMIT="$commit" \
  CHECKED_AT="$checked_at" \
  node <<'NODE'
const fs = require("fs");
const stateFile = process.env.STATE_FILE;
const state = JSON.parse(fs.readFileSync(stateFile, "utf8"));
state.version = Math.max(Number(state.version || 1), 2);
state.framework_upstream_repo = process.env.REPO;
state.framework_upstream_branch = process.env.BRANCH;
state.framework_upstream_commit = process.env.COMMIT;
state.framework_last_update_check_at = process.env.CHECKED_AT;
fs.writeFileSync(stateFile, `${JSON.stringify(state, null, 2)}\n`);
NODE
}

require_command curl
require_command tar
require_command git

if [ ! -f "$STATE_FILE" ]; then
  echo "Missing ${STATE_FILE}. Run Dumbledore onboarding first." >&2
  exit 1
fi

REPO="$(json_value "framework_upstream_repo" "$STATE_FILE")"
BRANCH="$(json_value "framework_upstream_branch" "$STATE_FILE")"

if [ -z "$REPO" ]; then
  REPO="$DEFAULT_REPO"
fi

if [ -z "$BRANCH" ]; then
  BRANCH="$DEFAULT_BRANCH"
fi

LATEST_COMMIT="$(git ls-remote "https://github.com/${REPO}.git" "refs/heads/${BRANCH}" 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
if [ -z "$LATEST_COMMIT" ]; then
  echo "Could not reach upstream ${REPO}." >&2
  exit 1
fi

if [ "$YES" != "true" ]; then
  if has_tty; then
    answer=""
    printf "Update Dumbledore framework from %s@%s? [y/N]: " "$REPO" "$LATEST_COMMIT"
    read -r answer </dev/tty || true
    case "${answer:-}" in
      y|Y|yes|YES) ;;
      *) echo "Skipped update."; exit 0 ;;
    esac
  else
    echo "Refusing non-interactive update without --yes." >&2
    exit 1
  fi
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
echo "Downloading Dumbledore framework update..."
curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP_DIR" --strip-components=1

BACKUP_DIR=".dumbledore/backups"
BACKUP_FILE="${BACKUP_DIR}/framework-update-$(date -u +"%Y%m%dT%H%M%SZ").tar.gz"
mkdir -p "$BACKUP_DIR"

FRAMEWORK_PATHS=(
  "AGENTS.md"
  "ACCESS_POLICY.md"
  "ONBOARDING.md"
  "README.md"
  "install.sh"
  "templates"
  "skills/dumbledore"
  "skills/dumbledore-onboarding"
  "scripts/README.md"
  "scripts/publish.sh"
  "scripts/fetch-wechat-article.sh"
  "scripts/check-updates.sh"
  "scripts/update-framework.sh"
  "brain/schema.md"
  "brain/RESOLVER.md"
  "brain/methods/openclaw-skill-creation.md"
  "brain/methods/wechat-article-ingestion.md"
  "brain/methods/framework-update-notification.md"
  "brain/sources/source_20260502_initial_design.md"
  "brain/sources/source_20260502_agentforge_openclaw.md"
  "brain/sources/source_20260506_wechat_article_to_markdown.md"
  "brain/sources/source_20260506_framework_update_notification.md"
  ".dumbledore/README.md"
  ".dumbledore/state.example.json"
)

EXISTING_PATHS=()
for path in "${FRAMEWORK_PATHS[@]}"; do
  if [ -e "$path" ]; then
    EXISTING_PATHS+=("$path")
  fi
done

if [ "${#EXISTING_PATHS[@]}" -gt 0 ]; then
  tar -czf "$BACKUP_FILE" "${EXISTING_PATHS[@]}"
  echo "Backup created: ${BACKUP_FILE}"
fi

for path in "${FRAMEWORK_PATHS[@]}"; do
  if [ -e "$TMP_DIR/$path" ]; then
    mkdir -p "$(dirname "$path")"
    rm -rf "$path"
    cp -R "$TMP_DIR/$path" "$path"
  fi
done

chmod +x install.sh scripts/publish.sh scripts/fetch-wechat-article.sh scripts/check-updates.sh scripts/update-framework.sh 2>/dev/null || true

CHECKED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
update_state "$REPO" "$BRANCH" "$LATEST_COMMIT" "$CHECKED_AT"

mkdir -p "$(dirname "${DUMBLEDORE_UPDATE_CACHE:-.dumbledore/update-check.json}")"
cat >"${DUMBLEDORE_UPDATE_CACHE:-.dumbledore/update-check.json}" <<EOF
{
  "checked_at": "${CHECKED_AT}",
  "repo": "${REPO}",
  "branch": "${BRANCH}",
  "current_commit": "${LATEST_COMMIT}",
  "latest_commit": "${LATEST_COMMIT}",
  "update_available": false
}
EOF

echo "Dumbledore framework updated to ${LATEST_COMMIT}."
echo "Review changes, then publish with: scripts/publish.sh \"chore: update Dumbledore framework\""
