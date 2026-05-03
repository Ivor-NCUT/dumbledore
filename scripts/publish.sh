#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="Ivor-NCUT/dumbledore"
UPSTREAM_HTTPS="https://github.com/${UPSTREAM_REPO}.git"
UPSTREAM_SSH="git@github.com:${UPSTREAM_REPO}.git"
STATE_FILE=".dumbledore/state.json"

COMMIT_MESSAGE="${1:-chore: update Dumbledore knowledge base}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a Git repository." >&2
  exit 1
fi

if [ ! -f "$STATE_FILE" ]; then
  echo "Missing ${STATE_FILE}. Run Dumbledore onboarding first." >&2
  exit 1
fi

ONBOARDING_COMPLETED="$(sed -n 's/.*"onboarding_completed"[[:space:]]*:[[:space:]]*\(true\|false\).*/\1/p' "$STATE_FILE" | head -n 1)"
RAW_ENABLED="$(sed -n 's/.*"raw_enabled"[[:space:]]*:[[:space:]]*\(true\|false\).*/\1/p' "$STATE_FILE" | head -n 1)"
PUBLISH_MODE="$(sed -n 's/.*"publish_mode"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$STATE_FILE" | head -n 1)"

if [ "$ONBOARDING_COMPLETED" != "true" ] || [ "$RAW_ENABLED" != "true" ] || [ -z "$PUBLISH_MODE" ]; then
  echo "Invalid onboarding state. Re-run Dumbledore onboarding." >&2
  exit 1
fi

if [ "$PUBLISH_MODE" = "local_only" ]; then
  echo "This repo is in local_only mode. Bind a personal GitHub origin before publishing." >&2
  exit 1
fi

REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"

if [ -z "$REMOTE_URL" ]; then
  echo "No origin remote is configured. Bind this repo to the user's GitHub repository first." >&2
  exit 1
fi

if [ "$REMOTE_URL" = "$UPSTREAM_HTTPS" ] || [ "$REMOTE_URL" = "$UPSTREAM_SSH" ]; then
  echo "Refusing to publish user knowledge to upstream ${UPSTREAM_REPO}." >&2
  echo "Create a private user repo and set it as origin first." >&2
  exit 1
fi

BRANCH="$(git branch --show-current)"
if [ -z "$BRANCH" ]; then
  echo "Cannot publish from a detached HEAD." >&2
  exit 1
fi

if git diff --quiet && git diff --cached --quiet; then
  echo "No local changes to publish."
  exit 0
fi

git add -A
git commit -m "$COMMIT_MESSAGE"

if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
  git pull --rebase origin "$BRANCH"
fi

git push -u origin "$BRANCH"

echo "Published to ${REMOTE_URL} on branch ${BRANCH}."
