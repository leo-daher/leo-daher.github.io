import { useEffect, useId, useRef, useState } from "react";
import { assetUrl, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import "./articles.css";

const articlePath = "/artigos/identidade-visual";
const canonicalUrl = "https://leo-daher.github.io/artigos/identidade-visual/";
const publicationDate = new Date("2026-09-15T13:38:29Z");
const routeHref = (path) =>
  `${import.meta.env.BASE_URL}${path.replace(/^\//, "")}`;
const clamp = (value, min, max) => Math.max(min, Math.min(max, value));
const lerp = (start, end, progress) => start + (end - start) * progress;

function ArticlePublication() {
  const { locale, t } = usePortfolio();
  const lang = locale.startsWith("en") ? "en-US" : "pt-BR";
  const date = new Intl.DateTimeFormat(lang, {
    year: "numeric",
    month: "short",
    day: "numeric",
    timeZone: "America/Sao_Paulo",
  }).format(publicationDate);
  const time = new Intl.DateTimeFormat(lang, {
    hour: "numeric",
    minute: "2-digit",
    timeZone: "America/Sao_Paulo",
  }).format(publicationDate);
  const label = t("articlePublishedAt")
    .replace("{date}", date)
    .replace("{time}", time)
    .replace("{timeZone}", "BRT");
  return (
    <p className="article-publication">
      <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true">
        <circle
          cx="12"
          cy="12"
          r="9"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
        />
        <path
          d="M12 7v5l3 2"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
        />
      </svg>
      <time dateTime="2026-09-15T13:38:29Z">{label}</time>
    </p>
  );
}

function ArticleCardIcon() {
  return (
    <span className="article-card-icon" aria-hidden="true">
      <svg viewBox="0 0 24 24" width="24" height="24">
        <rect
          x="4"
          y="3"
          width="16"
          height="18"
          rx="2"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
        />
        <path
          d="M8 7h8M8 11h8M8 15h4"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
        />
      </svg>
    </span>
  );
}

export function ArticlesSection() {
  const { t, navigate } = usePortfolio();
  return (
    <section
      className="section-frame articles-section"
      id="artigos"
      aria-label={t("articlesEyebrow")}
    >
      <SectionHeading
        eyebrow={t("articlesEyebrow")}
        title={t("articlesTitle")}
        copy={t("articlesCopy")}
      />
      <a
        className="article-home-card"
        href={routeHref(articlePath)}
        onClick={(event) => {
          if (
            !event.metaKey &&
            !event.ctrlKey &&
            !event.shiftKey &&
            event.button === 0
          ) {
            event.preventDefault();
            navigate(articlePath);
          }
        }}
      >
        <ArticleCardIcon />
        <div className="article-card-copy">
          <h3>{t("identityArticleTitle")}</h3>
          <p>{t("identityArticleSummary")}</p>
          <ArticlePublication />
        </div>
        <span className="article-card-arrow" aria-hidden="true">
          <Icon name="arrow-right" />
        </span>
      </a>
    </section>
  );
}

function ArticleFigure({ name, caption, semanticLabel, children }) {
  return (
    <figure className={`identity-figure identity-${name}-figure`}>
      <div
        className="identity-figure-surface"
        role="img"
        aria-label={semanticLabel}
      >
        <div aria-hidden="true">{children}</div>
      </div>
      <figcaption>{caption}</figcaption>
    </figure>
  );
}

function useMarkColors() {
  const { theme } = usePortfolio();
  return theme === "dark"
    ? { l: "#F3F6F5", d: "#CFC7F4" }
    : { l: "#111318", d: "#30313A" };
}

function LogoFigure() {
  const { t, theme } = usePortfolio();
  return (
    <ArticleFigure
      name="logo"
      caption={t("identityArticleLogoCaption")}
      semanticLabel={t("identityArticleLogoSemantics")}
    >
      <div className="identity-logo-stage">
        <img
          src={assetUrl(
            `assets/brand/ld-mark${theme === "dark" ? "-inverse" : ""}.svg`,
          )}
          width="210"
          height="210"
          alt=""
        />
      </div>
    </ArticleFigure>
  );
}

function useFigureDimensions() {
  const svg = useRef(null);
  const [dimensions, setDimensions] = useState({ width: 860, height: 400 });
  useEffect(() => {
    const measure = () => {
      const width = svg.current?.getBoundingClientRect().width;
      if (width)
        setDimensions((current) =>
          Math.abs(current.width - width) > 0.5
            ? { width, height: width / (width < 560 ? 1.48 : 2.15) }
            : current,
        );
    };
    measure();
    if (!globalThis.ResizeObserver) {
      window.addEventListener("resize", measure);
      return () => window.removeEventListener("resize", measure);
    }
    const observer = new ResizeObserver(measure);
    observer.observe(svg.current);
    return () => observer.disconnect();
  }, []);
  return [svg, dimensions];
}

function ExplodedFigure() {
  const { t } = usePortfolio();
  const { l, d } = useMarkColors();
  const [svg, { width, height }] = useFigureDimensions();
  const side = Math.min(height * 0.72, width * 0.5),
    scale = side / 256;
  const x = (width - side) / 2,
    y = (height - side) / 2;
  const lShift = [-side * 0.34, side * 0.08],
    dShift = [side * 0.26, -side * 0.08],
    dotShift = [side * 0.42, side * 0.12];
  const shadowId = useId();
  const cutX = x + 182 * scale,
    cutY = y + 232 * scale;
  const lPath = "M24 50V196Q24 232 60 232H180";
  const dPath = "M50 24H186Q232 24 232 70V186Q232 232 186 232H180";
  const transform = (shift) =>
    `translate(${x + shift[0]} ${y + shift[1]}) scale(${scale})`;
  const guides = [
    [0.28, 0.55, lShift],
    [0.68, 0.32, dShift],
    [0.7, 0.7, dotShift],
  ];
  return (
    <ArticleFigure
      name="exploded"
      caption={t("identityArticleExplodedCaption")}
      semanticLabel={t("identityArticleExplodedSemantics")}
    >
      <svg
        ref={svg}
        className="identity-exploded-svg"
        viewBox={`0 0 ${width} ${height}`}
        width="100%"
        aria-hidden="true"
      >
        <defs>
          <filter id={shadowId} x="-50%" y="-50%" width="200%" height="220%">
            <feDropShadow
              dx="0"
              dy={4 * scale}
              stdDeviation={Math.max(3, 8 * scale) / 2}
              floodOpacity=".32"
            />
          </filter>
        </defs>
        <g
          transform={transform([0, 0])}
          fill="none"
          strokeWidth="14"
          strokeLinecap="round"
          strokeLinejoin="round"
          opacity=".10"
        >
          <path d={lPath} stroke={l} />
          <path d={dPath} stroke={d} />
          <rect
            x="155"
            y="155"
            width="48"
            height="48"
            rx="17"
            fill="#FF6B55"
            stroke="none"
          />
        </g>
        <g stroke="var(--muted)" strokeOpacity=".22" strokeWidth="1.2">
          {guides.map(([gx, gy, shift], index) => (
            <line
              key={index}
              x1={x + side * gx}
              y1={y + side * gy}
              x2={x + side * gx + shift[0]}
              y2={y + side * gy + shift[1]}
              strokeDasharray={`${Math.hypot(...shift) / 7} ${Math.hypot(...shift) / 7}`}
            />
          ))}
        </g>
        <path
          d={lPath}
          transform={transform(lShift)}
          fill="none"
          stroke={l}
          strokeWidth="14"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        <path
          d={dPath}
          transform={transform(dShift)}
          fill="none"
          stroke={d}
          strokeWidth="14"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        <rect
          x={x + 155 * scale + dotShift[0]}
          y={y + 155 * scale + dotShift[1]}
          width={48 * scale}
          height={48 * scale}
          rx={17 * scale}
          fill="#FF6B55"
          filter={`url(#${shadowId})`}
        />
        <path
          d={`M${x + 176 * scale} ${y + 240 * scale}L${x + 188 * scale} ${y + 224 * scale}`}
          stroke="var(--raised)"
          strokeWidth={Math.max(2, 4 * scale)}
          strokeLinecap="round"
        />
        <circle
          cx={cutX}
          cy={cutY}
          r={Math.max(6, 11 * scale)}
          fill="none"
          stroke="#FFB464"
          strokeWidth="2"
        />
      </svg>
      <div className="identity-figure-legends">
        {[
          [t("identityArticleLLabel"), l],
          [t("identityArticleDLabel"), d],
          [t("identityArticleCutLabel"), "#FFB464"],
          [t("identityArticleDotLabel"), "#FF6B55"],
        ].map(([label, color]) => (
          <span
            className="identity-figure-legend"
            key={label}
            style={{ "--legend-color": color }}
          >
            <i />
            {label}
          </span>
        ))}
      </div>
    </ArticleFigure>
  );
}

function MenuGlyph() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M4 6h16M4 12h16M4 18h16"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
      />
    </svg>
  );
}

