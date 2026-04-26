# Innosocia.dk

Static Astro site for Innosocia.

Innosocia.dk is the public frontdoor for Innosocia's work with digital sovereignty, local-first tools, calm technology and the Sovereign app ecosystem.

## Status

- Framework: Astro
- Output: static site
- Production URL: https://innosocia.dk
- Source of truth: /home/jakob/github/innosocia.dk
- Default branch: main

## Requirements

- Node.js >= 22.12.0
- npm

The expected Node version is defined in .nvmrc and package.json.

## Local workflow

Install dependencies:

    npm ci

Run development server:

    npm run dev

Build static site:

    npm run build

Preview build locally:

    npm run preview

## Validation before commit

Before committing changes, run:

    npm audit
    npm run build

Expected result:

- npm audit reports 0 vulnerabilities
- npm run build completes successfully
- generated output is written to dist/

## Project structure

    src/pages/        Astro pages and routes
    src/components/   Reusable UI components
    src/layouts/      Layouts
    src/styles/       Global CSS
    public/           Static public assets
    dist/             Generated build output, not edited manually

## Deploy

Deployment is documented in docs/deployment.md.

Do not edit files directly in a live web root. Build from Git, deploy generated dist/, then validate over HTTP.
