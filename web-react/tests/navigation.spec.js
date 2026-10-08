import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: "reduce", colorScheme: "dark" });
  await page.addInitScript(() => {
    localStorage.setItem("portfolio_theme", "dark");
    window.pageTransitions = [];
    const animate = Element.prototype.animate;
    Element.prototype.animate = function (frames, options) {
      const animation = animate.call(this, frames, options);
      if (this.classList.contains("navigation-content")) {
        animation.pause();
        animation.currentTime = 0;
        window.pageTransition = animation;
        window.pageTransitions.push({
          frames,
          scroll: scrollY,
          path: location.pathname,
          hash: location.hash,
          regions: Object.fromEntries(
            [...this.querySelectorAll("[data-route-scroll]")].map((element) => [
              element.dataset.routeScroll,
              { top: element.scrollTop, left: element.scrollLeft },
            ]),
          ),
          focusedHeading: /^H[12]$/.test(document.activeElement?.tagName),
        });
      }
      return animation;
    };
  });
});

async function enableMotion(page) {
  await page.emulateMedia({ reducedMotion: "no-preference" });
  await page.evaluate(() => new Promise(requestAnimationFrame));
}

async function finishMotion(page) {
  await page.evaluate(() => window.pageTransition?.finish());
}

async function expectLateralMotion(
  page,
  direction,
  expectedScroll,
  regions = {},
) {
  const transition = await page.evaluate(() => window.pageTransitions.at(-1));
  expect(transition.focusedHeading).toBe(true);
  expect(transition.frames).toEqual([
    { transform: `translateX(${direction === "back" ? "-" : ""}6%)` },
    { transform: "translateX(0)" },
  ]);
  expect(Math.abs(transition.scroll - expectedScroll)).toBeLessThan(2);
  expect(transition.regions).toMatchObject(regions);
  const positions = await page.evaluate(async () => {
    const result = [];
    for (const time of [0, 130, 259]) {
      window.pageTransition.currentTime = time;
      await new Promise(requestAnimationFrame);
      const transform = new DOMMatrixReadOnly(
        getComputedStyle(document.querySelector(".navigation-content"))
          .transform,
      );
      result.push({ scroll: scrollY, x: transform.m41, y: transform.m42 });
    }
    return result;
  });
  for (const position of positions) {
    expect(Math.abs(position.scroll - expectedScroll)).toBeLessThan(2);
    expect(position.y).toBe(0);
  }
  expect(direction === "back" ? positions[0].x < 0 : positions[0].x > 0).toBe(
    true,
  );
  expect(Math.abs(positions[2].x)).toBeLessThan(Math.abs(positions[0].x));
  expect(
    await page.evaluate(
      () => document.documentElement.scrollWidth <= innerWidth,
    ),
  ).toBe(true);
}

test("new cases start at the top; back and forward restore scroll before lateral motion", async ({
  page,
}) => {
  await page.goto("/pt/");
  await page.locator(".app-store-tile").first().scrollIntoViewIfNeeded();
  const homeScroll = await page.evaluate(() => scrollY);
  expect(homeScroll).toBeGreaterThan(400);
  await enableMotion(page);
  await page.locator(".app-store-tile").first().click();
  await expect(page).toHaveURL(/\/pt\/apps\/van-cranenbroek$/);
  await expectLateralMotion(page, "forward", 0);
  await finishMotion(page);
  await page.evaluate(() => window.scrollTo({ top: 620, behavior: "instant" }));
  const caseScroll = await page.evaluate(() => scrollY);
  expect(caseScroll).toBeGreaterThan(400);
  await page.getByRole("button", { name: "Voltar", exact: true }).click();
  await expect(page).toHaveURL(/\/pt\/$/);
  await expectLateralMotion(page, "back", homeScroll);
  await finishMotion(page);
  await page.goForward();
  await expect(page).toHaveURL(/\/pt\/apps\/van-cranenbroek$/);
  await expectLateralMotion(page, "forward", caseScroll);
});