function FabFigure() {
  const { t, theme } = usePortfolio();
  return (
    <ArticleFigure
      name="fab"
      caption={t("identityArticleFabCaption")}
      semanticLabel={t("identityArticleFabSemantics")}
    >
      <div className="identity-fab-comparison">
        <div className="identity-comparison-stage">
          <img
            src={assetUrl(
              `assets/brand/ld-mark${theme === "dark" ? "-inverse" : ""}.svg`,
            )}
            width="142"
            height="142"
            alt=""
          />
          <strong>{t("identityArticleBrandDotStage")}</strong>
        </div>
        <span className="identity-comparison-arrow">
          <Icon name="arrow-right" size={30} />
        </span>
        <div className="identity-comparison-stage">
          <span className="identity-functional-fab">
            <MenuGlyph />
          </span>
          <strong>{t("identityArticleFunctionalFabStage")}</strong>
        </div>
      </div>
    </ArticleFigure>
  );
}

// Flutter's easeInOutCubic and easeInCubic curves expressed as cubic Béziers.
function cubicCurve(progress, x1, y1, x2, y2) {
  const coordinate = (value, a, b) =>
    3 * (1 - value) ** 2 * value * a +
    3 * (1 - value) * value ** 2 * b +
    value ** 3;
  let low = 0,
    high = 1;
  for (let iteration = 0; iteration < 24; iteration++) {
    const middle = (low + high) / 2;
    if (coordinate(middle, x1, x2) < progress) low = middle;
    else high = middle;
  }
  return coordinate((low + high) / 2, y1, y2);
}
const interval = (value, start, end, curve) =>
  curve(clamp((value - start) / (end - start), 0, 1));
