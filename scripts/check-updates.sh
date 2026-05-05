#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${DUMBLEDORE_STATE_FILE:-.dumbledore/state.json}"
CACHE_FILE="${DUMBLEDORE_UPDATE_CACHE:-.dumbledore/update-check.json}"
DEFAULT_REPO="Ivor-NCUT/dumbledore"
DEFAULT_BRANCH="main"
DEFAULT_INTERVAL_SECONDS="86400"
FORCE="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force)
      FORCE="true"
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage: scripts/check-updates.sh [--force]

Checks whether the upstream Dumbledore framework repository has changed.
The script is intentionally read-only: it only prints a notification and
writes .dumbledore/update-check.json.
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

json_bool() {
  local key="$1"
  local file="$2"
  sed -n \
    -e "s/.*\"${key}\"[[:space:]]*:[[:space:]]*true.*/true/p" \
    -e "s/.*\"${key}\"[[:space:]]*:[[:space:]]*false.*/false/p" \
    "$file" | head -n 1
}

now_epoch() {
  date -u +"%s"
}

write_cache() {
  local checked_at="$1"
  local repo="$2"
  local branch="$3"
  local current_commit="$4"
  local latest_commit="$5"
  local update_available="$6"

  mkdir -p "$(dirname "$CACHE_FILE")"
  cat >"$CACHE_FILE" <<EOF
{
  "checked_at": "${checked_at}",
  "repo": "${repo}",
  "branch": "${branch}",
  "current_commit": ${current_commit},
  "latest_commit": ${latest_commit},
  "update_available": ${update_available}
}
EOF
}

if [ ! -f "$STATE_FILE" ]; then
  echo "Dumbledore update check skipped: missing ${STATE_FILE}."
  exit 0
fi

ONBOARDING_COMPLETED="$(json_bool "onboarding_completed" "$STATE_FILE")"
if [ "$ONBOARDING_COMPLETED" != "true" ]; then
  echo "Dumbledore update check skipped: onboarding is not complete."
  exit 0
fi

REPO="$(json_value "framework_upstream_repo" "$STATE_FILE")"
BRANCH="$(json_value "framework_upstream_branch" "$STATE_FILE")"
CURRENT_COMMIT="$(json_value "framework_upstream_commit" "$STATE_FILE")"

if [ -z "$REPO" ]; then
  REPO="$DEFAULT_REPO"
fi

if [ -z "$BRANCH" ]; then
  BRANCH="$DEFAULT_BRANCH"
fi

INTERVAL_SECONDS="${DUMBLEDORE_UPDATE_CHECK_INTERVAL_SECONDS:-$DEFAULT_INTERVAL_SECONDS}"
CURRENT_EPOCH="$(now_epoch)"

if [ "$FORCE" != "true" ] && [ -f "$CACHE_FILE" ]; then
  LAST_CHECKED="$(json_value "checked_at" "$CACHE_FILE")"
  CACHED_UPDATE="$(json_bool "update_available" "$CACHE_FILE")"
  if [ -n "$LAST_CHECKED" ]; then
    LAST_EPOCH="$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_CHECKED" +"%s" 2>/dev/null || date -u -d "$LAST_CHECKED" +"%s" 2>/dev/null || echo 0)"
    AGE="$((CURRENT_EPOCH - LAST_EPOCH))"
    if [ "$AGE" -lt "$INTERVAL_SECONDS" ]; then
      if [ "$CACHED_UPDATE" = "true" ]; then
        echo "Dumbledore has an upstream update available. Run: scripts/update-framework.sh"
      else
        echo "Dumbledore framework is up to date as of ${LAST_CHECKED}."
      fi
      exit 0
    fi
  fi
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Dumbledore update check skipped: git is not installed."
  exit 0
fi

LATEST_COMMIT="$(git ls-remote "https://github.com/${REPO}.git" "refs/heads/${BRANCH}" 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
CHECKED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

if [ -z "$LATEST_COMMIT" ]; then
  echo "Dumbledore update check skipped: could not reach upstream ${REPO}."
  exit 0
fi

if [ -z "$CURRENT_COMMIT" ]; then
  write_cache "$CHECKED_AT" "$REPO" "$BRANCH" "null" "\"${LATEST_COMMIT}\"" "true"
  echo "Dumbledore upstream version is unknown locally. Run: scripts/update-framework.sh"
  exit 0
fi

if [ "$CURRENT_COMMIT" = "$LATEST_COMMIT" ]; then
  write_cache "$CHECKED_AT" "$REPO" "$BRANCH" "\"${CURRENT_COMMIT}\"" "\"${LATEST_COMMIT}\"" "false"
  echo "Dumbledore framework is up to date."
  exit 0
fi

write_cache "$CHECKED_AT" "$REPO" "$BRANCH" "\"${CURRENT_COMMIT}\"" "\"${LATEST_COMMIT}\"" "true"
cat <<EOF
Dumbledore has an upstream update available.
- current: ${CURRENT_COMMIT}
- latest:  ${LATEST_COMMIT}

After user confirmation, run:
  scripts/update-framework.sh
EOF
