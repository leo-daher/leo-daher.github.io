---
name: generate-portfolio-url
description: Generate and register traceable Leone portfolio URLs for resume PDFs, job applications, and social profiles using privacy-conscious attribution parameters.
---

# Generate portfolio URLs

Use this skill whenever a resume PDF, CV, application document,
recruiter-specific portfolio link, or social-profile portfolio link is being
generated.

## Canonical URL

Use `https://leo-daher.github.io/` as the portfolio base URL. Add attribution through query parameters:

`utm_source` identifies the channel, `utm_medium` identifies the artifact type, `utm_campaign` identifies the resume or application version, and `utm_content` optionally identifies a section or variant. Use the short `ref` parameter when a compact identifier is preferable.

Examples:

- `https://leo-daher.github.io/?utm_source=resume&utm_medium=pdf&utm_campaign=flutter-2026`
- `https://leo-daher.github.io/?utm_source=application&utm_medium=pdf&utm_campaign=mobile-engineer-2026&ref=mobile-v2`
- `https://leo-daher.github.io/?ref=cv-20260916T144658237Z`
- `https://leo-daher.github.io/ig`
- `https://leo-daher.github.io/in`

## Reference registry

The source of truth for short references is
`tracking/portfolio_ref_registry.csv` at the repository root. Read it before
interpreting an existing `ref` or creating a new one.

For every newly generated CV or resume URL:

1. Capture the generation instant in UTC with millisecond precision.
2. Format the reference as `cv-yyyyMMddTHHmmssSSSZ`, using the literal `T`
   and `Z` markers.
3. Use that value as the URL's `ref` parameter.
4. Append one unique row to the registry with the final URL and its meaning.
5. Use the exact registered URL as the hyperlink destination in the delivered artifact.

Use the stable short paths `https://leo-daher.github.io/ig` for Instagram and
`https://leo-daher.github.io/in` for LinkedIn. Their static entry points
redirect to the home page with `ref=ig` and `ref=in`, respectively, so the
public links stay clean while telemetry receives the reference. Keep a single
registry row for each stable channel reference instead of adding one row per
click or publication.

## Rules

- Keep values lowercase, ASCII, short, and hyphen-separated, except for the
  canonical uppercase `T` and `Z` markers in CV timestamps.
- Do not put names, email addresses, phone numbers, recruiter identities, or other personal data in the URL.
- In resumes and PDFs, show `https://leo-daher.github.io/` as the visible link text and keep the complete registered URL, including `?ref=...`, only in the underlying hyperlink destination.
- Do not strip the query string from the hyperlink relationship or expose it in the visible text.
- Use a stable campaign identifier for each resume version so Analytics can compare results.
- Before delivering the PDF, verify separately that the visible text is the clean canonical URL and that the clickable annotation targets the exact registered URL.
- Never reuse a timestamp-based CV reference for a different generated file.

The portfolio sends sanitized attribution values to the existing GA4/Sentry telemetry as `portfolio_attribution`. GA4 also uses standard UTM parameters for acquisition reporting. Do not add new tracking providers as part of ordinary URL generation.
