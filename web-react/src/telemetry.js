import { APP_CASES } from "./data/apps.js";

const ATTRIBUTION_KEYS = {
  utm_source: "attribution_source",
  utm_medium: "attribution_medium",
  utm_campaign: "attribution_campaign",
  utm_content: "attribution_content",
  utm_term: "attribution_term",
  ref: "attribution_ref",
};
const EVENT_FIELDS = {
  portfolio_view: ["locale", "theme"],
  portfolio_attribution: Object.values(ATTRIBUTION_KEYS),
  change_preference: ["preference", "value"],
  section_view: ["section_name", "navigation_type"],
  scroll_depth: ["scroll_percent"],
  select_outbound_link: ["destination", "link_type", "link_domain"],
  contact_intent: ["contact_method", "link_domain"],
  generate_lead: ["contact_method", "link_domain"],
  certificate_action: ["action", "certificate_id"],
};
const SENTRY_LOG_EVENTS = new Set([
  "portfolio_view",
  "portfolio_attribution",
  "select_outbound_link",
  "contact_intent",
  "generate_lead",
  "certificate_action",
]);
const SECTIONS = new Set([
  "home",
  "apps",
  "system",
  "clients",
  "articles",
  "contact",
  "certificacoes",
]);
const storeProofs = Object.values(APP_CASES).flatMap((item) => item.stores);
const env = import.meta.env ?? {};

