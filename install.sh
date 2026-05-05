#!/usr/bin/env bash
set -euo pipefail

SOURCE_REPO="Ivor-NCUT/dumbledore"
SOURCE_ARCHIVE="https://github.com/${SOURCE_REPO}/archive/refs/heads/main.tar.gz"
SOURCE_GIT_URL="https://github.com/${SOURCE_REPO}.git"
SOURCE_BRANCH="main"

has_tty() {
  [ -r /dev/tty ] && [ -w /dev/tty ]
}

prompt() {
  local label="$1"
  local default_value="$2"
  local answer=""

  if has_tty; then
    printf "%s [%s]: " "$label" "$default_value"
    read -r answer </dev/tty || true
  fi

  if [ -z "$answer" ]; then
    printf "%s" "$default_value"
  else
    printf "%s" "$answer"
  fi
}

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: ${command_name}" >&2
    exit 1
  fi
}

require_command curl
require_command tar
require_command git

write_state() {
  local publish_mode="$1"
  local origin_url="$2"
  local upstream_commit="$3"
  local state_dir=".dumbledore"
  local state_file="${state_dir}/state.json"
  local completed_at
  local upstream_commit_json="null"

  completed_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  if [ -n "$upstream_commit" ]; then
    upstream_commit_json="\"${upstream_commit}\""
  fi

  mkdir -p "$state_dir"
  cat >"$state_file" <<EOF
{
  "version": 2,
  "onboarding_completed": true,
  "completed_at": "${completed_at}",
  "publish_mode": "${publish_mode}",
  "origin_url": ${origin_url},
  "raw_enabled": true,
  "framework_upstream_repo": "${SOURCE_REPO}",
  "framework_upstream_branch": "${SOURCE_BRANCH}",
  "framework_upstream_commit": ${upstream_commit_json},
  "framework_last_update_check_at": null
}
EOF
}

echo "Dumbledore onboarding"
echo "This creates your own knowledge repo. It will not push materials to ${SOURCE_REPO}."
echo

DEFAULT_DIR="${DUMBLEDORE_DIR:-$HOME/dumbledore-knowledge}"
TARGET_DIR="$(prompt "Local folder" "$DEFAULT_DIR")"
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"

if [ -e "$TARGET_DIR" ] && [ "$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')" != "0" ]; then
  echo "Target folder exists and is not empty: ${TARGET_DIR}" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading Dumbledore..."
SOURCE_COMMIT="$(git ls-remote "$SOURCE_GIT_URL" "refs/heads/${SOURCE_BRANCH}" 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
curl -fsSL "$SOURCE_ARCHIVE" | tar -xz -C "$TMP_DIR" --strip-components=1

echo "Preparing your copy..."
cp -R "$TMP_DIR"/. "$TARGET_DIR"/

cd "$TARGET_DIR"
git init >/dev/null
git branch -M main
write_state "local_only" "null" "$SOURCE_COMMIT"
git add -A

if ! git config user.name >/dev/null; then
  git config user.name "Dumbledore User"
fi

if ! git config user.email >/dev/null; then
  git config user.email "dumbledore@example.local"
fi

git commit -m "chore: initialize Dumbledore knowledge repo" >/dev/null

echo
echo "Local Dumbledore repo created at: $(pwd)"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  DEFAULT_REPO="${DUMBLEDORE_REPO_NAME:-$(basename "$TARGET_DIR")}"
  DEFAULT_VISIBILITY="${DUMBLEDORE_VISIBILITY:-private}"
  CREATE_REMOTE="${DUMBLEDORE_CREATE_GITHUB:-}"

  if has_tty && [ -z "$CREATE_REMOTE" ]; then
    printf "Create and push to your GitHub with gh? [Y/n]: "
    read -r CREATE_REMOTE </dev/tty || true
  fi

  case "${CREATE_REMOTE:-Y}" in
    n|N|no|NO)
      echo "Skipped GitHub creation."
      ;;
    *)
      REPO_NAME="$(prompt "GitHub repo name" "$DEFAULT_REPO")"
      VISIBILITY="$(prompt "Visibility: private or public" "$DEFAULT_VISIBILITY")"

      case "$VISIBILITY" in
        public) VISIBILITY_FLAG="--public" ;;
        *) VISIBILITY_FLAG="--private" ;;
      esac

      echo "Creating GitHub repo..."
      gh repo create "$REPO_NAME" "$VISIBILITY_FLAG" --source=. --remote=origin
      REMOTE_URL="$(git remote get-url origin)"
      write_state "github_bound" "\"${REMOTE_URL}\"" "$SOURCE_COMMIT"
      git add .dumbledore/state.json
      git commit -m "chore: bind Dumbledore GitHub origin" >/dev/null
      git push -u origin main >/dev/null
      echo "GitHub repo is ready: $(gh repo view "$REPO_NAME" --json url -q .url)"
      ;;
  esac
else
  echo "GitHub CLI is not authenticated or not installed."
  echo "To push manually:"
  echo "  cd \"$(pwd)\""
  echo "  gh auth login"
  echo "  gh repo create $(basename "$TARGET_DIR") --private --source=. --remote=origin --push"
fi

echo
echo "Next: open this repo in your Agent and say: 用 dumbledore 处理这份材料。"
