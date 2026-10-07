import { useCallback, useEffect, useRef, useState } from "react";
import {
  PortfolioContext,
  assetUrl,
  basePath,
  contactLinks,
  routeHref,
} from "./context.jsx";
import pt from "./data/pt.json";
import en from "./data/en.json";
import { EXPERIENCES } from "./data/experiences.js";
import { Header, FabMenu, ContactIcon } from "./components/Navigation.jsx";
import { SectionHeading } from "./components/SectionHeading.jsx";
import { Icon } from "./components/Icon.jsx";
import { Hero, Opening } from "./features/Hero.jsx";
import { AppsSection, AppsPage, AppDetailPage } from "./features/Apps.jsx";
import {
  ExperiencesSection,
  ExperiencesPage,
} from "./features/Experiences.jsx";
import {
  CertificatesSection,
  CertificatesPage,
} from "./features/Certificates.jsx";
import { ArticlesSection, ArticlePage } from "./features/Articles.jsx";
import {
  captureAttribution,
  captureError,
  installInteractions,
  portfolioViewed,
  preferenceChanged,
  scrollDepth,
  sectionSelected,
} from "./telemetry.js";
function stored(key, fallback) {
  try {
    return localStorage.getItem(key) || fallback;
  } catch {
    return fallback;
  }
}
function stripLocalePrefix(path) {
  return /^\/(?:pt|en)(?:\/|$)/.test(path) ? path.slice(3) || "/" : path;
}
function routeLocale(path) {
  return /^\/pt(?:\/|$)/.test(path) ? "pt" : "en";
}
function browserPath() {
  let path = window.location.pathname;
  if (basePath !== "/" && path.startsWith(basePath))
    path = "/" + path.slice(basePath.length);
  return path;
}
function relativePath() {
  return stripLocalePrefix(browserPath()).replace(/\/$/, "") || "/";
}
function localizedPath(path, locale) {
  return (
    basePath +
    (locale === "pt" ? "pt/" : "") +
    stripLocalePrefix(path).replace(/^[/\\]+/, "")
  );
}
const isHome = (p) => p === "/" || p === "/ios";
let metadataRequest;
function loadPortfolioMetadata() {
  if (!metadataRequest) {
    metadataRequest = fetch(assetUrl("portfolio.json"))
      .then((response) => {
        if (!response.ok) throw new Error("Portfolio metadata unavailable.");
        return response.json();
      })
      .then((catalog) => {
        if (!Array.isArray(catalog.documents))
          throw new Error("Unsupported portfolio metadata.");
        return catalog;
      })
      .catch((error) => {
        metadataRequest = undefined;
        throw error;
      });
  }
  return metadataRequest;
}
function metadataPath(path, locale) {
  let logicalPath = stripLocalePrefix(path).replace(/\/$/, "") || "/";
  if (["/ios", "/in", "/ig"].includes(logicalPath)) logicalPath = "/";
  if (logicalPath === "/ios/artigos/identidade-visual")
    logicalPath = "/artigos/identidade-visual";
  return locale === "pt"
    ? `/pt${logicalPath === "/" ? "/" : logicalPath}`
    : logicalPath;
}
function headElement(tag, selector, attributes) {
  let element = document.head.querySelector(selector);
  if (!element) {
    element = document.createElement(tag);
    document.head.append(element);
  }
  for (const [name, value] of Object.entries(attributes))
    element.setAttribute(name, value);
  return element;
}