const easeInOut = (value) => cubicCurve(value, 0.645, 0.045, 0.355, 1);
const easeIn = (value) => cubicCurve(value, 0.55, 0.055, 0.675, 0.19);

function OpeningSnapshot({ progress, interfaceVisible }) {
  const { l, d } = useMarkColors();
  const maskId = useId();
  const viewportWidth = 400,
    viewportHeight = 300,
    side = 138;
  const initialRadius = side * 0.18,
    initialButtonSize = 26.22,
    initialButtonRadius = initialButtonSize * 0.35;
  const initialCornerX = (viewportWidth + side) / 2 - initialRadius;
  const initialCornerY = (viewportHeight + side) / 2 - initialRadius;
  const initialButtonCenterX =
    initialCornerX -
    (initialButtonSize - initialButtonRadius) +
    initialButtonSize / 2;
  const initialButtonCenterY =
    initialCornerY -
    (initialButtonSize - initialButtonRadius) +
    initialButtonSize / 2;
  const travel = interval(progress, 0.12, 0.7, easeInOut);
  const buttonSize = lerp(initialButtonSize, 56, travel),
    buttonRadius = lerp(initialButtonRadius, 16, travel);
  const buttonX = lerp(initialButtonCenterX, viewportWidth - 44, travel),
    buttonY = lerp(initialButtonCenterY, viewportHeight - 44, travel);
  const fit = interval(progress, 0.08, 0.7, easeInOut),
    exit = interval(progress, 0.76, 1, easeIn);
  const left = lerp(lerp((viewportWidth - side) / 2, 0, fit), -56, exit);
  const top = lerp(lerp((viewportHeight - side) / 2, 0, fit), -56, exit);
  const right = lerp(
    lerp((viewportWidth + side) / 2, viewportWidth, fit),
    viewportWidth + 56,
    exit,
  );
  const bottom = lerp(
    lerp((viewportHeight + side) / 2, viewportHeight, fit),
    viewportHeight + 56,
    exit,
  );
  const stroke = clamp(side * 0.058, 8, 12);
  const radiusX = clamp(
    right - buttonX - (buttonSize / 2 - buttonRadius),
    0,
    (right - left) / 2,
  );
  const radiusY = clamp(
    bottom - buttonY - (buttonSize / 2 - buttonRadius),
    0,
    (bottom - top) / 2,
  );
  const radius = Math.min(radiusX, radiusY),
    lRadius = radius * 0.76;
  const opening = Math.max(stroke * 1.55, radius * 0.58);
  const joinX = Math.max(
    left + lRadius + stroke,
    right - radiusX - stroke * 0.18,
  );
  const lPath = `M${left} ${top + opening}V${bottom - lRadius}A${lRadius} ${lRadius} 0 0 0 ${left + lRadius} ${bottom}H${joinX}`;
  const dPath = `M${left + opening} ${top}H${right - radius}A${radius} ${radius} 0 0 1 ${right} ${top + radius}V${bottom - radiusY}A${radiusX} ${radiusY} 0 0 1 ${right - radiusX} ${bottom}H${joinX}`;
  return (
    <svg
      className="identity-opening-snapshot"
      viewBox="0 0 400 300"
      aria-hidden="true"
    >
      {interfaceVisible && (
        <g>
          <rect width="400" height="300" fill="var(--canvas)" />
          <rect
            x="32"
            y="30"
            width="264"
            height="27"
            rx="14"
            fill="var(--muted)"
            opacity=".22"
          />
          <circle cx="48" cy="43.5" r="5.4" fill="var(--violet)" />
          <rect
            x="32"
            y="90"
            width="184"
            height="36"
            rx="8"
            fill="var(--ink)"
            opacity=".72"
          />
          <rect
            x="32"
            y="156"
            width="192"
            height="87"
            rx="12"
            fill="var(--violet)"
            opacity=".34"
          />
          <rect
            x="244"
            y="90"
            width="92"
            height="90"
            rx="12"
            fill="#65B4FF"
            opacity=".28"
          />
        </g>
      )}
      <rect width="400" height="300" fill="var(--canvas)" opacity={1 - exit} />
      <defs>
        <mask id={maskId}>
          <rect width="400" height="300" fill="white" />
          <path
            d={`M${joinX - stroke * 0.29} ${bottom + stroke * 0.57}L${joinX + stroke * 0.57} ${bottom - stroke * 0.57}`}
            stroke="black"
            strokeWidth={stroke * (4 / 14)}
            strokeLinecap="round"
          />
        </mask>
      </defs>
      <g
        fill="none"
        strokeWidth={stroke}
        strokeLinecap="butt"
        strokeLinejoin="round"
        mask={`url(#${maskId})`}
      >
        <path d={lPath} stroke={l} />
        <path d={dPath} stroke={d} />
      </g>
      <circle cx={left} cy={top + opening} r={stroke / 2} fill={l} />
      <circle cx={left + opening} cy={top} r={stroke / 2} fill={d} />
      <rect
        x={buttonX - buttonSize / 2}
        y={buttonY - buttonSize / 2}
        width={buttonSize}
        height={buttonSize}
        rx={buttonRadius}
        fill="#FF6B55"
        className="identity-snapshot-fab"
      />
      {interfaceVisible && (
        <path
          d={`M${buttonX - 8} ${buttonY - 6}h16M${buttonX - 8} ${buttonY}h16M${buttonX - 8} ${buttonY + 6}h16`}
          stroke="#F8FAF7"
          strokeWidth="2"
          strokeLinecap="round"
        />
      )}
    </svg>
  );
}