test("anchor destinations and repeated history entries retain their own positions", async ({
  page,
}) => {
  await page.goto("/pt/");
  await enableMotion(page);
  await page.locator('.experience-preview[href$="#iberdrola"]').click();
  await expect(page).toHaveURL(/\/pt\/experiencias#iberdrola$/);
  const iberdrolaScroll = await page.evaluate(() => scrollY);
  expect(iberdrolaScroll).toBeGreaterThan(500);
  await expectLateralMotion(page, "forward", iberdrolaScroll);
  const anchorTop = await page.locator("#iberdrola").evaluate((element) => {
    return {
      top: element.getBoundingClientRect().top,
      expected:
        parseFloat(
          getComputedStyle(document.documentElement).scrollPaddingTop,
        ) + parseFloat(getComputedStyle(element).scrollMarginTop),
    };
  });
  expect(Math.abs(anchorTop.top - anchorTop.expected)).toBeLessThan(2);
  await finishMotion(page);
  // Two entries share the same route but must keep distinct scroll positions.
  await page.evaluate(() => {
    const link = document.createElement("a");
    link.href = "/pt/experiencias#lyzer";
    document.body.append(link);
    link.click();
    link.remove();
  });
  await expect(page).toHaveURL(/\/pt\/experiencias#lyzer$/);
  const lyzerScroll = await page.evaluate(() => scrollY);
  expect(Math.abs(lyzerScroll - iberdrolaScroll)).toBeGreaterThan(100);
  await expectLateralMotion(page, "forward", lyzerScroll);
  await finishMotion(page);
  await page.goBack();
  await expect(page).toHaveURL(/\/pt\/experiencias#iberdrola$/);
  await expectLateralMotion(page, "back", iberdrolaScroll);
  await finishMotion(page);
  await page.goForward();
  await expect(page).toHaveURL(/\/pt\/experiencias#lyzer$/);
  await expectLateralMotion(page, "forward", lyzerScroll);
});

test("direct anchors and reduced motion keep final scroll without page animation", async ({
  page,
}) => {
  await page.goto("/pt/experiencias#iberdrola");
  await expect(page.locator("#iberdrola")).toBeVisible();
  const anchoredScroll = await page.evaluate(() => scrollY);
  expect(anchoredScroll).toBeGreaterThan(500);
  await expect(page.locator("html")).toHaveAttribute("lang", "pt-BR");
  await page.locator(".language-toggle").click();
  await expect(page).toHaveURL(/\/experiencias#iberdrola$/);
  const englishScroll = await page.evaluate(() => scrollY);
  await page.getByRole("button", { name: "Back", exact: true }).click();
  await expect(page).toHaveURL(/^http:\/\/127\.0\.0\.1:\d+\/$/);
  expect(await page.evaluate(() => scrollY)).toBe(0);
  await page.goBack();
  await expect(page).toHaveURL(/\/experiencias#iberdrola$/);
  expect(
    Math.abs((await page.evaluate(() => scrollY)) - englishScroll),
  ).toBeLessThan(2);
  expect(await page.evaluate(() => window.pageTransitions)).toEqual([]);
});

test("returning to a loaded certificate register restores its reading position before animation", async ({
  page,
}) => {
  await page.goto("/pt/certificacoes");
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
  const results = page.locator(".certificate-results");
  await results.evaluate((element) =>
    element.scrollTo({ top: 600, behavior: "instant" }),
  );
  const certificateScroll = await results.evaluate(
    (element) => element.scrollTop,
  );
  expect(certificateScroll).toBeGreaterThan(200);
  await enableMotion(page);
  await page.getByRole("button", { name: "Voltar", exact: true }).click();
  await expect(page).toHaveURL(/\/pt\/$/);
  await expectLateralMotion(page, "back", 0);
  await finishMotion(page);
  await page.goBack();
  await expect(page).toHaveURL(/\/pt\/certificacoes$/);
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
  expect(
    await results.evaluate((element) => getComputedStyle(element).transform),
  ).toBe("none");
  await expectLateralMotion(page, "back", 0, {
    certificates: { top: certificateScroll, left: 0 },
  });
  expect(await results.evaluate((element) => element.scrollTop)).toBe(
    certificateScroll,
  );
});
