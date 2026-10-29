import { test, expect } from "@playwright/test";
import initial from "../src/data/recomp-metrics.snapshot.json" with { type: "json" };
import { RECOMP_METRICS_ENDPOINT } from "../src/data/recomp-metrics.js";

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: "reduce", colorScheme: "dark" });
  await page.route(RECOMP_METRICS_ENDPOINT, (route) =>
    route.fulfill({ json: initial }),
  );
});

test("compact project reference follows featured apps and keeps traffic labels accurate", async ({
  page,
}) => {
  await page.goto("/pt/");
  const section = page.locator("#recomp-center");
  await section.scrollIntoViewIfNeeded();
  await expect(
    section.getByRole("heading", { name: "Recomp Center" }),
  ).toBeVisible();
  await expect(section.locator(".recomp-metric-value")).toContainText(
    /2,46\s*mil/,
  );
  await expect(section.locator(".recomp-secondary-metric")).toContainText(
    /44,33\s*mil.*requisições/,
  );
  await expect(
    section.getByRole("link", { name: "Explorar catálogo" }),
  ).toHaveAttribute("href", "https://recomp.center/");
  await expect(section.locator(".recomp-metrics-source")).toContainText(
    /28.*2026/,
  );
  const order = await page.locator(".home-apps + #recomp-center").count();
  expect(order).toBe(1);
  await section.locator("summary").click();
  await expect(section.locator("details")).toContainText(
    "incluindo tráfego automatizado",
  );
  await expect(section.locator("details")).toContainText(
    "não representam usuários únicos",
  );
  expect(
    await page.evaluate(
      () => document.documentElement.scrollWidth <= innerWidth,
    ),
  ).toBe(true);
});

test("automatic totals update the period and remain intact when the next request fails", async ({
  page,
}) => {
  let calls = 0;
  await page.unroute(RECOMP_METRICS_ENDPOINT);
  await page.route(RECOMP_METRICS_ENDPOINT, (route) => {
    calls++;
    const asOf = new Date().toISOString();
    return calls === 1
      ? route.fulfill({
          json: {
            ...initial,
            collection: "automatic",
            asOf,
            period: {
              kind: "cumulative",
              start: "2026-10-01",
              end: asOf,
            },
            metrics: { visits: 3000, requests: 60000 },
          },
        })
      : route.fulfill({ status: 503, body: "unavailable" });
  });
  await page.goto("/pt/");
  const section = page.locator("#recomp-center");
  await section.scrollIntoViewIfNeeded();
  await expect(section.locator(".recomp-metric-value")).toContainText(
    /3\s*mil/,
  );
  await expect(section.locator(".recomp-metrics-source")).toContainText(
    "Desde",
  );
  await page.evaluate(() =>
    document.dispatchEvent(new Event("visibilitychange")),
  );
  await expect.poll(() => calls).toBe(2);
  await expect(section.locator(".recomp-metric-value")).toContainText(
    /3\s*mil/,
  );
});

test("English and malformed source responses retain the dated verified snapshot", async ({
  page,
}) => {
  await page.unroute(RECOMP_METRICS_ENDPOINT);
  await page.route(RECOMP_METRICS_ENDPOINT, (route) =>
    route.fulfill({ json: { metrics: { users: 999999 } } }),
  );
  await page.goto("/");
  const section = page.locator("#recomp-center");
  await section.scrollIntoViewIfNeeded();
  await expect(section.locator(".recomp-metric-value")).toContainText("2.46K");
  await expect(section.locator(".recomp-metric-label")).toHaveText("visits");
  await expect(
    section.getByRole("link", { name: "Explore catalog" }),
  ).toBeVisible();
  await expect(section.locator(".recomp-metrics-source")).toContainText(
    "Checked on",
  );
  await section.locator("summary").click();
  await expect(section.locator("details")).toContainText(
    "do not represent unique users",
  );
});