function OpeningSequenceFigure() {
  const { t } = usePortfolio();
  return (
    <ArticleFigure
      name="opening-sequence"
      caption={t("identityArticleMotionCaption")}
      semanticLabel={t("identityArticleMotionSemantics")}
    >
      <div className="identity-opening-stages">
        {[
          ["identityArticleOpeningLogoStage", 0, false],
          ["identityArticleOpeningExpansionStage", 0.4, false],
          ["identityArticleOpeningViewportStage", 0.7, false],
          ["identityArticleOpeningInterfaceStage", 1, true],
        ].map(([key, progress, interfaceVisible]) => (
          <div className="identity-opening-stage" key={key}>
            <OpeningSnapshot
              progress={progress}
              interfaceVisible={interfaceVisible}
            />
            <strong>{t(key)}</strong>
          </div>
        ))}
      </div>
    </ArticleFigure>
  );
}

function ArticleSectionHeading({ eyebrow, title }) {
  return (
    <div className="identity-article-section-heading">
      <p>{eyebrow}</p>
      <h2>{title}</h2>
    </div>
  );
}

function ShareArticle() {
  const { t } = usePortfolio();
  const title = t("identityArticleTitle");
  const shareUrl = (base, params) => `${base}?${new URLSearchParams(params)}`;
  const links = [
    {
      label: "LinkedIn",
      className: "linkedin",
      url: shareUrl("https://www.linkedin.com/sharing/share-offsite/", {
        url: canonicalUrl,
      }),
      icon: "linkedin-symbol.svg",
    },
    {
      label: "WhatsApp",
      className: "whatsapp",
      url: shareUrl("https://wa.me/", { text: `${title} ${canonicalUrl}` }),
      icon: "whatsapp-symbol.svg",
    },
    {
      label: "X",
      className: "x",
      url: shareUrl("https://twitter.com/intent/tweet", {
        text: title,
        url: canonicalUrl,
      }),
      mark: "𝕏",
    },
    {
      label: "Facebook",
      className: "facebook",
      url: shareUrl("https://www.facebook.com/sharer/sharer.php", {
        u: canonicalUrl,
      }),
      mark: "f",
    },
  ];
  return (
    <div className="identity-article-share">
      <h2>{t("shareArticleTitle")}</h2>
      <p>{t("shareArticleCopy")}</p>
      <div className="article-share-badges">
        {links.map((link) => (
          <a
            href={link.url}
            target="_blank"
            rel="noopener noreferrer"
            className={`article-share-badge ${link.className}`}
            key={link.label}
            aria-label={`${t("shareOn")} ${link.label}`}
          >
            {link.icon ? (
              <img
                src={assetUrl(`assets/brand/${link.icon}`)}
                width="18"
                height="18"
                alt=""
              />
            ) : (
              <span className="article-share-mark" aria-hidden="true">
                {link.mark}
              </span>
            )}
            {link.label}
          </a>
        ))}
      </div>
    </div>
  );
}