function Proof() {
  const { t } = useCurrent();
  return (
    <section className="section-frame proof-frame">
      <div className="proof-strip">
        <div className="proof-apps">
          <strong>{t("proofAppsValue")}</strong>
          <p>{t("proofAppsLabel")}</p>
        </div>
        <div className="proof-markets">
          <span>{t("proofMarketsLabel")}</span>
          <p>{t("proofMarketsValue")}</p>
        </div>
      </div>
    </section>
  );
}
// Shared sections keep the approved localized copy alongside its visual role.
import { usePortfolio as useCurrent } from "./context.jsx";
function Architecture() {
  const { t } = useCurrent();
  return (
    <section id="system" className="section-frame architecture">
      <SectionHeading title={t("systemTitle")} />
      <div className="architecture-grid">
        {["Product", "Services", "Delivery", "Automation"].map((name, i) => (
          <div className="architecture-scope" key={name}>
            <span>{String(i + 1).padStart(2, "0")}</span>
            <div>
              <h3>{t(`architecture${name}Title`)}</h3>
              <p>{t(`architecture${name}Detail`)}</p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
const direct = [
  ["MAG Seguros", "mag-official.svg"],
  ["Human Robotics", "human_robotics.png", "outline"],
  ["Visagio", "visagio.svg", "visagio"],
  ["Radix", "radix.png"],
  ["Conkord", "conkord-official.svg"],
];
const indirect = [
  ["Van Cranenbroek", "van-cranenbroek-full.svg"],
  ["Lyzer", "lyzer-official.svg", "outline"],
  ["CTT", "ctt-official.svg"],
  ["EY", "ey-official.svg", "outline"],
  ["Iberdrola", "iberdrola-official.svg"],
  ["Águas de Portugal", "adp-official.svg", "outline"],
  ["Água Monchique", "agua-monchique-official.svg", "outline"],
  ["Fullsix", "fullsix-black.png", "mono fullsix"],
  ["Code 495", "code-495-symbol.svg", "code"],
  ["Ascendi", "ascendi-official.png", "outline"],
];
function Clients() {
  const { t, locale } = useCurrent();
  return (
    <section id="clients" className="section-frame clients">
      <SectionHeading title={t("clientsTitle")} />
      {[
        ["directRoles", direct],
        ["viaLatituddeConsulting", indirect],
      ].map(([title, logos]) => (
        <div className="client-group" key={title}>
          <div className="client-group-label">
            <h3>{t(title)}</h3>
            <span>
              {logos.length} {locale === "pt" ? "MARCAS" : "BRANDS"}
            </span>
          </div>
          <div className="clients-grid">
            {logos.map(([name, file, style = ""]) => {
              const experience = EXPERIENCES.find((item) => item.logo === file);
              const path = experience
                ? `/experiencias#${experience.id}`
                : {
                    "MAG Seguros": "/apps/mag-venda-digital",
                    "Van Cranenbroek": "/apps/van-cranenbroek",
                    Conkord: "/experiencias",
                  }[name];
              const Tile = path ? "a" : "div";
              return (
                <Tile
                  className={`client-tile ${style}`}
                  key={name}
                  href={path ? routeHref(path, locale) : undefined}
                  aria-label={
                    path ? `${t("viewClientExperience")}: ${name}` : undefined
                  }
                >
                  <img
                    src={assetUrl("/assets/client_logos/" + file)}
                    alt={name}
                    loading="lazy"
                  />
                  {style === "code" && <span>Code 495</span>}
                </Tile>
              );
            })}
          </div>
        </div>
      ))}
    </section>
  );
}
function Contact() {
  const { t } = useCurrent();
  return (
    <section id="contact" className="section-frame contact">
      <SectionHeading
        eyebrow={t("contactEyebrow")}
        title={t("contactTitle")}
        copy={t("contactCopy")}
      />
      <div className="contact-grid">
        {[
          ["linkedin", "contactLinkedIn", "linkedin-symbol.svg"],
          ["whatsapp", "contactWhatsApp", "whatsapp-symbol.svg"],
          ["github", "contactGitHub", "github-symbol.svg"],
          ["schedule", "contactSchedule", null],
        ].map(([id, label, file]) => (
          <a
            href={contactLinks[id]}
            key={id}
            target="_blank"
            rel="noreferrer"
            className={`contact-card${id === "whatsapp" ? " emphasis" : ""}`}
          >
            <span className="contact-icon">
              <ContactIcon type={id} file={file} />
            </span>
            <div>
              <h3>
                {t(label)}
                <Icon name="external" size={18} />
              </h3>
              <p>{t(label + "Copy")}</p>
            </div>
          </a>
        ))}
      </div>
    </section>
  );
}
function Footer() {
  const { theme } = useCurrent();
  return (
    <footer className="footer">
      <div className="section-frame">
        <span
          className="brand-mark"
          aria-hidden="true"
          style={{
            backgroundImage: `url("${assetUrl(`/assets/brand/ld-mark${theme === "dark" ? "-inverse" : ""}.svg`)}")`,
          }}
        />
        <div className="footer-details">
          <span>LEONE DAHER · 2026</span>
          <span>CNPJ 45.261.043/0001-69</span>
        </div>
      </div>
    </footer>
  );
}
function Home({ active }) {
  return (
    <div id="home" className="home">
      <div className="hero-wrapper">
        <Hero active={active} />
      </div>
      <Proof />
      <div className="home-apps" id="apps">
        <AppsSection />
      </div>
      <ExperiencesSection />
      <Architecture />
      <Clients />
      <CertificatesSection />
      <ArticlesSection />
      <Contact />
      <Footer />
    </div>
  );
}
function ErrorPage({ error }) {
  const { locale } = useCurrent();
  const portuguese = locale === "pt";
  return (
    <section className="section-frame error-page">
      <h1>
        {error
          ? portuguese
            ? "Não foi possível abrir o portfólio."
            : "Unable to open the portfolio."
          : portuguese
            ? "Página não encontrada."
            : "Page not found."}
      </h1>
      <a href={routeHref("/", locale)}>
        {portuguese ? "Voltar ao início" : "Back to home"}
      </a>
    </section>
  );
}
import { Component } from "react";
class ErrorBoundary extends Component {
  state = { error: false };
  static getDerivedStateFromError() {
    return { error: true };
  }
  componentDidCatch(error) {
    captureError(error);
  }
  render() {
    return this.state.error ? <ErrorPage error /> : this.props.children;
  }
}
export default function App({
  initialPath,
  initialLocale,
  initialCertificates,
  staticRender = false,
} = {}) {
  const inBrowser = !staticRender && typeof window !== "undefined";
  const [path, setPath] = useState(
      () =>
        stripLocalePrefix(
          (initialPath ?? (inBrowser ? relativePath() : "/")).split(
            /[?#]/,
            1,
          )[0],
        ).replace(/\/$/, "") || "/",
    ),
    [locale, setLocaleState] = useState(() =>
      inBrowser
        ? routeLocale(browserPath())
        : (initialLocale ?? routeLocale(initialPath ?? "/")),
    ),
    [theme, setThemeState] = useState(() =>
      inBrowser
        ? stored(
            "portfolio_theme",
            matchMedia("(prefers-color-scheme: dark)").matches
              ? "dark"
              : "light",
          )
        : "dark",
    );
  const [reduceMotion, setReduceMotion] = useState(
      () =>
        !inBrowser || matchMedia("(prefers-reduced-motion: reduce)").matches,
    ),
    [opening, setOpening] = useState(
      () =>
        inBrowser &&
        isHome(path) &&
        !matchMedia("(prefers-reduced-motion: reduce)").matches,
    );
  const homeScroll = useRef(0),
    pathRef = useRef(path),
    positions = useRef(new Map()),
    routeFocus = useRef(false);
  const t = useCallback(
    (key, params = {}) => {
      let value = (locale === "pt" ? pt : en)[key] ?? key;
      for (const [name, text] of Object.entries(params))
        value = value.replaceAll("{" + name + "}", String(text));
      return value;
    },
    [locale],
  );
  const setLocale = (v) => {
    if (inBrowser && v !== locale) preferenceChanged("language", v);
    setLocaleState(v);
    if (inBrowser) {
      const url = new URL(window.location.href);
      url.pathname = localizedPath(relativePath(), v);
      window.history.replaceState(
        window.history.state,
        "",
        url.pathname + url.search + url.hash,
      );
    }
    try {
      localStorage.setItem("portfolio_locale", v);
    } catch {
      /* Preferences still work when browser storage is unavailable. */
    }
  };
  const setTheme = (v) => {
    if (inBrowser && v !== theme) preferenceChanged("theme", v);
    setThemeState(v);
    try {
      localStorage.setItem("portfolio_theme", v);
    } catch {
      /* Preferences still work when browser storage is unavailable. */
    }
  };
  const navigate = useCallback(
    (to, { replace = false } = {}) => {
      const url = new URL(to, "https://portfolio.invalid/");
      const next = url.pathname;
      const hash = url.hash.slice(1);
      if (hash) sectionSelected(hash);
      const dest = stripLocalePrefix(next || "/").replace(/\/$/, "") || "/";
      if (isHome(pathRef.current) && isHome(dest) && hash) {
        document.getElementById(hash)?.scrollIntoView({
          behavior: reduceMotion ? "instant" : "smooth",
          block: "start",
        });
        return;
      }
      positions.current.set(pathRef.current, window.scrollY);
      if (isHome(pathRef.current)) homeScroll.current = window.scrollY;
      const target = localizedPath(dest, locale) + url.search + url.hash;
      window.history[replace ? "replaceState" : "pushState"](
        { portfolio: true },
        "",
        target,
      );
      pathRef.current = dest;
      setPath(dest);
      routeFocus.current = true;
      requestAnimationFrame(() => {
        if (hash)
          document.getElementById(hash)?.scrollIntoView({
            behavior: reduceMotion ? "instant" : "smooth",
            block: "start",
          });
        else window.scrollTo(0, 0);
      });
    },
    [locale, reduceMotion],
  );
  useEffect(() => {
    if (!inBrowser) return;
    function pop() {
      const next = relativePath();
      setLocaleState(routeLocale(browserPath()));
      pathRef.current = next;
      setPath(next);
      routeFocus.current = true;
      requestAnimationFrame(() =>
        window.scrollTo(
          0,
          isHome(next) ? homeScroll.current : positions.current.get(next) || 0,
        ),
      );
    }
    function links(e) {
      const a = e.target.closest("a");
      if (
        !a ||
        e.defaultPrevented ||
        e.button !== 0 ||
        e.ctrlKey ||
        e.metaKey ||
        e.shiftKey ||
        e.altKey ||
        a.target ||
        a.hasAttribute("download")
      )
        return;
      const u = new URL(a.href);
      if (u.origin !== location.origin || !u.pathname.startsWith(basePath))
        return;
      const rel = stripLocalePrefix(
        basePath === "/" ? u.pathname : "/" + u.pathname.slice(basePath.length),
      );
      if (/\.[a-z0-9]+$/i.test(rel)) return;
      e.preventDefault();
      navigate(rel + u.search + u.hash);
    }
    window.addEventListener("popstate", pop);
    document.addEventListener("click", links);
    return () => {
      window.removeEventListener("popstate", pop);
      document.removeEventListener("click", links);
    };
  }, [inBrowser, navigate]);
  useEffect(() => {
    if (!inBrowser || !/^\/en(?:\/|$)/.test(browserPath())) return;
    const url = new URL(window.location.href);
    url.pathname = localizedPath(relativePath(), "en");
    history.replaceState(
      history.state,
      "",
      url.pathname + url.search + url.hash,
    );
  }, [inBrowser]);
  useEffect(() => {
    if (!inBrowser) return;
    document.documentElement.lang = locale === "pt" ? "pt-BR" : "en";
    document.documentElement.dataset.theme = theme;
    document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute("content", theme === "dark" ? "#08080D" : "#F7F7FB");
    if (routeFocus.current) {
      const heading = [
        ...document.querySelectorAll(
          `${isHome(path) ? ".home" : ".route-page"} h1, ${isHome(path) ? ".home" : ".route-page"} h2`,
        ),
      ].find((el) => el.getClientRects().length);
      heading?.setAttribute("tabindex", "-1");
      heading?.focus({ preventScroll: true });
      routeFocus.current = false;
    }
  }, [inBrowser, locale, theme, path]);
  useEffect(() => {
    if (!inBrowser) return;
    let active = true;
    loadPortfolioMetadata()
      .then(({ documents }) => {
        if (!active) return;
        const logicalPath =
          metadataPath(path, locale).replace(/\/$/, "") || "/";
        const current = documents.find(
          (item) =>
            item.locale === locale &&
            (item.path.replace(/\/$/, "") || "/") === logicalPath,
        );
        if (!current) return;
        document.title = current.title;
        headElement("meta", 'meta[name="description"]', {
          name: "description",
          content: current.description,
        });
        for (const [property, content] of Object.entries({
          "og:title": current.title,
          "og:description": current.description,
          "og:url": current.url,
          "og:locale": locale === "pt" ? "pt_BR" : "en_US",
          "og:locale:alternate": locale === "pt" ? "en_US" : "pt_BR",
          "og:type": current.id === "visual-identity" ? "article" : "website",
        }))
          headElement("meta", `meta[property="${property}"]`, {
            property,
            content,
          });
        for (const [name, content] of Object.entries({
          "twitter:title": current.title,
          "twitter:description": current.description,
        }))
          headElement("meta", `meta[name="${name}"]`, { name, content });
        headElement("link", 'link[rel="canonical"]', {
          rel: "canonical",
          href: current.url,
        });
        headElement("link", 'link[rel="alternate"][type="text/markdown"]', {
          rel: "alternate",
          type: "text/markdown",
          href: current.markdownUrl,
        });
        headElement("link", 'link[rel="describedby"][type="text/plain"]', {
          rel: "describedby",
          type: "text/plain",
          href: assetUrl("llms.txt"),
        });
        const structuredData = headElement(
          "script",
          "#portfolio-structured-data",
          {
            id: "portfolio-structured-data",
            type: "application/ld+json",
          },
        );
        structuredData.textContent = JSON.stringify(current.schema);
        document.head
          .querySelectorAll('link[rel="alternate"][hreflang]')
          .forEach((link) => link.remove());
        for (const translation of documents.filter(
          (item) => item.id === current.id,
        )) {
          const language = translation.locale === "pt" ? "pt-BR" : "en";
          headElement("link", `link[rel="alternate"][hreflang="${language}"]`, {
            rel: "alternate",
            hreflang: language,
            href: translation.url,
          });
        }
        const defaultDocument = documents.find(
          (item) => item.id === current.id && item.locale === "en",
        );
        if (defaultDocument)
          headElement("link", 'link[rel="alternate"][hreflang="x-default"]', {
            rel: "alternate",
            hreflang: "x-default",
            href: defaultDocument.url,
          });
      })
      .catch(() => {
        /* Keep the rendered metadata; the next navigation can retry loading it. */
      });
    return () => {
      active = false;
    };
  }, [inBrowser, path, locale]);
  useEffect(() => {
    if (!inBrowser) return;
    const mq = matchMedia("(prefers-reduced-motion: reduce)");
    function update() {
      setReduceMotion(mq.matches);
      if (mq.matches) setOpening(false);
    }
    mq.addEventListener("change", update);
    return () => mq.removeEventListener("change", update);
  }, [inBrowser]);
  useEffect(() => {
    if (!inBrowser) return;
    const alias = path === "/in" || path === "/ig" ? path.slice(1) : undefined;
    captureAttribution(alias);
    if (alias) navigate("/", { replace: true });
    return installInteractions({
      contactLinks,
      certificatesUrl: assetUrl("assets/certificates/catalog.json"),
    });
  }, [inBrowser]);
  useEffect(() => {
    if (inBrowser && !opening) portfolioViewed(locale, theme);
  }, [inBrowser, opening, locale, theme]);
  useEffect(() => {
    if (!inBrowser || !isHome(path)) return;
    let frame;
    function measure() {
      frame = undefined;
      const extent = document.documentElement.scrollHeight - window.innerHeight;
      if (extent <= 0) return;
      const percent = Math.round((window.scrollY / extent) * 100);
      for (const threshold of [25, 50, 75, 90])
        if (percent >= threshold) scrollDepth(threshold);
    }
    function onScroll() {
      if (frame === undefined) frame = requestAnimationFrame(measure);
    }
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => {
      window.removeEventListener("scroll", onScroll);
      if (frame !== undefined) cancelAnimationFrame(frame);
    };
  }, [inBrowser, path]);
  useEffect(() => {
    if (!inBrowser) return;
    if (!opening && isHome(path) && location.hash) {
      const id = decodeURIComponent(location.hash.slice(1));
      requestAnimationFrame(() =>
        document
          .getElementById(id)
          ?.scrollIntoView({ behavior: "instant", block: "start" }),
      );
    }
  }, [inBrowser, opening, path]);
  const doneOpening = useCallback(() => setOpening(false), []);
  const home = isHome(path);
  let page;
  if (path === "/apps") page = <AppsPage />;
  else if (path === "/experiencias") page = <ExperiencesPage />;
  else if (path.startsWith("/apps/"))
    page = <AppDetailPage id={path.split("/").pop()} />;
  else if (path === "/certificacoes") page = <CertificatesPage />;
  else if (
    path === "/artigos/identidade-visual" ||
    path === "/ios/artigos/identidade-visual"
  )
    page = <ArticlePage />;
  else if (!home) page = <ErrorPage />;
  const back = () => {
    if (history.state?.portfolio) history.back();
    else navigate("/");
  };
  return (
    <PortfolioContext
      value={{
        locale,
        t,
        theme,
        setLocale,
        setTheme,
        navigate,
        reduceMotion,
        initialCertificates,
        staticRender,
      }}
    >
      <ErrorBoundary>
        <a className="skip-link" href="#main">
          {locale === "pt" ? "Ir para o conteúdo" : "Skip to content"}
        </a>
        <Header home={home} onBack={back} visible={!opening} />
        <main id="main" aria-hidden={opening || undefined} inert={opening}>
          {(!staticRender || home) && (
            <div hidden={!home}>
              <Home active={home && !opening} />
            </div>
          )}
          {!home && (
            <div key={path} className="route-page">
              {page}
            </div>
          )}
        </main>
        {home && !opening && <FabMenu />}
        {opening && <Opening onDone={doneOpening} />}
      </ErrorBoundary>
    </PortfolioContext>
  );
}
