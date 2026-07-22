---
name: manage-certificates
description: Standardize the collection, verification, local archival, cataloging, and later website publication of professional course certificates. Use when Codex must add certificates from public verification URLs, download official PDF/image artifacts, validate a certificate catalog, or publish previously staged certificates to a portfolio. Keep storage separate from publication unless the user explicitly requests site changes.
---

# Manage Certificates

Store certificates from authoritative public URLs in a stable, verifiable catalog. Treat collection and publication as separate phases.

## Resolve paths

1. Find the repository root from the current workspace.
2. Default to these repository-relative paths unless the project already defines an equivalent convention:
   - Catalog: `assets/certificates/catalog.json`
   - Originals: `assets/certificates/originals/`
3. Read [references/catalog-schema.md](references/catalog-schema.md) before creating or changing the catalog.
4. Ignore screenshot or PDF paths supplied only as historical context. Fetch fresh artifacts from the public verification URL.

## Collect and stage

1. Open each public verification URL and capture the holder, issuer, completion date, credential ID, course URL, verification URL, and the title printed on the official certificate.
2. Prefer official PDF and image downloads exposed by the verification page.
3. If direct HTTP access is blocked, use the available browser to inspect the public page and discover its official artifact links. Do not bypass authentication, CAPTCHAs, or access controls.
4. Use lowercase hyphenated filenames: `<issuer>-<course-slug>.pdf` and `<issuer>-<course-slug>.jpg`.
5. Preserve downloaded originals. Do not recompress, crop, rename internal certificate data, or synthesize replacement certificates.
6. Store stable public verification and course URLs only. Do not persist signed, expiring CDN download URLs.
7. Normalize dates to `YYYY-MM-DD` and record the date of live verification.
8. Calculate SHA-256 and byte length for every artifact.
9. Upsert by `verification_url` or `credential_id`; never create duplicates.
10. Run `python3 .agents/skills/manage-certificates/scripts/verify_catalog.py` from the repository root.

Stop after validation when the user asks to add, store, archive, prepare, or stage certificates. Do not modify application code, routes, localization, asset manifests, or deployed pages in this phase.

## Publish later

Publish only when the user explicitly requests website integration.

1. Validate the catalog first.
2. Inspect the site's current content model, localization, design system, routing, and asset configuration.
3. Add the smallest adapter from the catalog schema to the existing UI model.
4. Use the official image as the preview, the local PDF as an archived artifact, and the public verification URL as the primary proof link.
5. Keep holder names and certificate titles exactly as verified unless the UI uses a clearly labeled display-title override.
6. Add focused tests for ordering, missing artifacts, external verification links, and responsive behavior.
7. Run the project's normal format, static analysis, test, and production build checks.

## Validation rules

- Reject missing artifacts, checksum mismatches, invalid ISO dates, non-HTTPS public URLs, duplicate IDs, duplicate verification URLs, and paths outside the repository.
- Treat the official certificate artifact as authoritative for `title`. If the verification page currently uses a different course title, preserve it separately as `verification_title`.
- Treat the official certificate artifact as authoritative for `holder`. If the public verification page anonymizes the holder, preserve its displayed value separately as `verification_holder`.
- Report which certificates were verified, what was stored, and whether the site remained unchanged.
