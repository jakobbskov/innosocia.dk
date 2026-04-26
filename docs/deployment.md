# Deployment contract – innosocia.dk

## Purpose

This document defines how `innosocia.dk` is built, deployed and validated.

The goal is a reversible, Git-first deploy process. The live server is not a workspace.

## Verified live state

As of 2026-04-26:

- Repository: `jakobbskov/innosocia.dk`
- Local source of truth: `/home/jakob/github/innosocia.dk`
- Framework: Astro
- Output mode: static
- Build output: `dist/`
- Production URL: `https://innosocia.dk`
- Live web root: `/var/www/innosocia.dk`
- Proxy host: Raspberry Pi, LAN IP `192.168.1.186`
- Public IPv4: `89.150.159.102`
- Proxy container: `nextcloud-proxy`
- Proxy compose file: `/home/jakob/nextcloud/docker-compose.yml`
- Nginx vhost: `/home/jakob/nextcloud/nginx/conf.d/innosocia.dk.conf`
- TLS certificate: `/etc/letsencrypt/live/innosocia.dk/`
- DNS:
  - `innosocia.dk` → `89.150.159.102`
  - `www.innosocia.dk` → `89.150.159.102`

## Important operating principle

A push to GitHub does **not** automatically deploy the site.

GitHub is the source of truth for code. The live site is the generated static output copied to:

    /var/www/innosocia.dk/

Deployment is manual and must happen only after validation.

## Required validation before deploy

From the repository root:

    node -v
    npm -v
    npm ci
    npm audit
    npm run build

Expected:

- Node.js is `>=22.12.0`
- `npm audit` reports 0 vulnerabilities
- Astro build completes successfully
- `dist/index.html`, `dist/robots.txt` and `dist/sitemap-index.xml` exist

## Deploy command

From the repository root:

    rsync -av --delete dist/ jakob@192.168.1.186:/var/www/innosocia.dk/

This copies only generated static files from `dist/` into the live web root.

Do not edit files directly in `/var/www/innosocia.dk`.

## Nginx/proxy contract

`innosocia.dk` is served by the existing Raspberry Pi `nextcloud-proxy` container.

The proxy container must have this read-only bind mount:

    /var/www/innosocia.dk:/var/www/innosocia.dk:ro

The active vhost is:

    /home/jakob/nextcloud/nginx/conf.d/innosocia.dk.conf

Expected behavior:

- HTTP redirects to HTTPS
- `www.innosocia.dk` serves the same static site
- HTTPS serves the Astro static output
- no backend service is required
- no API route is required
- unknown client-side routes fall back to `/index.html`

## Proxy validation

On the Raspberry Pi:

    docker inspect nextcloud-proxy --format '{{range .Mounts}}{{println .Source "->" .Destination "(" .Mode ")"}}{{end}}' | grep innosocia.dk
    docker exec nextcloud-proxy nginx -t

Expected:

    /var/www/innosocia.dk -> /var/www/innosocia.dk ( ro )
    nginx: configuration file /etc/nginx/nginx.conf test is successful

## Live validation after deploy

After deploy:

    curl -I https://innosocia.dk/
    curl -I https://www.innosocia.dk/
    curl -I https://innosocia.dk/apps/
    curl -I https://innosocia.dk/status/
    curl -I https://innosocia.dk/sitemap-index.xml

Expected:

- all routes return `200`
- response server is `nginx/1.28.0`
- no `LiteSpeed` responses
- no `5xx` responses

## DNS notes

The Raspberry Pi uses NetworkManager.

The Pi DNS servers were set to:

    1.1.1.1
    9.9.9.9

This was done because the previous ISP resolvers returned stale A records for `innosocia.dk`.

Check DNS with:

    dig innosocia.dk A +short
    dig www.innosocia.dk A +short

Expected:

    89.150.159.102

## Rollback

Rollback must be file-based and Git-based:

1. identify the previous known-good Git commit
2. check it out locally
3. run validation
4. rebuild
5. redeploy `dist/`

Do not debug by editing live files directly.

## NordicWay note

NordicWay/cPanel is no longer used to serve the root website for:

- `innosocia.dk`
- `www.innosocia.dk`

Do not remove mail-related DNS records unless mail hosting is intentionally migrated.

Do not change SPF, DKIM, DMARC, `mail`, `webmail`, or other mail-related records without a separate mail migration plan.
