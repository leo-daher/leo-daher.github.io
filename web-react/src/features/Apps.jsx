import { useLayoutEffect, useRef, useState } from "react";
import { assetUrl, routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import "./apps.css";

import { APP_ITEMS, APP_CASES, FEATURED_APPS } from "../data/apps.js";
import { APP_STORIES } from "../data/app-stories.js";

function internalLink(event, path, navigate) {
  if (
    event.button === 0 &&
    !event.metaKey &&
    !event.ctrlKey &&
    !event.shiftKey &&
    !event.altKey
  ) {
    event.preventDefault();
    navigate(path);
  }
}

function AppIcons({ images, catalog = false }) {
  return (
    <span
      className={`app-icons ${catalog ? "app-icons--catalog" : "app-icons--case"} ${images.length > 1 ? "app-icons--pair" : ""}`}
      aria-hidden="true"
    >
      {images.slice(0, 2).map((image) => (
        <span className="app-icon-frame" key={image}>
          <span
            className="app-icon-image"
            style={{
              backgroundImage: `url("${assetUrl(`/assets/apps/${image}`)}")`,
            }}
          />
        </span>
      ))}
    </span>
  );
}

function AppTile({ item }) {
  const { t, navigate, locale } = usePortfolio();
  const path = `/apps/${item.id}`;
  return (
    <a
      href={routeHref(path, locale)}
      className={`app-store-tile${item.related ? " app-store-tile--suite" : ""}`}
      style={{ "--app-accent": item.accent }}
      aria-label={`${t("openAppDetails")}: ${item.name}`}
      onClick={(event) => internalLink(event, path, navigate)}
      data-app-id={item.id}
    >
      <AppIcons images={item.icons} catalog />
      <span className="app-store-tile-copy">
        <span className="app-store-tile-name">{item.name}</span>
        <span className="app-store-tile-summary">{t(item.summary)}</span>
        <span
          className="app-store-tile-metric"
          title={t("storeCheckedJuly2026")}
        >
          {t(item.metric)}
        </span>
      </span>
      <Icon name="chevron-right" size={22} className="app-store-tile-chevron" />
    </a>
  );
}

function AppGrid({ featured = false }) {
  return (
    <div className="app-store-grid">
      {(featured ? FEATURED_APPS : APP_ITEMS).map((item) => (
        <AppTile item={item} key={item.id} />
      ))}
    </div>
  );
}

export function AppsSection() {
  const { t, navigate, locale } = usePortfolio();
  return (
    <section
      className="apps-storefront section-frame"
      aria-label={t("productionAppsSemanticLabel")}
    >
      <div className="apps-storefront-heading">
        <SectionHeading title={t("featuredAppsTitle")} />
        <a
          className="apps-view-all"
          href={routeHref("/apps", locale)}
          onClick={(event) => internalLink(event, "/apps", navigate)}
        >
          {t("viewAllApps")}
          <Icon name="arrow-right" size={18} />
        </a>
      </div>
      <p className="apps-storefront-supporting">
        {t("featuredAppsSupportingText")}
      </p>
      <AppGrid featured />
    </section>
  );
}

export function AppsPage() {
  const { t } = usePortfolio();
  return (
    <section className="apps-catalog-page section-frame">
      <div className="apps-catalog-heading">
        <SectionHeading level={1} title={t("allAppsTitle")} />
        <p>{t("allAppsSupportingText")}</p>
      </div>
      <AppGrid />
    </section>
  );
}

function Screenshot({ screenshot }) {
  const { t } = usePortfolio();
  const [unavailable, setUnavailable] = useState(false);
  return (
    <figure className="app-screenshot">
      <div className="app-screenshot-frame">
        {unavailable ? (
          <span className="app-screenshot-unavailable">
            {t("appImageUnavailableLabel")}
          </span>
        ) : (
          <img
            src={assetUrl(`/assets/apps/${screenshot.image}`)}
            alt={`${screenshot.app} · ${t("appScreenshotsLabel")} ${screenshot.index}`}
            loading="lazy"
            decoding="async"
            onError={() => setUnavailable(true)}
          />
        )}
      </div>
      {screenshot.caption && <figcaption>{screenshot.caption}</figcaption>}
    </figure>
  );
}

function ScreenshotGallery({ app }) {
  const { t } = usePortfolio();
  const galleryRef = useRef(null);
  const [dimensions, setDimensions] = useState({
    frame: 127,
    padding: 16,
    compact: true,
  });
  const hasCaptions = app.screenshots.some((screenshot) => screenshot.caption);
  useLayoutEffect(() => {
    const gallery = galleryRef.current;
    if (!gallery) return undefined;
    const resize = () => {
      const width = gallery.getBoundingClientRect().width;
      const compact =
        gallery.closest(".app-case").getBoundingClientRect().width < 960;
      const count = app.screenshots.length;
      const fitWidth = (width - 32 - 12 * (count - 1)) / count;
      const frame = compact
        ? Math.max(108, Math.min(127, fitWidth))
        : Math.max(
            116,
            Math.min(((360 - 32 - (hasCaptions ? 28 : 0)) * 9) / 16, fitWidth),
          );
      const contentWidth = frame * count + 12 * (count - 1);
      setDimensions({
        frame,
        padding: Math.max(16, (width - contentWidth) / 2),
        compact,
      });
    };
    resize();
    const observer = new ResizeObserver(resize);
    observer.observe(gallery);
    observer.observe(gallery.closest(".app-case"));
    return () => observer.disconnect();
  }, [app, hasCaptions]);
  return (
    <div
      ref={galleryRef}
      className={`app-gallery ${hasCaptions ? "app-gallery--captions" : ""}`}
      data-route-scroll="screenshots"
      role="region"
      aria-label={t("appScreenshotsLabel")}
      tabIndex={0}
      style={{
        "--screenshot-width": `${dimensions.frame}px`,
        "--gallery-padding": `${dimensions.padding}px`,
        height: dimensions.compact
          ? 32 + (dimensions.frame * 16) / 9 + (hasCaptions ? 28 : 0)
          : 360,
      }}
    >
      {app.screenshots.map((screenshot) => (
        <Screenshot screenshot={screenshot} key={screenshot.image} />
      ))}
    </div>
  );
}

function StoreIcon({ store }) {
  return store === "Google Play" ? (
    <svg
      viewBox="0 0 24 24"
      width="14"
      height="14"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M8 5v14l11-7z" />
    </svg>
  ) : (
    <svg
      viewBox="0 0 24 24"
      width="14"
      height="14"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.3.74 3.1.8 1.2-.25 2.34-.94 3.63-.85 1.55.12 2.72.74 3.49 1.86-3.2 1.93-2.44 6.17.5 7.36-.59 1.55-1.35 3.09-2.72 3.8ZM12.03 7.25c-.15-2.29 1.71-4.17 3.86-4.35.3 2.65-2.4 4.63-3.86 4.35Z" />
    </svg>
  );
}

function StoreProof({ proof, appName }) {
  const { t, theme } = usePortfolio();
  const evidence = proof.evidence ? t(proof.evidence) : null;
  const supporting = proof.date ? t(proof.date) : null;
  const label = [appName, proof.store, evidence, supporting]
    .filter(Boolean)
    .join(" · ");
  const parts = evidence?.split(" · ");
  return (
    <a
      className={`app-store-proof ${proof.store === "Google Play" ? "app-store-proof--play" : "app-store-proof--apple"}`}
      href={proof.href}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={label}
      title={supporting || label}
      data-theme={theme}
    >
      <span className="app-store-proof-heading">
        {proof.product && (
          <>
            <span className="app-store-proof-product">{proof.product}</span>
            <span className="app-store-proof-dot"> · </span>
          </>
        )}
        <StoreIcon store={proof.store} />
        <span className="app-store-proof-name">{proof.store}</span>
        <Icon name="external" size={13} />
      </span>
      {parts && (
        <span className="app-store-proof-evidence">
          {parts.map((part, index) => (
            <span key={`${part}-${index}`}>
              {index > 0 && (
                <span className="app-store-proof-separator"> · </span>
              )}
              <span className={index === 0 ? "app-store-proof-primary" : ""}>
                {part}
              </span>
            </span>
          ))}
        </span>
      )}
    </a>
  );
}

function CaseHeading({ app, item }) {
  const { t } = usePortfolio();
  return (
    <header className="app-case-heading">
      <p className="app-case-context">{t(`${app.prefix}Context`)}</p>
      <div className="app-case-title-row">
        <AppIcons images={item?.icons || app.icons} />
        <h1>{item?.name || app.name}</h1>
      </div>
      <p className="app-case-summary">
        {t(item?.summary || `${app.prefix}Summary`)}
      </p>
    </header>
  );
}

function CaseDetails({ app }) {
  const { t } = usePortfolio();
  return (
    <div className="app-case-details">
      <p
        className="app-case-role"
        aria-label={`${t("appRoleLabel")}: ${t(`${app.prefix}Role`)}`}
      >
        {t(`${app.prefix}Role`)}
      </p>
      <p
        className="app-case-contribution"
        aria-label={`${t("appContributionLabel")}: ${t(`${app.prefix}Contribution`)}`}
      >
        {t(`${app.prefix}Contribution`)}
      </p>
      <p
        className="app-case-stack"
        aria-label={`${t("appStackLabel")}: ${app.stack.join(", ")}`}
      >
        {app.stack.join("  ·  ")}
      </p>
      <div
        className={`app-store-proof-grid ${app.stores.length === 1 ? "app-store-proof-grid--single" : ""}`}
        aria-label={t("appStoreProofLabel")}
      >
        {app.stores.map((proof) => (
          <StoreProof
            proof={proof}
            appName={proof.product ? `Lyzer ${proof.product}` : app.name}
            key={`${proof.productId}-${proof.store}`}
          />
        ))}
      </div>
      {app.recognition && (
        <details className="app-recognition">
          <summary>
            {t("magRecognitionTitle")}
            <Icon name="chevron-right" size={20} />
          </summary>
          <div className="app-recognition-content">
            <p>{t("magRecognitionText")}</p>
            <img
              src={assetUrl(
                "/assets/evidence/mag-venda-digital-reconhecimento-facial.png",
              )}
              alt={t("magRecognitionImageLabel")}
              loading="lazy"
              decoding="async"
            />
          </div>
        </details>
      )}
    </div>
  );
}

function CaseStory({ id }) {
  const { locale } = usePortfolio();
  const sections = APP_STORIES[locale][id];
  if (!sections) return null;
  return (
    <div className="app-case-story">
      {sections.map((section, index) => (
        <section
          className="app-case-story-section"
          aria-labelledby={`case-story-${index}`}
          key={section.title}
        >
          <h2 id={`case-story-${index}`}>{section.title}</h2>
          {section.paragraphs.map((paragraph) => (
            <p key={paragraph}>{paragraph}</p>
          ))}
        </section>
      ))}
    </div>
  );
}

export function AppDetailPage({ id }) {
  const { t, navigate, locale } = usePortfolio();
  const item = APP_ITEMS.find((entry) => entry.id === id);
  const app = APP_CASES[item?.caseId || id];
  if (!app) {
    return (
      <section className="apps-catalog-page section-frame">
        <SectionHeading level={1} title={t("allAppsTitle")} />
        <a
          className="apps-view-all"
          href={routeHref("/apps", locale)}
          onClick={(event) => internalLink(event, "/apps", navigate)}
        >
          {t("viewAllApps")}
          <Icon name="arrow-right" size={18} />
        </a>
      </section>
    );
  }
  return (
    <section className="app-detail-page section-frame">
      <article
        className="app-case"
        style={{ "--app-accent": app.accent }}
        data-app-id={item?.id || id}
        aria-label={`${item?.name || app.name}. ${t(item?.summary || `${app.prefix}Summary`)}`}
      >
        <div className="app-case-mobile-heading">
          <CaseHeading app={app} item={item} />
        </div>
        <ScreenshotGallery app={app} />
        <div className="app-case-copy">
          <div className="app-case-desktop-heading">
            <CaseHeading app={app} item={item} />
          </div>
          <CaseDetails app={app} />
        </div>
        <CaseStory id={item?.id || id} />
      </article>
    </section>
  );
}
