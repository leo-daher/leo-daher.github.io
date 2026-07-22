# Certificate catalog schema

Use `assets/certificates/catalog.json` with this root shape:

```json
{
  "schema_version": 1,
  "certificates": []
}
```

Each certificate must contain:

```json
{
  "id": "provider-credential-id",
  "credential_id": "public-credential-id",
  "provider": "skilljar",
  "issuer": "Anthropic Education",
  "title": "Verified course title",
  "holder": "Verified holder name",
  "completed_on": "2026-07-17",
  "verification_url": "https://public.example/c/credential",
  "course_url": "https://public.example/course",
  "verified_on": "2026-07-20",
  "verification_status": "verified",
  "artifacts": {
    "pdf": {
      "path": "assets/certificates/originals/example.pdf",
      "media_type": "application/pdf",
      "bytes": 123,
      "sha256": "64 lowercase hexadecimal characters"
    },
    "image": {
      "path": "assets/certificates/originals/example.jpg",
      "media_type": "image/jpeg",
      "bytes": 123,
      "sha256": "64 lowercase hexadecimal characters"
    }
  }
}
```

`course_url` may be `null` when the verification page does not expose a stable public course page. All other fields are required. `verification_title` is optional and records the current verification-page title when it differs from the title printed on the archived certificate. `verification_holder` is optional and records the public verification-page value when the provider anonymizes a holder whose name remains visible on the official artifact.

## Semantics

- `id`: stable lowercase identifier prefixed by provider.
- `credential_id`: public certificate reference shown in or derived from the verification URL.
- `provider`: platform that verifies the credential, such as `skilljar` or `udemy`.
- `issuer`: organization offering the course, not the verification platform unless they are the same.
- `title`: exact title printed on the official archived certificate.
- `verification_title`: optional current title from the public verification page when it differs from `title`.
- `holder`: exact holder name printed on the official archived certificate.
- `verification_holder`: optional current public verification-page value when it differs from `holder` because of anonymization.
- `completed_on`: exact authoritative value from the public verification page and artifact.
- `verified_on`: date the verification page was last checked live.
- `verification_status`: use `verified` only after the public page and artifacts have been checked.
- `artifacts`: immutable local originals with integrity metadata.

Do not store expiring signed download URLs, local absolute paths, source-machine paths, page prices, ratings, or other volatile marketing data.

## Ordering

Keep entries ordered by `completed_on` descending, then `title` ascending. This makes diffs deterministic and provides a sensible default for future publication.
