import { test, expect } from "@playwright/test";
import AxeBuilder from "@axe-core/playwright";

test("signature gallery keeps local logos, accessible links and narrow layouts", async ({
  page,
}, testInfo) => {
  const external = [];
  page.on("request", (request) => {
    if (!new URL(request.url()).hostname.match(/^(127\.0\.0\.1|localhost)$/))
      external.push(request.url());
  });
  await page.goto("/design-system/");
  await expect(page.getByRole("heading", { level: 1 })).toHaveText(
    "Uma assinatura.Em todo produto.",
  );
  await expect(page.locator(".ld-signature")).toHaveCount(4);
  await expect(
    page.locator('.ld-signature[data-theme="light"] .ld-mark--light').first(),
  ).toBeVisible();
  await expect(
    page.locator('.ld-signature[data-theme="dark"] .ld-mark--dark').first(),
  ).toBeVisible();
  expect(
    await page
      .locator(".ld-signature")
      .evaluateAll((links) =>
        links.every(
          (link) =>
            link.clientHeight >= 44 &&
            link.hasAttribute("aria-label") &&
            link.rel.includes("noopener"),
        ),
      ),
  ).toBe(true);
  expect(
    await page.evaluate(
      () => document.documentElement.scrollWidth <= window.innerWidth,
    ),
  ).toBe(true);
  expect((await new AxeBuilder({ page }).analyze()).violations).toEqual([]);
  expect(external).toEqual([]);
  await page.screenshot({
    path: testInfo.outputPath("signature.png"),
    fullPage: true,
  });
});
