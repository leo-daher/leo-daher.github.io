import { test, expect } from "@playwright/test";
import { createServer } from "vite";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

let server, origin;
test.beforeAll(async () => {
  process.env.VITE_GA_MEASUREMENT_ID = "G-TEST123";
  process.env.VITE_SENTRY_DSN = "https://publickey@telemetry.invalid/1";
  process.env.VITE_TELEMETRY_ENVIRONMENT = "telemetry-test";
  process.env.VITE_PORTFOLIO_RELEASE = "telemetry-test";
  process.env.VITE_BASE_PATH = "/";
  server = await createServer({
    root: fileURLToPath(new URL("..", import.meta.url)),
    server: { host: "127.0.0.1", port: 0 },
    logLevel: "error",
  });
  await server.listen();
  origin = `http://127.0.0.1:${server.httpServer.address().port}`;
});
test.afterAll(async () => {
  await server?.close();
});
test.beforeEach(async ({ page, context }) => {
  await page.emulateMedia({ reducedMotion: "reduce" });
  await page.addInitScript(() => {
    localStorage.setItem("portfolio_locale", "pt");
    localStorage.setItem("portfolio_theme", "dark");
    window.__gaCalls = [];
    window.gtag = (...args) => window.__gaCalls.push(args);
  });
  // No test request can reach Analytics, Sentry or an outbound destination.
  await context.route("**/*", async (route) => {
    const url = new URL(route.request().url());
    if (url.origin === origin) return route.continue();
    if (url.hostname === "www.googletagmanager.com")
      return route.fulfill({
        status: 200,
        contentType: "application/javascript",
        body: "",
      });
    if (url.hostname === "telemetry.invalid")
      return route.fulfill({
        status: 200,
        contentType: "application/json",
        body: "{}",
        headers: { "access-control-allow-origin": "*" },
      });
    return route.abort();
  });
});
async function events(page, name) {
  return page.evaluate(
    (eventName) =>
      window.__gaCalls
        .filter((item) => item[0] === "event" && item[1] === eventName)
        .map((item) => item[2]),
    name,
  );
}

test("SSR and unconfigured telemetry perform no service initialization", async ({
  page,
}) => {
  const modulePath = fileURLToPath(
    new URL("../src/telemetry.js", import.meta.url),
  );
  const result = execFileSync(
    process.execPath,
    [
      "--input-type=module",
      "-e",
      `
    const {createPortfolioTelemetry} = await import(${JSON.stringify(modulePath)});
    const telemetry = createPortfolioTelemetry({gaMeasurementId:'G-TEST123',sentryDsn:'https://publickey@telemetry.invalid/1'}, {loadSentry:()=>{throw Error('SSR loaded SDK')}});
    await telemetry.initialize();
    telemetry.captureAttribution(); telemetry.portfolioViewed('pt','dark');
    console.log('SSR safe');
  `,
    ],
    { encoding: "utf8" },
  );
  expect(result.trim()).toBe("SSR safe");
  await page.goto(origin + "/pt/");
  const disabled = await page.evaluate(async (url) => {
    const { createPortfolioTelemetry } = await import(
      url + "/src/telemetry.js"
    );
    let loaded = 0;
    const count = document.scripts.length,
      calls = window.__gaCalls.length;
    const telemetry = createPortfolioTelemetry(
      {},
      {
        loadSentry: () => {
          loaded++;
        },
      },
    );
    await telemetry.initialize();
    telemetry.portfolioViewed("pt", "dark");
    telemetry.event("contact_intent", { contact_method: "whatsapp" });
    return {
      loaded,
      addedScripts: document.scripts.length - count,
      addedCalls: window.__gaCalls.length - calls,
    };
  }, origin);
  expect(disabled).toEqual({ loaded: 0, addedScripts: 0, addedCalls: 0 });
});

