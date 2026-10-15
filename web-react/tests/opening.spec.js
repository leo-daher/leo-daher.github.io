import { test, expect } from "@playwright/test";

for (const viewport of [
  { width: 2560, height: 1440 },
  { width: 3840, height: 2160 },
  { width: 5120, height: 1440 },
]) {
  test(`opening stays bounded and reaches the menu at ${viewport.width} × ${viewport.height}`, async ({
    browser,
  }, testInfo) => {
    test.skip(testInfo.project.name !== "desktop", "Large monitor coverage");
    const context = await browser.newContext({
      viewport,
      deviceScaleFactor: 2,
      reducedMotion: "no-preference",
      colorScheme: "dark",
    });
    try {
      const page = await context.newPage();
      const errors = [];
      page.on("pageerror", (error) => errors.push(error.message));
      await page.clock.install({ time: 0 });
      await page.clock.pauseAt(1_000_000);
      await page.goto("/", { waitUntil: "domcontentloaded" });
      await expect(page.locator(".opening")).toBeVisible();
      await expect(page.locator("main")).toHaveAttribute("inert", "");

      let previous = 0;
      for (const time of [100, 700, 1000, 1150, 1380, 1500]) {
        await page.clock.runFor(time - previous);
        previous = time;
        const geometry = await page.locator(".opening svg").evaluate((svg) => {
          const masked = svg.querySelector("g[mask]").getBBox();
          return {
            width: svg.width.baseVal.value,
            height: svg.height.baseVal.value,
            maskedArea: masked.width * masked.height,
          };
        });
        // The tiny optical cut must not allocate a monitor-sized SVG surface.
        expect(geometry.maskedArea).toBeLessThan(256 * 256);
        if (time === 700) {
          expect(geometry.width).toBeCloseTo(204, 1);
          expect(geometry.height).toBeCloseTo(204, 1);
        }
        if (time === 1380) {
          expect(geometry.width).toBeCloseTo(viewport.width, 1);
          expect(geometry.height).toBeCloseTo(viewport.height, 1);
          const dot = await page.locator(".opening-dot").boundingBox();
          expect(dot.x).toBeCloseTo(viewport.width - 72, 1);
          expect(dot.y).toBeCloseTo(viewport.height - 72, 1);
          expect(dot.width).toBeCloseTo(56, 1);
          expect(dot.height).toBeCloseTo(56, 1);
        }
      }

      await page.clock.runFor(200);
      await expect(page.locator(".opening")).toHaveCount(0);
      await expect(page.locator(".fab-toggle")).toBeVisible();
      await expect(page.locator("main")).not.toHaveAttribute("inert");
      expect(
        await page.evaluate(
          () => document.documentElement.scrollWidth <= innerWidth,
        ),
      ).toBe(true);
      expect(errors).toEqual([]);
    } finally {
      await context.close();
    }
  });
}
