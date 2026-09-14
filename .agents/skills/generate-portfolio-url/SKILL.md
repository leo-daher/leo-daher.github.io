---
name: generate-portfolio-url
description: Generate traceable Leone portfolio URLs for resume PDFs and job applications using privacy-conscious UTM parameters.
---

# Generate portfolio URLs

Use this skill whenever a resume PDF, CV, application document, or recruiter-specific portfolio link is being generated.

## Canonical URL

Use `https://leo-daher.github.io/` as the portfolio base URL. Add attribution through query parameters:

`utm_source` identifies the channel, `utm_medium` identifies the artifact type, `utm_campaign` identifies the resume or application version, and `utm_content` optionally identifies a section or variant. Use the short `ref` parameter when a compact identifier is preferable.

Examples:

- `https://leo-daher.github.io/?utm_source=resume&utm_medium=pdf&utm_campaign=flutter-2026`
- `https://leo-daher.github.io/?utm_source=application&utm_medium=pdf&utm_campaign=mobile-engineer-2026&ref=mobile-v2`

## Rules

- Keep values lowercase, ASCII, short, and hyphen-separated.
- Do not put names, email addresses, phone numbers, recruiter identities, or other personal data in the URL.
- Keep the URL intact when embedding it in a PDF; do not replace the query string with a shortened or stripped link.
- Use a stable campaign identifier for each resume version so Analytics can compare results.
- Before delivering the PDF, verify that the URL returns the portfolio and that the final PDF contains the exact tracked URL.

The portfolio sends sanitized attribution values to the existing GA4/Sentry telemetry as `portfolio_attribution`. GA4 also uses standard UTM parameters for acquisition reporting. Do not add new tracking providers as part of ordinary URL generation.