// Attribution consists of campaign labels, never free-form visitor information.
export function sanitizeLabel(value) {
  if (typeof value !== "string") return "";
  const trimmed = value.trim();
  if (/@|:\/\/|[?=&]|\b(?:mailto|tel):/i.test(trimmed)) return "";
  return trimmed.replace(/[^A-Za-z0-9._-]/g, "-").slice(0, 80);
}
export function shouldSendSentryLog(name) {
  return SENTRY_LOG_EVENTS.has(name);
}
export function sanitizeEvent(name, parameters = {}) {
  return Object.fromEntries(
    (EVENT_FIELDS[name] ?? []).flatMap((key) => {
      const value = parameters[key];
      if (typeof value === "number")
        return Number.isFinite(value) &&
          key === "scroll_percent" &&
          [25, 50, 75, 90].includes(value)
          ? [[key, value]]
          : [];
      const clean = sanitizeLabel(value);
      return clean ? [[key, clean]] : [];
    }),
  );
}
function validDsn(value) {
  try {
    const url = new URL(value);
    return (
      url.protocol === "https:" &&
      !!url.hostname &&
      !!url.username &&
      /^\/\d+$/.test(url.pathname) &&
      !url.search &&
      !url.hash
    );
  } catch {
    return false;
  }
}
function safeRoute(pathname, base = "/") {
  let path = pathname;
  if (base !== "/" && path.startsWith(base))
    path = "/" + path.slice(base.length);
  path = path.replace(/\/$/, "") || "/";
  const localePrefix = /^\/(?:pt|en)(?:\/|$)/.test(path)
    ? path.slice(0, 3)
    : "";
  const logical = localePrefix ? path.slice(3) || "/" : path;
  const known = [
    "/",
    "/ios",
    "/in",
    "/ig",
    "/apps",
    "/certificacoes",
    "/artigos/identidade-visual",
    "/ios/artigos/identidade-visual",
    ...Object.keys(APP_CASES).map((id) => "/apps/" + id),
    "/apps/lyzer-collect",
    "/apps/lyzer-deliver",
  ];
  return known.includes(logical) ? localePrefix + logical : "/404";
}
function cleanErrorEvent(event) {
  delete event.user;
  delete event.request;
  delete event.extra;
  delete event.contexts;
  delete event.message;
  delete event.transaction;
  event.tags = { component: "portfolio" };
  if (event.exception?.values)
    event.exception.values = event.exception.values.map((exception) => ({
      type: sanitizeLabel(exception.type) || "Error",
      value: "Portfolio runtime error",
      ...(exception.stacktrace && {
        stacktrace: {
          frames: exception.stacktrace.frames?.map((frame) => ({
            ...frame,
            filename: sanitizeLabel(
              (frame.filename ?? "").split(/[?#]/, 1)[0].split("/").pop(),
            ),
            abs_path: undefined,
            vars: undefined,
            pre_context: undefined,
            context_line: undefined,
            post_context: undefined,
          })),
        },
      }),
    }));
  event.breadcrumbs = (event.breadcrumbs ?? [])
    .filter(
      (item) =>
        item.category === "portfolio.interaction" && EVENT_FIELDS[item.message],
    )
    .map((item) => ({ ...item, data: sanitizeEvent(item.message, item.data) }));
  return event;
}

// An instance is also useful for testing transports without contacting a service.
export function createPortfolioTelemetry(
  {
    gaMeasurementId = "",
    sentryDsn = "",
    environment = "production",
    release = "",
    basePath = "/",
  } = {},
  {
    browser = typeof window === "undefined" ? undefined : window,
    loadSentry = () => import("@sentry/react"),
  } = {},
) {
  const gaEnabled = !!browser && /^G-[A-Z0-9]+$/.test(gaMeasurementId);
  const sentryEnabled = !!browser && validDsn(sentryDsn);
  let sdk,
    ready,
    attributionCaptured = false,
    viewed = false,
    interactions;
  const depths = new Set();
  function readAttribution(refOverride) {
    const values = {};
    if (!browser) return values;
    const url = new URL(browser.location.href);
    for (const key of Object.keys(ATTRIBUTION_KEYS)) {
      const value = sanitizeLabel(
        key === "ref" && refOverride ? refOverride : url.searchParams.get(key),
      );
      if (value) values[key] = value;
    }
    return values;
  }
  function event(name, parameters = {}) {
    if (!EVENT_FIELDS[name]) return;
    const clean = sanitizeEvent(name, parameters);
    if (gaEnabled)
      browser.gtag?.("event", name, {
        ...clean,
        page_location: "",
        page_referrer: "",
        page_title: "Portfolio",
        page_path: safeRoute(browser.location.pathname, basePath),
      });
    if (sdk) {
      sdk.addBreadcrumb({
        category: "portfolio.interaction",
        message: name,
        level: "info",
        data: clean,
      });
      if (shouldSendSentryLog(name)) sdk.logger.info(name, clean);
    }
  }
  async function initialize() {
    if (ready) return ready;
    ready = (async () => {
      if (!browser) return;
      if (gaEnabled) {
        browser.dataLayer ||= [];
        browser.gtag ||= function () {
          browser.dataLayer.push(arguments);
        };
        const attribution = readAttribution();
        browser.gtag("js", new Date());
        browser.gtag("config", gaMeasurementId, {
          send_page_view: false,
          allow_google_signals: false,
          allow_ad_personalization_signals: false,
          page_location: "",
          page_referrer: "",
          page_title: "Portfolio",
          ignore_referrer: true,
          campaign_source: attribution.utm_source || "",
          campaign_medium: attribution.utm_medium || "",
          campaign_name: attribution.utm_campaign || "",
          campaign_content: attribution.utm_content || "",
          campaign_term: attribution.utm_term || "",
        });
        const script = browser.document.createElement("script");
        script.async = true;
        script.src =
          "https://www.googletagmanager.com/gtag/js?id=" + gaMeasurementId;
        browser.document.head.append(script);
      }
      if (sentryEnabled) {
        try {
          sdk = await loadSentry();
          sdk.init({
            dsn: sentryDsn,
            environment: sanitizeLabel(environment) || "production",
            release: sanitizeLabel(release) || undefined,
            sendDefaultPii: false,
            tracesSampleRate: 0.15,
            enableLogs: true,
            beforeSend: cleanErrorEvent,
            beforeSendTransaction: () => null,
            beforeBreadcrumb: (breadcrumb) =>
              breadcrumb.category === "portfolio.interaction" &&
              EVENT_FIELDS[breadcrumb.message]
                ? {
                    ...breadcrumb,
                    data: sanitizeEvent(breadcrumb.message, breadcrumb.data),
                  }
                : null,
            beforeSendLog: (log) =>
              shouldSendSentryLog(log.message)
                ? {
                    ...log,
                    attributes: sanitizeEvent(log.message, log.attributes),
                  }
                : null,
          });
        } catch {
          sdk = undefined;
          // A monitoring outage must not prevent the public interface from opening.
        }
      }
    })();
    return ready;
  }
  function captureAttribution(refOverride) {
    if (!browser || attributionCaptured) return;
    attributionCaptured = true;
    const attribution = readAttribution(refOverride);
    if (Object.keys(attribution).length) {
      try {
        browser.sessionStorage.setItem(
          "portfolio_attribution",
          JSON.stringify(attribution),
        );
      } catch {
        /* Storage is optional. */
      }
      if (attribution.ref) {
        for (const storage of ["sessionStorage", "localStorage"]) {
          try {
            browser[storage].setItem(
              "portfolio_attribution_ref",
              attribution.ref,
            );
          } catch {
            /* The attribution event still works without persistence. */
          }
        }
      }
      event(
        "portfolio_attribution",
        Object.fromEntries(
          Object.entries(attribution).map(([key, value]) => [
            ATTRIBUTION_KEYS[key],
            value,
          ]),
        ),
      );
    }
    const url = new URL(browser.location.href);
    if (url.searchParams.has("ref")) {
      url.searchParams.delete("ref");
      browser.history.replaceState(
        browser.history.state,
        "",
        url.pathname + url.search + url.hash,
      );
    }
  }
  function portfolioViewed(locale, theme) {
    if (viewed) return;
    viewed = true;
    event("portfolio_view", { locale, theme });
    if (gaEnabled)
      browser.gtag("event", "page_view", {
        page_location: "",
        page_referrer: "",
        page_title: "Portfolio",
        page_path: safeRoute(browser.location.pathname, basePath),
      });
  }
  function sectionSelected(section) {
    if (section === "artigos") section = "articles";
    if (SECTIONS.has(section))
      event("section_view", { section_name: section, navigation_type: "menu" });
  }
  function scrollDepth(percent) {
    if (![25, 50, 75, 90].includes(percent) || depths.has(percent)) return;
    depths.add(percent);
    event("scroll_depth", { scroll_percent: percent });
  }
  function outboundLink(destination, url, linkType = "external") {
    event("select_outbound_link", {
      destination,
      link_type: linkType,
      link_domain: url.hostname,
    });
  }
  function contactIntent(method, url, isLead = false) {
    outboundLink(method, url, "contact");
    const parameters = { contact_method: method, link_domain: url.hostname };
    event("contact_intent", parameters);
    if (isLead) event("generate_lead", parameters);
  }
  function certificateAction(action, certificateId) {
    event("certificate_action", { action, certificate_id: certificateId });
  }
  function installInteractions({ contactLinks = {}, certificatesUrl } = {}) {
    if (!browser || (!gaEnabled && !sentryEnabled)) return () => {};
    interactions?.();
    let certificates = [];
    if (certificatesUrl)
      browser
        .fetch(certificatesUrl)
        .then((response) => (response.ok ? response.json() : null))
        .then((catalog) => {
          certificates = catalog?.certificates ?? [];
        })
        .catch(() => {});
    function click(e) {
      if (e.button !== 0) return;
      const element = e.target?.closest?.("a, button");
      if (!element) return;
      if (element.matches(".certificate-card")) {
        const title = element.querySelector(
          ".certificate-card-title",
        )?.textContent;
        certificateAction(
          "open_preview",
          certificates.find((item) => item.title === title)?.id,
        );
      }
      if (element.matches(".certificate-view-all"))
        certificateAction("open_register");
      if (!element.matches("a[href]")) return;
      let url;
      try {
        url = new URL(element.href, browser.location.href);
      } catch {
        return;
      }
      if (element.matches(".certificate-verify")) {
        certificateAction(
          "verify",
          certificates.find((item) => item.verification_url === url.href)?.id,
        );
        outboundLink("certificate_verification", url, "certificate");
        return;
      }
      const contact = Object.entries(contactLinks).find(
        ([, href]) => href === url.href,
      );
      if (contact) {
        const method = contact[0] === "schedule" ? "calendly" : contact[0];
        contactIntent(
          method,
          url,
          method === "whatsapp" || method === "calendly",
        );
        return;
      }
      const proof = storeProofs.find((item) => item.href === url.href);
      if (proof) {
        outboundLink(
          `${proof.productId}_${proof.store === "Google Play" ? "googlePlay" : "appStore"}`,
          url,
          "app_store",
        );
        return;
      }
      if (
        ["http:", "https:"].includes(url.protocol) &&
        url.origin !== browser.location.origin
      )
        outboundLink("external", url);
    }
    browser.document.addEventListener("click", click, true);
    const cleanup = () => {
      browser.document.removeEventListener("click", click, true);
      if (interactions === cleanup) interactions = undefined;
    };
    interactions = cleanup;
    return cleanup;
  }
  function captureError(error) {
    sdk?.captureException(error, { tags: { component: "portfolio" } });
  }
  return {
    initialize,
    event,
    captureAttribution,
    portfolioViewed,
    sectionSelected,
    scrollDepth,
    outboundLink,
    contactIntent,
    certificateAction,
    installInteractions,
    captureError,
    flush: (timeout = 2000) => sdk?.flush(timeout) ?? Promise.resolve(true),
  };
}

const telemetry = createPortfolioTelemetry({
  gaMeasurementId: env.VITE_GA_MEASUREMENT_ID,
  sentryDsn: env.VITE_SENTRY_DSN,
  environment: env.VITE_TELEMETRY_ENVIRONMENT,
  release: env.VITE_PORTFOLIO_RELEASE,
  basePath: env.BASE_URL,
});
export const {
  initialize: initializeTelemetry,
  captureAttribution,
  portfolioViewed,
  sectionSelected,
  scrollDepth,
  installInteractions,
  captureError,
  flush: flushTelemetry,
} = telemetry;
export const preferenceChanged = (preference, value) =>
  telemetry.event("change_preference", { preference, value });
