---
title: "innosocia.dk"
slug: "innosocia-dk"
date: "2026-03-11"
status: "active"
summary: "Udviklingen af et hurtigt, filbaseret og troværdigt digitalt hjem for Innosocia."
featured: true

why: "Projektet findes for at skabe et roligt og langtidsholdbart digitalt hjem for Innosocia, hvor apps, idéer og projekter kan samles uden tung CMS-arkitektur."

direction:
  - "Statisk Astro-site"
  - "Filbaseret indhold"
  - "Minimal JavaScript"
  - "Manuel og valideret deploy"
  - "Raspberry Pi + Nginx proxy"

relatedProjects:
  - "sovereign-suite"
---

innosocia.dk er det centrale digitale hjem for Innosocia.

Det samler apps, idéer, projekter og principper i et hurtigt og læsbart format, der kan drives uden tung CMS-arkitektur, tredjeparts-dashboard eller platformsmagi med låneord og dårlige intentioner.

## Mål

At skabe en enkel offentlig indgang til Innosocia, hvor besøgende hurtigt kan forstå:

- hvad Innosocia arbejder med
- hvilke apps og projekter der findes
- hvorfor digital suverænitet og local-first software er en praktisk retning
- hvordan arbejdet udvikler sig over tid

## Arkitektur

Sitet er bygget som et statisk Astro-site med filbaseret indhold.

Den aktuelle drift er:

- kildekode i GitHub-repoet `jakobbskov/innosocia.dk`
- lokal arbejdsmappe: `/home/jakob/github/innosocia.dk`
- build-output: `dist/`
- live webroot: `/var/www/innosocia.dk`
- proxy: `nextcloud-proxy` på Raspberry Pi
- TLS via Let’s Encrypt
- manuel deploy via `scripts/deploy.sh`

## Drift

Et push til GitHub ændrer ikke automatisk live-sitet.

Deploy sker bevidst og valideret:

1. hent seneste `main`
2. kør audit og build
3. generér statisk output
4. rsync `dist/` til Raspberry Pi
5. valider live-routes over HTTPS

Det er ikke lige så magisk som et smart cloud-dashboard, men til gengæld er det forståeligt, reversibelt og mindre tilbøjeligt til at opføre sig som en SaaS-demo med identitetskrise.

## Begrundelse

Hjemmesiden skal ikke være et CMS-monster.

Den skal være hurtig, troværdig, let at vedligeholde og nem at flytte. Den skal kunne forklares med almindelige filer, almindelig Git-historik og almindelig HTTP-validering.

Det er hele pointen.
