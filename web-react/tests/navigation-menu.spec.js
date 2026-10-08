import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: "reduce", colorScheme: "dark" });
});

test("navigation exposes certifications and articles, including short mobile screens", async ({
  page,
}) => {
  await page.goto("/pt/");
  await page.setViewportSize({ width: 1440, height: 900 });
  const header = page.getByRole("navigation", {
    name: "Navegação principal",
  });
  await expect(header).toBeVisible();
  await header.getByRole("link", { name: "Certificações" }).click();
  await expect(page.locator("#certificacoes")).toBeInViewport();
  await page.setViewportSize({ width: 320, height: 568 });
  await expect(header).toBeHidden();
  const toggle = page.locator(".fab-toggle");
  const before = await page.evaluate(() => scrollY);
  await toggle.click();
  await expect(page.locator(".fab-item")).toHaveCount(8);
  expect(await page.evaluate(() => scrollY)).toBe(before);
  const items = page.locator(".fab-items");
  const bounds = await items.boundingBox();
  expect(bounds.y).toBeGreaterThanOrEqual(72);
  expect(bounds.y + bounds.height).toBeLessThanOrEqual(568 - 72);
  await toggle.press("ArrowDown");
  await expect(
    page.getByRole("button", { name: "Início", exact: true }),
  ).toBeFocused();
  for (let index = 0; index < 6; index++)
    await page.keyboard.press("ArrowDown");
  const articles = page.getByRole("button", { name: "Artigos", exact: true });
  await expect(articles).toBeFocused();
  const articleBounds = await articles.boundingBox();
  expect(articleBounds.y).toBeGreaterThanOrEqual(bounds.y);
  expect(articleBounds.y + articleBounds.height).toBeLessThanOrEqual(
    bounds.y + bounds.height,
  );
  expect(await page.evaluate(() => scrollY)).toBe(before);
  await articles.press("Enter");
  await expect(page.locator("#artigos")).toBeInViewport();
  await expect(toggle).toHaveAttribute("aria-expanded", "false");
});
