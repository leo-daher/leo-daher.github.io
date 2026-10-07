import { useEffect, useMemo, useRef, useState } from "react";
import { assetUrl, routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import "./certificates.css";

let catalogRequest;
function loadCatalog() {
  if (!catalogRequest) {
    catalogRequest = fetch(assetUrl("assets/certificates/catalog.json"))
      .then((response) => {
        if (!response.ok) throw new Error("Certificate catalog unavailable.");
        return response.json();
      })
      .then((catalog) => {
        if (
          catalog.schema_version !== 1 ||
          !Array.isArray(catalog.certificates)
        ) {
          throw new Error("Unsupported certificate catalog.");
        }
        return [...catalog.certificates].sort((a, b) =>
          b.completed_on.localeCompare(a.completed_on),
        );
      })
      .catch((error) => {
        catalogRequest = undefined;
        throw error;
      });
  }
  return catalogRequest;
}

function useCertificates() {
  const { initialCertificates } = usePortfolio();
  const hasSeed = Array.isArray(initialCertificates);
  const [certificates, setCertificates] = useState(() =>
    hasSeed
      ? [...initialCertificates].sort((a, b) =>
          b.completed_on.localeCompare(a.completed_on),
        )
      : null,
  );
  const [failed, setFailed] = useState(false);
  const [attempt, setAttempt] = useState(0);
  useEffect(() => {
    if (hasSeed) return;
    let active = true;
    setFailed(false);
    loadCatalog()
      .then((records) => {
        if (active) setCertificates(records);
      })
      .catch(() => {
        if (active) setFailed(true);
      });
    return () => {
      active = false;
    };
  }, [hasSeed, attempt]);
  return {
    certificates,
    failed,
    retry: () => setAttempt((value) => value + 1),
  };
}

const format = (value, replacements) =>
  Object.entries(replacements).reduce(
    (text, [key, replacement]) => text.replaceAll(`{${key}}`, replacement),
    value,
  );

function TechnologyTags({ technologies, compact = false }) {
  const { t } = usePortfolio();
  return (
    <span
      role="group"
      className={`certificate-tags${compact ? " certificate-tags-compact" : ""}`}
      aria-label={`${t("technologies")}: ${technologies.join(", ")}`}
    >
      {technologies.map((technology) => (
        <span className="certificate-tag" key={technology} aria-hidden="true">
          {technology}
        </span>
      ))}
    </span>
  );
}

function CertificatePreview({ certificate, onClose }) {
  const { t } = usePortfolio();
  const dialog = useRef(null);
  useEffect(() => {
    const previousFocus = document.activeElement;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const modal = dialog.current;
    modal.showModal();
    modal.querySelector("button")?.focus();
    return () => {
      modal.close();
      document.body.style.overflow = previousOverflow;
      previousFocus?.focus?.();
    };
  }, []);
  return (
    <dialog
      ref={dialog}
      className="certificate-dialog"
      aria-labelledby="certificate-preview-title"
      onCancel={(event) => {
        event.preventDefault();
        onClose();
      }}
      onClick={(event) => {
        if (event.target === dialog.current) {
          const bounds = dialog.current.getBoundingClientRect();
          if (
            event.clientX < bounds.left ||
            event.clientX > bounds.right ||
            event.clientY < bounds.top ||
            event.clientY > bounds.bottom
          )
            onClose();
        }
      }}
    >
      <div className="certificate-dialog-content">
        <div className="certificate-dialog-header">
          <div>
            <h2 id="certificate-preview-title">{certificate.title}</h2>
            <TechnologyTags technologies={certificate.technologies} />
          </div>
          <button
            className="certificate-close"
            onClick={onClose}
            aria-label={t("closeDialog")}
            title={t("closeDialog")}
          >
            <Icon name="close" />
          </button>
        </div>
        <img
          className="certificate-original"
          src={assetUrl(certificate.artifacts.image.path)}
          alt={certificate.title}
        />
        <a
          className="certificate-verify"
          href={certificate.verification_url}
          target="_blank"
          rel="noopener noreferrer"
        >
          <Icon name="check" size={18} />
          {t("verifyCredential")}
        </a>
      </div>
    </dialog>
  );
}

function CertificateCard({ certificate, onOpen, highlight = false }) {
  const { t } = usePortfolio();
  return (
    <button
      className={`certificate-card${highlight ? " certificate-highlight" : " certificate-gallery-card"}`}
      onClick={() => onOpen(certificate)}
    >
      {!highlight && (
        <span className="certificate-card-arrow" aria-hidden="true">
          <Icon name="external" size={18} />
        </span>
      )}
      <span className="certificate-card-title">{certificate.title}</span>
      <TechnologyTags
        technologies={
          highlight
            ? certificate.technologies.slice(0, 2)
            : certificate.technologies
        }
        compact={highlight}
      />
      <span className="certificate-issuer">
        {format(t("issuedBy"), { issuer: certificate.issuer })}
      </span>
    </button>
  );
}

function CatalogStatus({ failed, retry }) {
  const { locale } = usePortfolio();
  const english = locale.startsWith("en");
  if (!failed)
    return (
      <div
        className="certificate-loading"
        role="status"
        aria-label={
          english ? "Loading certificates" : "Carregando certificações"
        }
      >
        <span />
      </div>
    );
  return (
    <div className="certificate-load-error" role="status">
      <p>
        {english
          ? "Certificates could not be loaded."
          : "Não foi possível carregar as certificações."}
      </p>
      <button onClick={retry}>
        {english ? "Try again" : "Tentar novamente"}
      </button>
    </div>
  );
}

export function CertificatesSection() {
  const { t, navigate, locale } = usePortfolio();
  const { certificates, failed, retry } = useCertificates();
  const [preview, setPreview] = useState(null);
  const featured = useMemo(() => {
    if (!certificates) return [];
    const records = [];
    for (const matches of [
      (record) => record.id === "udemy-uc-46b08eb2-381d-4fd1-a961-d6850f1680ba",
      (record) => record.technologies.includes("Flutter"),
      (record) => record.title.toLowerCase().includes("ai fluency"),
      (record) => record.technologies.includes("MCP"),
    ]) {
      if (records.length === 3) break;
      const first = certificates.find(
        (record) => matches(record) && !records.includes(record),
      );
      if (first) records.push(first);
    }
    for (const record of certificates) {
      if (records.length === 3) break;
      if (!records.includes(record)) records.push(record);
    }
    return records;
  }, [certificates]);
  return (
    <section
      className="section-frame certificates-section"
      id="certificacoes"
      aria-label={t("certificationsEyebrow")}
    >
      <SectionHeading
        eyebrow={t("certificationsEyebrow")}
        title={t("certificationsTitle")}
        copy={t("certificationsCopy")}
        copyBelowTitle
      />
      {certificates ? (
        <div className="certificate-highlights">
          {featured.map((record) => (
            <CertificateCard
              key={record.id}
              certificate={record}
              onOpen={setPreview}
              highlight
            />
          ))}
          <a
            className="certificate-view-all"
            href={routeHref("/certificacoes", locale)}
            onClick={(event) => {
              if (
                !event.metaKey &&
                !event.ctrlKey &&
                !event.shiftKey &&
                event.button === 0
              ) {
                event.preventDefault();
                navigate("/certificacoes");
              }
            }}
          >
            <span className="certificate-view-arrow" aria-hidden="true">
              <Icon name="arrow-right" size={28} />
            </span>
            <span className="certificate-view-copy">
              <strong>{t("viewAllCertificates")}</strong>
              <span>{t("certificateRegisterCopy")}</span>
            </span>
          </a>
        </div>
      ) : (
        <CatalogStatus failed={failed} retry={retry} />
      )}
      {preview && (
        <CertificatePreview
          certificate={preview}
          onClose={() => setPreview(null)}
        />
      )}
    </section>
  );
}

export function CertificatesPage() {
  const { t } = usePortfolio();
  const { certificates, failed, retry } = useCertificates();
  const [selected, setSelected] = useState([]);
  const [expanded, setExpanded] = useState(false);
  const [preview, setPreview] = useState(null);
  const technologies = useMemo(() => {
    const tags = [
      ...new Set((certificates || []).flatMap((record) => record.technologies)),
    ];
    const priority = ["Flutter", "Dart"];
    return tags.sort((a, b) => {
      const aIndex = priority.indexOf(a),
        bIndex = priority.indexOf(b);
      if (aIndex !== -1 || bIndex !== -1)
        return aIndex === -1 ? 1 : bIndex === -1 ? -1 : aIndex - bIndex;
      return a.toLowerCase().localeCompare(b.toLowerCase());
    });
  }, [certificates]);
  const groups = useMemo(() => {
    const years = new Map();
    for (const record of certificates || []) {
      if (
        selected.length &&
        !record.technologies.some((technology) => selected.includes(technology))
      )
        continue;
      const year = record.completed_on.slice(0, 4);
      if (!years.has(year)) years.set(year, []);
      years.get(year).push(record);
    }
    return [...years].sort(([a], [b]) => b.localeCompare(a));
  }, [certificates, selected]);
  return (
    <div className="certificate-register-page">
      <h1>{t("certificateRegister")}</h1>
      <p className="certificate-register-copy">
        {t("certificateRegisterCopy")}
      </p>
      {!certificates ? (
        <CatalogStatus failed={failed} retry={retry} />
      ) : (
        <>
          <div
            className={`certificate-filters${expanded ? " is-expanded" : ""}`}
            role="group"
            aria-label={t("filterTechnologies")}
          >
            <button
              className="certificate-filter-toggle"
              aria-expanded={expanded}
              aria-controls="certificate-filter-options"
              onClick={() => setExpanded((value) => !value)}
            >
              <svg
                viewBox="0 0 24 24"
                width="18"
                height="18"
                aria-hidden="true"
              >
                <path
                  d="M4 6h16M7 12h10M10 18h4"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
              <span>{t("filterTechnologies")}</span>
              {selected.length > 0 && (
                <span className="certificate-filter-count">
                  {selected.length}
                </span>
              )}
              <svg
                className="certificate-filter-chevron"
                viewBox="0 0 24 24"
                width="22"
                height="22"
                aria-hidden="true"
              >
                <path
                  d="m7 10 5 5 5-5"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
            <div
              className="certificate-filter-options"
              id="certificate-filter-options"
            >
              <div className="certificate-filter-header">
                <span>{t("filterTechnologies")}</span>
                {selected.length > 0 && (
                  <button
                    className="certificate-clear-filters"
                    onClick={() => setSelected([])}
                  >
                    {t("clearFilters")}
                  </button>
                )}
              </div>
              <div className="certificate-filter-chips">
                {technologies.map((technology) => (
                  <button
                    className={`certificate-filter-chip${selected.includes(technology) ? " is-selected" : ""}`}
                    aria-pressed={selected.includes(technology)}
                    key={technology}
                    onClick={() =>
                      setSelected((current) =>
                        current.includes(technology)
                          ? current.filter((tag) => tag !== technology)
                          : [...current, technology],
                      )
                    }
                  >
                    {["Flutter", "Dart"].includes(technology) && (
                      <img
                        src={assetUrl(
                          `assets/brand/${technology.toLowerCase()}-logo.svg`,
                        )}
                        width="18"
                        height="18"
                        alt=""
                      />
                    )}
                    {technology}
                  </button>
                ))}
              </div>
            </div>
          </div>
          <div
            className="certificate-results"
            key={selected.slice().sort().join("-") || "all"}
          >
            {groups.map(([year, records]) => (
              <section
                className="certificate-year-group"
                key={year}
                aria-labelledby={`certificate-year-${year}`}
              >
                <h2 id={`certificate-year-${year}`}>{year}</h2>
                <div className="certificate-year-grid">
                  {records.map((record) => (
                    <CertificateCard
                      certificate={record}
                      onOpen={setPreview}
                      key={record.id}
                    />
                  ))}
                </div>
              </section>
            ))}
          </div>
        </>
      )}
      {preview && (
        <CertificatePreview
          certificate={preview}
          onClose={() => setPreview(null)}
        />
      )}
    </div>
  );
}