test("StrictMode captures ref once, persists legacy keys and sends bounded campaign labels", async ({
  page,
}) => {
  await page.goto(
    origin +
      "/pt/?ref=cv%20safe&utm_source=resume&utm_campaign=alice%40example.com&email=private%40example.com#apps",
  );
  await expect
    .poll(async () => (await events(page, "portfolio_view")).length)
    .toBe(1);
  await expect(page).toHaveURL(/utm_source=resume.*#apps$/);
  expect(new URL(page.url()).searchParams.has("ref")).toBe(false);
  expect(
    await page.evaluate(() => ({
      attribution: JSON.parse(sessionStorage.getItem("portfolio_attribution")),
      sessionRef: sessionStorage.getItem("portfolio_attribution_ref"),
      persistentRef: localStorage.getItem("portfolio_attribution_ref"),
    })),
  ).toEqual({
    attribution: { utm_source: "resume", ref: "cv-safe" },
    sessionRef: "cv-safe",
    persistentRef: "cv-safe",
  });
  const attribution = await events(page, "portfolio_attribution");
  expect(attribution).toHaveLength(1);
  expect(attribution[0]).toMatchObject({
    attribution_source: "resume",
    attribution_ref: "cv-safe",
    page_location: "",
    page_referrer: "",
  });
  expect(await events(page, "page_view")).toHaveLength(1);
  const configuration = await page.evaluate(() =>
    window.__gaCalls.filter((item) => item[0] === "config"),
  );
  expect(configuration).toHaveLength(1);
  expect(configuration[0][2]).toMatchObject({
    allow_google_signals: false,
    allow_ad_personalization_signals: false,
    send_page_view: false,
    campaign_name: "",
    page_location: "",
    page_referrer: "",
  });
  expect(
    JSON.stringify(await page.evaluate(() => window.__gaCalls)),
  ).not.toMatch(/alice|private@|email=/);
  await page.goto(origin + "/in?ref=legacy");
  await expect(page).toHaveURL(origin + "/");
  expect(
    await page.evaluate(() =>
      localStorage.getItem("portfolio_attribution_ref"),
    ),
  ).toBe("in");
  expect(await events(page, "portfolio_attribution")).toHaveLength(1);
});

test("preferences, menu, scroll, contacts, store links and certificate actions retain their event semantics", async ({
  page,
}) => {
  await page.goto(origin + "/pt/");
  await expect(page.locator(".certificate-highlight")).toHaveCount(3);
  await page.locator(".language-toggle").click();
  await page.locator(".theme-toggle").click();
  expect(await events(page, "change_preference")).toEqual([
    expect.objectContaining({ preference: "language", value: "en" }),
    expect.objectContaining({ preference: "theme", value: "light" }),
  ]);
  await page.locator(".fab-toggle").click();
  await page.locator(".fab-item").filter({ hasText: "Apps" }).click();
  expect(await events(page, "section_view")).toContainEqual(
    expect.objectContaining({ section_name: "apps", navigation_type: "menu" }),
  );
  await page.evaluate(() =>
    window.scrollTo(0, document.documentElement.scrollHeight),
  );
  await expect
    .poll(async () => (await events(page, "scroll_depth")).length)
    .toBe(4);
  await page.evaluate(() => window.dispatchEvent(new Event("scroll")));
  expect(
    (await events(page, "scroll_depth")).map((item) => item.scroll_percent),
  ).toEqual([25, 50, 75, 90]);
  await page
    .locator('.contact-card[href*="wa.me"]')
    .evaluate((link) => link.click());
  await page
    .locator('.contact-card[href*="calendly"]')
    .evaluate((link) => link.click());
  await page
    .locator('.contact-card[href*="linkedin"]')
    .evaluate((link) => link.click());
  expect(
    (await events(page, "contact_intent")).map((item) => item.contact_method),
  ).toEqual(["whatsapp", "calendly", "linkedin"]);
  expect(
    (await events(page, "generate_lead")).map((item) => item.contact_method),
  ).toEqual(["whatsapp", "calendly"]);
  await page.locator(".certificate-view-all").click();
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
  await page.locator(".certificate-gallery-card").first().click();
  await page.locator(".certificate-verify").evaluate((link) => link.click());
  const certificate = await events(page, "certificate_action");
  expect(certificate.map((item) => item.action)).toEqual([
    "open_register",
    "open_preview",
    "verify",
  ]);
  expect(certificate[1].certificate_id).toBeTruthy();
  expect(certificate[2].certificate_id).toBe(certificate[1].certificate_id);
  expect(await events(page, "select_outbound_link")).toContainEqual(
    expect.objectContaining({
      destination: "certificate_verification",
      link_type: "certificate",
      link_domain: expect.any(String),
    }),
  );
  await page.goto(origin + "/apps/van-cranenbroek");
  await page
    .locator('a[href*="play.google.com"]')
    .evaluate((link) => link.click());
  expect(await events(page, "select_outbound_link")).toContainEqual(
    expect.objectContaining({
      destination: "van-cranenbroek_googlePlay",
      link_type: "app_store",
      link_domain: "play.google.com",
    }),
  );
});

test("Sentry policy retains only approved interaction logs and scrubs error payloads", async ({
  page,
}) => {
  const envelopes = [];
  page.on("request", (request) => {
    if (request.url().includes("telemetry.invalid"))
      envelopes.push(request.postData() ?? "");
  });
  await page.goto(origin + "/?ref=cv-test&email=private%40example.com");
  await expect
    .poll(async () => (await events(page, "portfolio_view")).length)
    .toBe(1);
  const policy = await page.evaluate(async (url) => {
    const { createPortfolioTelemetry, captureError, flushTelemetry } =
      await import(url + "/src/telemetry.js");
    const logs = [],
      breadcrumbs = [];
    let options;
    const fake = {
      init: (configuration) => {
        options = configuration;
      },
      addBreadcrumb: (value) => breadcrumbs.push(value),
      logger: { info: (name, data) => logs.push({ name, data }) },
    };
    const transport = createPortfolioTelemetry(
      { sentryDsn: "https://publickey@telemetry.invalid/1" },
      { loadSentry: async () => fake },
    );
    await transport.initialize();
    for (const name of [
      "portfolio_view",
      "portfolio_attribution",
      "select_outbound_link",
      "contact_intent",
      "generate_lead",
      "certificate_action",
      "change_preference",
      "section_view",
      "scroll_depth",
    ])
      transport.event(name, {
        locale: "pt",
        theme: "dark",
        email: "private@example.com",
        url: location.href,
        scroll_percent: 25,
      });
    const sanitized = options.beforeSend({
      user: { email: "private@example.com", name: "Visitor Name" },
      request: { url: location.href },
      extra: { email: "private@example.com" },
      exception: {
        values: [
          {
            type: "Error",
            value: "private@example.com",
            stacktrace: {
              frames: [
                {
                  filename: "https://test.invalid/app.js?token=secret",
                  vars: { email: "private@example.com" },
                },
              ],
            },
          },
        ],
      },
      breadcrumbs: [{ category: "ui.click", message: "Visitor Name" }],
    });
    captureError(
      new Error("private@example.com https://test.invalid/?token=secret"),
    );
    await flushTelemetry();
    return {
      logNames: logs.map((item) => item.name),
      breadcrumbs: breadcrumbs.length,
      pii: options.sendDefaultPii,
      sample: options.tracesSampleRate,
      droppedLog: options.beforeSendLog({
        message: "console",
        attributes: { email: "private@example.com" },
      }),
      sanitized,
    };
  }, origin);
  expect(policy.logNames).toEqual([
    "portfolio_view",
    "portfolio_attribution",
    "select_outbound_link",
    "contact_intent",
    "generate_lead",
    "certificate_action",
  ]);
  expect(policy.breadcrumbs).toBe(9);
  expect(policy.pii).toBe(false);
  expect(policy.sample).toBe(0.15);
  expect(policy.droppedLog).toBeNull();
  expect(JSON.stringify(policy.sanitized)).not.toMatch(
    /private|Visitor|https:|token|secret/,
  );
  await expect
    .poll(() => envelopes.join("\n"))
    .toContain("Portfolio runtime error");
  const logItems = envelopes.flatMap((envelope) =>
    envelope.split("\n").flatMap((line) => {
      try {
        return JSON.parse(line).items ?? [];
      } catch {
        return [];
      }
    }),
  );
  const view = logItems.find((item) => item.body === "portfolio_view");
  const attribution = logItems.find(
    (item) => item.body === "portfolio_attribution",
  );
  expect(view.attributes.locale).toMatchObject({ type: "string", value: "en" });
  expect(view.attributes.theme).toMatchObject({
    type: "string",
    value: "dark",
  });
  expect(attribution.attributes.attribution_ref).toMatchObject({
    type: "string",
    value: "cv-test",
  });
  expect(
    logItems.some((item) =>
      ["change_preference", "section_view", "scroll_depth"].includes(item.body),
    ),
  ).toBe(false);
  expect(envelopes.join("\n")).not.toMatch(
    /private@example|email=|token=secret/,
  );
});
