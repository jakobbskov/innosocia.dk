#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="jakob@192.168.1.186"
REMOTE_WEBROOT="/var/www/innosocia.dk"

REQUIRED_FILES=(
  "dist/index.html"
  "dist/robots.txt"
  "dist/sitemap-index.xml"
)

LIVE_URLS=(
  "https://innosocia.dk/"
  "https://www.innosocia.dk/"
  "https://innosocia.dk/apps/"
  "https://innosocia.dk/status/"
  "https://innosocia.dk/sitemap-index.xml"
)

echo "=== Innosocia.dk deploy ==="

if [[ ! -f "package.json" ]] || [[ ! -f "astro.config.mjs" ]]; then
  echo "ERROR: Run this script from the repository root."
  exit 1
fi

echo "=== Git status ==="
if [[ -n "$(git status --short)" ]]; then
  echo "ERROR: Working tree is not clean. Commit or stash changes before deploy."
  git status --short
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "main" ]]; then
  echo "ERROR: Deploy only from main. Current branch: $BRANCH"
  exit 1
fi

echo "=== Pull latest main ==="
git pull

echo "=== Versions ==="
node -v
npm -v

echo "=== Install dependencies ==="
npm ci

echo "=== Audit ==="
npm audit

echo "=== Build ==="
npm run build

echo "=== Verify build output ==="
for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: Missing required build output: $file"
    exit 1
  fi
  echo "OK: $file"
done

echo "=== Deploy dist/ to ${REMOTE_HOST}:${REMOTE_WEBROOT}/ ==="
rsync -av --delete dist/ "${REMOTE_HOST}:${REMOTE_WEBROOT}/"

echo "=== Live validation ==="
for url in "${LIVE_URLS[@]}"; do
  status="$(curl -sS -o /dev/null -w "%{http_code}" "$url")"
  server="$(curl -sSI "$url" | awk 'tolower($1)=="server:" {print $2}' | tr -d '\r' | head -n 1)"

  printf "%-45s %s %s\n" "$url" "$status" "$server"

  if [[ "$status" != "200" ]]; then
    echo "ERROR: Unexpected HTTP status for $url: $status"
    exit 1
  fi

  if [[ "$server" != "nginx/1.28.0" ]]; then
    echo "ERROR: Unexpected server for $url: $server"
    exit 1
  fi
done

echo "=== Deploy complete ==="
