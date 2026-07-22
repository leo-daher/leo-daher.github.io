#!/usr/bin/env python3
"""Validate the staged certificate catalog and artifact integrity."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import re
import sys
from pathlib import Path
from urllib.parse import urlparse


ID_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
REQUIRED_FIELDS = {
    "id",
    "credential_id",
    "provider",
    "issuer",
    "title",
    "holder",
    "completed_on",
    "verification_url",
    "course_url",
    "verified_on",
    "verification_status",
    "artifacts",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--catalog",
        default="assets/certificates/catalog.json",
        help="Catalog path relative to the repository root.",
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Repository root used to resolve artifact paths.",
    )
    return parser.parse_args()


def require_https(value: object, field: str, errors: list[str]) -> None:
    if not isinstance(value, str) or urlparse(value).scheme != "https":
        errors.append(f"{field} must be an HTTPS URL")


def require_date(value: object, field: str, errors: list[str]) -> None:
    if not isinstance(value, str):
        errors.append(f"{field} must be an ISO date")
        return
    try:
        dt.date.fromisoformat(value)
    except ValueError:
        errors.append(f"{field} must use YYYY-MM-DD")


def validate_artifact(
    root: Path,
    certificate_id: str,
    kind: str,
    artifact: object,
    errors: list[str],
) -> None:
    label = f"{certificate_id}.artifacts.{kind}"
    if not isinstance(artifact, dict):
        errors.append(f"{label} must be an object")
        return

    required = {"path", "media_type", "bytes", "sha256"}
    missing = required - artifact.keys()
    if missing:
        errors.append(f"{label} missing: {', '.join(sorted(missing))}")
        return

    relative = Path(str(artifact["path"]))
    if relative.is_absolute() or ".." in relative.parts:
        errors.append(f"{label}.path must stay inside the repository")
        return

    resolved = (root / relative).resolve()
    try:
        resolved.relative_to(root)
    except ValueError:
        errors.append(f"{label}.path resolves outside the repository")
        return

    if not resolved.is_file():
        errors.append(f"{label}.path does not exist: {relative}")
        return

    data = resolved.read_bytes()
    expected_media_type = "application/pdf" if kind == "pdf" else "image/jpeg"
    if artifact["media_type"] != expected_media_type:
        errors.append(f"{label}.media_type must be {expected_media_type}")
    if kind == "pdf" and not data.startswith(b"%PDF-"):
        errors.append(f"{label}.path is not a PDF")
    if kind == "image" and not data.startswith(b"\xff\xd8\xff"):
        errors.append(f"{label}.path is not a JPEG")
    if artifact["bytes"] != len(data):
        errors.append(f"{label}.bytes mismatch")

    digest = hashlib.sha256(data).hexdigest()
    sha256 = artifact["sha256"]
    if not isinstance(sha256, str) or not SHA256_RE.fullmatch(sha256):
        errors.append(f"{label}.sha256 must be lowercase SHA-256")
    elif sha256 != digest:
        errors.append(f"{label}.sha256 mismatch")


def main() -> int:
    args = parse_args()
    root = Path(args.root).resolve()
    catalog_path = (root / args.catalog).resolve()
    errors: list[str] = []

    if not catalog_path.is_file():
        print(f"Catalog does not exist: {catalog_path}", file=sys.stderr)
        return 1

    try:
        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        print(f"Cannot read catalog: {error}", file=sys.stderr)
        return 1

    if catalog.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    certificates = catalog.get("certificates")
    if not isinstance(certificates, list):
        errors.append("certificates must be an array")
        certificates = []

    seen_ids: set[str] = set()
    seen_credentials: set[str] = set()
    seen_urls: set[str] = set()
    observed_order: list[tuple[str, str]] = []

    for index, certificate in enumerate(certificates):
        prefix = f"certificates[{index}]"
        if not isinstance(certificate, dict):
            errors.append(f"{prefix} must be an object")
            continue

        missing = REQUIRED_FIELDS - certificate.keys()
        if missing:
            errors.append(f"{prefix} missing: {', '.join(sorted(missing))}")
            continue

        certificate_id = certificate["id"]
        if not isinstance(certificate_id, str) or not ID_RE.fullmatch(certificate_id):
            errors.append(f"{prefix}.id must be lowercase hyphen-case")
            certificate_id = prefix
        elif certificate_id in seen_ids:
            errors.append(f"duplicate id: {certificate_id}")
        seen_ids.add(certificate_id)

        credential_id = certificate["credential_id"]
        if not isinstance(credential_id, str) or not credential_id.strip():
            errors.append(f"{certificate_id}.credential_id must be non-empty")
        elif credential_id in seen_credentials:
            errors.append(f"duplicate credential_id: {credential_id}")
        seen_credentials.add(str(credential_id))

        for field in ("provider", "issuer", "title", "holder"):
            if not isinstance(certificate[field], str) or not certificate[field].strip():
                errors.append(f"{certificate_id}.{field} must be non-empty")

        require_date(certificate["completed_on"], f"{certificate_id}.completed_on", errors)
        require_date(certificate["verified_on"], f"{certificate_id}.verified_on", errors)
        require_https(certificate["verification_url"], f"{certificate_id}.verification_url", errors)
        if certificate["course_url"] is not None:
            require_https(certificate["course_url"], f"{certificate_id}.course_url", errors)
        if certificate["verification_url"] in seen_urls:
            errors.append(f"duplicate verification_url: {certificate['verification_url']}")
        seen_urls.add(str(certificate["verification_url"]))
        if certificate["verification_status"] != "verified":
            errors.append(f"{certificate_id}.verification_status must be verified")

        artifacts = certificate["artifacts"]
        if not isinstance(artifacts, dict):
            errors.append(f"{certificate_id}.artifacts must be an object")
        else:
            validate_artifact(root, certificate_id, "pdf", artifacts.get("pdf"), errors)
            validate_artifact(root, certificate_id, "image", artifacts.get("image"), errors)

        if isinstance(certificate["completed_on"], str) and isinstance(certificate["title"], str):
            observed_order.append((certificate["completed_on"], certificate["title"]))

    parsed_order: list[tuple[dt.date, str]] = []
    for completed_on, title in observed_order:
        try:
            parsed_order.append((dt.date.fromisoformat(completed_on), title))
        except ValueError:
            parsed_order = []
            break
    if parsed_order:
        expected_order = [
            (completed_on.isoformat(), title)
            for completed_on, title in sorted(
                parsed_order,
                key=lambda item: (-item[0].toordinal(), item[1].casefold()),
            )
        ]
        if observed_order != expected_order:
            errors.append(
                "certificates must be ordered by completed_on descending, then title ascending"
            )

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print(f"Validated {len(certificates)} certificates and {len(certificates) * 2} artifacts.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