export function ArticlePage() {
  const { t } = usePortfolio();
  return (
    <article className="identity-article-page">
      <header className="identity-article-header">
        <h1>{t("identityArticleTitle")}</h1>
        <p>{t("identityArticleSummary")}</p>
        <ArticlePublication />
      </header>
      <LogoFigure />
      <p className="identity-article-body identity-article-prominent identity-article-intro">
        {t("identityArticleIntro")}
      </p>
      <section className="identity-article-section">
        <ArticleSectionHeading
          eyebrow={t("identityArticleStructureEyebrow")}
          title={t("identityArticleStructureTitle")}
        />
        <p className="identity-article-body">
          {t("identityArticleStructureBody")}
        </p>
        <ExplodedFigure />
      </section>
      <section className="identity-article-section">
        <ArticleSectionHeading
          eyebrow={t("identityArticleFabEyebrow")}
          title={t("identityArticleFabTitle")}
        />
        <p className="identity-article-body">{t("identityArticleFabBody")}</p>
        <p className="identity-article-body">
          {t("identityArticleFabColorBody")}
        </p>
        <FabFigure />
      </section>
      <section className="identity-article-section">
        <ArticleSectionHeading
          eyebrow={t("identityArticleMotionEyebrow")}
          title={t("identityArticleMotionTitle")}
        />
        <p className="identity-article-body">
          {t("identityArticleMotionBody")}
        </p>
        <p className="identity-article-body">
          {t("identityArticleMotionEffectBody")}
        </p>
        <OpeningSequenceFigure />
      </section>
      <div className="identity-article-conclusion">
        <p className="identity-article-body identity-article-prominent">
          {t("identityArticleConclusion")}
        </p>
      </div>
      <ShareArticle />
    </article>
  );
}
