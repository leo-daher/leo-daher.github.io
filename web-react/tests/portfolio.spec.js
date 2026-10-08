import { test, expect } from "@playwright/test";
import AxeBuilder from "@axe-core/playwright";
const apps = [
  "van-cranenbroek",
  "lyzer-collect",
  "lyzer-deliver",
  "mag-venda-digital",
];
test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: "reduce", colorScheme: "dark" });
  await page.addInitScript(() => {
    localStorage.setItem("portfolio_locale", "pt");
    localStorage.setItem("portfolio_theme", "dark");
  });
});
test("URL selects English at root and Portuguese under pt despite browser and stored preferences", async ({
  browser,
}) => {
  const context = await browser.newContext({
    locale: "pt-BR",
    reducedMotion: "reduce",
    colorScheme: "dark",
  });
  await context.addInitScript(() =>
    localStorage.setItem("portfolio_locale", "pt"),
  );
  const page = await context.newPage();
  await page.goto("http://127.0.0.1:4173/");
  await expect(page.locator("html")).toHaveAttribute("lang", "en");
  await expect(page.locator(".hero-role")).toHaveText("Software Engineer");
  await expect(page.locator(".app-store-tile").first()).toHaveAttribute(
    "href",
    "/apps/van-cranenbroek",
  );
  await page.goto("http://127.0.0.1:4173/pt/?preview=locale#apps");
  await expect(page.locator("html")).toHaveAttribute("lang", "pt-BR");
  await expect(page.locator(".hero-role")).toHaveText("Engenheiro de Software");
  const app = page.locator(".app-store-tile").first();
  await expect(app).toHaveAttribute("href", "/pt/apps/van-cranenbroek");
  const other = await context.newPage();
  await other.goto(await app.evaluate((anchor) => anchor.href));
  await expect(other.locator("html")).toHaveAttribute("lang", "pt-BR");
  await expect(other.locator(".app-detail-page")).toBeVisible();
  await other.close();
  await page.locator(".language-toggle").click();
  await expect(page).toHaveURL("http://127.0.0.1:4173/?preview=locale#apps");
  await expect(page.locator("html")).toHaveAttribute("lang", "en");
  await page.reload();
  await expect(page.locator("html")).toHaveAttribute("lang", "en");
  await page.locator(".language-toggle").click();
  await expect(page).toHaveURL("http://127.0.0.1:4173/pt/?preview=locale#apps");
  await expect(page.locator("html")).toHaveAttribute("lang", "pt-BR");
  await expect(page.locator('link[hreflang="x-default"]')).toHaveAttribute(
    "href",
    /https?:\/\/[^/]+\/$/,
  );
  await context.close();
});
test("home preserves original content, geometry and loaded public assets", async ({
  page,
}) => {
  const errors = [];
  page.on("pageerror", (e) => errors.push(e.message));
  await page.goto("/pt/");
  await expect(
    page.getByRole("heading", {
      name: "Leone Daher Engenheiro de Software",
      exact: true,
    }),
  ).toBeVisible();
  await expect(page.locator(".hero-role")).toHaveText("Engenheiro de Software");
  await expect(page.locator(".app-store-tile")).toHaveCount(3);
  await expect(page.locator(".app-store-tile--suite")).toContainText(
    "Lyzer Collect + Deliver",
  );
  await expect(page.locator(".app-store-tile--suite")).toContainText(
    "1,1 mil+ downloads",
  );
  await expect(page.locator(".experience-preview")).toHaveCount(4);
  await expect(page.locator(".certificate-highlight")).toHaveCount(3);
  await expect(page.locator(".client-tile")).toHaveCount(15);
  await expect(page.locator(".contact-card")).toHaveCount(4);
  const viewport = page.viewportSize();
  const bounds = await page.locator(".hero-frame").boundingBox();
  expect(bounds.x).toBe(24);
  expect(bounds.y).toBe(102);
  expect(bounds.height).toBe(viewport.width < 748 ? 620 : 880);
  expect(
    await page.evaluate(
      () => document.documentElement.scrollWidth <= innerWidth,
    ),
  ).toBe(true);
  expect(errors).toEqual([]);
  await expect(page.locator('img[alt=""]')).toHaveCount(0);
  for (const mark of await page.locator(".brand-mark,.app-icon-image").all()) {
    expect(
      await mark.evaluate(async (element) => {
        const url = getComputedStyle(element).backgroundImage.slice(5, -2);
        const image = new Image();
        image.src = url;
        try {
          await image.decode();
          return image.naturalWidth > 0;
        } catch {
          return false;
        }
      }),
    ).toBe(true);
  }
  for (const img of await page.locator(".client-tile img").all()) {
    await img.scrollIntoViewIfNeeded();
    await expect
      .poll(() => img.evaluate((e) => e.complete && e.naturalWidth > 0))
      .toBe(true);
  }
});
test("professional experience links open localized contributions and keep both Lyzer apps accessible", async ({
  page,
}) => {
  await page.goto("/pt/");
  const suite = page.locator(".app-store-tile--suite");
  await expect(suite.locator("a")).toHaveCount(0);
  await expect(suite).toHaveAttribute("href", "/pt/apps/lyzer-collect-deliver");
  await expect(suite).not.toContainText("Google Play");
  await suite.click();
  await expect(page).toHaveURL(/\/pt\/apps\/lyzer-collect-deliver$/);
  await expect(page.getByRole("heading", { level: 1 })).toHaveText(
    "Lyzer Collect + Deliver",
  );
  const suiteIcons = page.locator(
    ".app-case-title-row .app-icon-image:visible",
  );
  await expect(suiteIcons).toHaveCount(2);
  await expect(suiteIcons.nth(0)).toHaveCSS(
    "background-image",
    /lyzer-collect-icon\.png/,
  );
  await expect(suiteIcons.nth(1)).toHaveCSS(
    "background-image",
    /lyzer-deliver-icon\.png/,
  );
  await expect(page.locator(".app-store-proof")).toHaveCount(4);
  await page.goBack();
  await page
    .locator(".experience-preview")
    .filter({ hasText: "Visagio" })
    .click();
  await expect(page).toHaveURL(/\/pt\/experiencias#visagio$/);
  await expect(page.locator(".experience-record")).toHaveCount(11);
  await expect(page.locator("#visagio")).toContainText(
    "Configurei instâncias AWS EC2",
  );
  await expect(page.locator("#lyzer")).toContainText(
    "aprovação obrigatória de um desenvolvedor",
  );
  await page.locator(".language-toggle").click();
  await expect(page).toHaveURL(/\/experiencias#visagio$/);
  await expect(page.locator("#human-robotics")).toContainText(
    "integrated with a TensorFlow model",
  );
  await page.reload();
  await expect(page.locator("#visagio")).toBeInViewport();
  await expect(page.getByRole("heading", { level: 1 })).toHaveText(
    "Experience by project and contribution.",
  );
  await page.goto("/pt/apps");
  await expect(page.locator(".apps-catalog-page .app-store-tile")).toHaveCount(
    4,
  );
  await page.goto("/pt/#clients");
  await page
    .getByRole("link", { name: "Ver minha atuação: Fullsix", exact: true })
    .click();
  await expect(page).toHaveURL(/\/pt\/experiencias#fullsix$/);
  await expect(page.locator("#fullsix")).toContainText("API Python de OCR");
});

test("language and theme change immediately and persist after reload", async ({
  page,
}) => {
  await page.goto("/pt/");
  await page.getByRole("button", { name: "Escolher idioma: English" }).click();
  await expect(page.locator(".hero-role")).toHaveText("Software Engineer");
  await page.getByRole("button", { name: "Switch to light theme" }).click();
  await expect(page.locator("html")).toHaveAttribute("data-theme", "light");
  // Remove the setup script by using a separate page in the same context.
  const other = await page.context().newPage();
  await other.goto("/");
  await expect(other.locator(".hero-role")).toHaveText("Software Engineer");
  await expect(other.locator("html")).toHaveAttribute("data-theme", "light");
  await other.close();
});
test("language switches keep header controls fixed and can be reversed at the same pointer position", async ({
  page,
}) => {
  await page.goto("/pt/");
  await expect(page.locator(".hero-role")).toHaveText("Engenheiro de Software");
  await page.evaluate(() => document.fonts.ready);
  const controls = page.locator(
    ".brand-home, .language-toggle, .theme-toggle, .contact-trigger",
  );
  const bounds = () =>
    controls.evaluateAll((elements) =>
      elements.map((element) => {
        const { x, y, width, height } = element.getBoundingClientRect();
        return { x, y, width, height };
      }),
    );
  for (const width of [1440, 768, 540, 539, 520, 519, 440, 439, 390, 320]) {
    await page.setViewportSize({ width, height: 900 });
    for (const theme of ["dark", "light"]) {
      if ((await page.locator("html").getAttribute("data-theme")) !== theme)
        await page.locator(".theme-toggle").click();
      const before = await bounds();
      const toggle = before[1];
      const pointer = { x: toggle.x + toggle.width / 2, y: toggle.y + 24 };
      await page.mouse.click(pointer.x, pointer.y);
      await expect(page.locator("html")).toHaveAttribute("lang", "en");
      const after = await bounds();
      for (let index = 0; index < before.length; index++) {
        for (const property of ["x", "y", "width", "height"])
          expect(
            Math.abs(after[index][property] - before[index][property]),
            `${width}px ${theme}: control ${index} ${property}`,
          ).toBeLessThan(0.5);
      }
      await page.mouse.click(pointer.x, pointer.y);
      await expect(page.locator("html")).toHaveAttribute("lang", "pt-BR");
      expect(await bounds()).toEqual(before);
      expect(
        await page.evaluate(
          () => document.documentElement.scrollWidth <= innerWidth,
        ),
      ).toBe(true);
    }
  }
});
test("FAB supports keyboard, outside dismiss and section navigation", async ({
  page,
}) => {
  await page.goto("/pt/");
  const toggle = page.locator(".fab-toggle");
  await toggle.click();
  await expect(toggle).toHaveAttribute("aria-expanded", "true");
  await toggle.press("ArrowDown");
  await expect(
    page.getByRole("button", { name: "Início", exact: true }),
  ).toBeFocused();
  await page.keyboard.press("Escape");
  await expect(toggle).toHaveAttribute("aria-expanded", "false");
  await expect(toggle).toBeFocused();
  await toggle.click();
  await page.getByRole("button", { name: "Clientes", exact: true }).click();
  await expect(page).toHaveURL(/\/$/);
  await expect(page.locator("#clients")).toBeInViewport();
  await toggle.click();
  await page.getByRole("button", { name: "Experiência", exact: true }).click();
  await expect(page.locator("#experience")).toBeInViewport();
  await toggle.click();
  await page.locator(".fab-backdrop").click({ position: { x: 10, y: 120 } });
  await expect(toggle).toHaveAttribute("aria-expanded", "false");
});
test("header contact menu exposes original destinations and dismisses on Escape", async ({
  page,
}) => {
  await page.goto("/pt/");
  const trigger = page.locator(".contact-trigger");
  await trigger.focus();
  await trigger.press("ArrowDown");
  await expect(page.getByRole("menu")).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "WhatsApp" })).toBeFocused();
  await expect(
    page.getByRole("menuitem", { name: "WhatsApp" }),
  ).toHaveAttribute("href", "https://wa.me/5521999997667");
  await expect(page.getByRole("menuitem")).toHaveCount(4);
  await page.keyboard.press("End");
  await expect(page.getByRole("menuitem", { name: "GitHub" })).toBeFocused();
  await page.keyboard.press("Escape");
  await expect(trigger).toBeFocused();
  await expect(page.getByRole("menu")).toHaveCount(0);
});
test("every app detail opens directly, retains screenshots, official links and evidence", async ({
  page,
}) => {
  for (const id of apps) {
    const response = await page.goto("/pt/apps/" + id);
    expect(response.status()).toBe(200);
    await expect(page.locator(".app-detail-page")).toBeVisible();
    await expect(
      page.locator('.app-detail-page a[href*="play.google.com"]'),
    ).toHaveCount(id.startsWith("lyzer") ? 2 : 1);
    expect(
      await page.evaluate(
        () => document.documentElement.scrollWidth <= innerWidth,
      ),
    ).toBe(true);
  }
  await page.locator("summary").click();
  await expect(
    page.getByText("A equipe do Venda Digital entregou", { exact: false }),
  ).toBeVisible();
  const evidence = page.locator('img[src*="reconhecimento-facial"]');
  await evidence.scrollIntoViewIfNeeded();
  await expect
    .poll(() => evidence.evaluate((el) => el.complete && el.naturalWidth > 0))
    .toBe(true);
});
test("home scroll is restored after viewing an app and using back", async ({
  page,
}) => {
  await page.goto("/pt/");
  await page.locator(".app-store-tile").first().scrollIntoViewIfNeeded();
  const before = await page.evaluate(() => scrollY);
  await page.locator(".app-store-tile").first().click();
  await expect(page).toHaveURL(/apps\/van-cranenbroek$/);
  await page.getByRole("button", { name: "Voltar", exact: true }).click();
  await expect(page).toHaveURL(/\/$/);
  await expect
    .poll(async () => Math.abs((await page.evaluate(() => scrollY)) - before))
    .toBeLessThan(8);
});
test("certificates retain 14 records, OR filters, official preview and focus restore", async ({
  page,
}) => {
  await page.goto("/pt/");
  await expect(page.locator(".certificate-highlight")).toHaveCount(3);
  await expect(page.locator(".certificate-highlight").first()).toContainText(
    "LangChain- Agentic AI Engineering with LangChain & LangGraph",
  );
  await page.goto("/pt/certificacoes");
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
  const mobile = page.viewportSize().width < 621;
  if (mobile)
    await page
      .getByRole("button", { name: "Filtrar por tecnologia", exact: true })
      .click();
  await page.getByRole("button", { name: "Flutter", exact: true }).click();
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(1);
  await page.getByRole("button", { name: "AI", exact: true }).click();
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(12);
  await page
    .getByRole("button", { name: "Limpar filtros", exact: true })
    .click();
  await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
  const card = page.locator(".certificate-gallery-card").first();
  await card.click();
  await expect(page.getByRole("dialog")).toBeVisible();
  expect(
    (
      await new AxeBuilder({ page })
        .withTags(["wcag2a", "wcag2aa", "wcag21aa"])
        .analyze()
    ).violations,
  ).toEqual([]);
  await expect(
    page.getByRole("link", { name: "Validar credencial" }),
  ).toHaveAttribute("href", /^https:/);
  const image = page.locator("dialog img");
  await expect
    .poll(() => image.evaluate((el) => el.complete && el.naturalWidth > 0))
    .toBe(true);
  await page.keyboard.press("Escape");
  await expect(page.getByRole("dialog")).toHaveCount(0);
  await expect(card).toBeFocused();
});
test("article and iOS alias preserve complete copy, figures and sharing", async ({
  page,
}) => {
  for (const path of [
    "/artigos/identidade-visual",
    "/ios/artigos/identidade-visual",
  ]) {
    await page.goto("/pt" + path);
    await expect(page.getByRole("heading", { level: 1 })).toHaveText(
      "Como desenvolvi a logo e a identidade visual deste portfólio",
    );
    await expect(page.locator(".identity-figure")).toHaveCount(4);
    await expect(page.locator(".identity-opening-stage")).toHaveCount(4);
    await expect(page.locator(".article-share-badge")).toHaveCount(4);
    await expect(page.locator(".identity-article-conclusion")).toContainText(
      "O L dá estrutura",
      { ignoreCase: true },
    );
    expect(
      await page.evaluate(
        () => document.documentElement.scrollWidth <= innerWidth,
      ),
    ).toBe(true);
  }
});
test("attribution is captured and short ref is removed from the visible URL", async ({
  page,
}) => {
  await page.goto("/pt/?ref=cv-test&utm_source=resume");
  await expect(page).toHaveURL(/\?utm_source=resume$/);
  expect(
    await page.evaluate(() =>
      JSON.parse(sessionStorage.getItem("portfolio_attribution")),
    ),
  ).toEqual({ ref: "cv-test", utm_source: "resume" });
  await page.goto("/pt/in?ref=legacy");
  await expect(page).toHaveURL(/\/$/);
  expect(
    await page.evaluate(
      () => JSON.parse(sessionStorage.getItem("portfolio_attribution")).ref,
    ),
  ).toBe("in");
});
test("all primary pages have one main landmark and pass accessibility checks", async ({
  page,
}) => {
  for (const path of [
    "/",
    "/apps",
    "/apps/van-cranenbroek",
    "/experiencias",
    "/certificacoes",
    "/artigos/identidade-visual",
  ]) {
    await page.goto("/pt" + path);
    if (path === "/certificacoes")
      await expect(page.locator(".certificate-gallery-card")).toHaveCount(14);
    await expect(page.getByRole("main")).toHaveCount(1);
    const result = await new AxeBuilder({ page })
      .withTags(["wcag2a", "wcag2aa", "wcag21aa"])
      .analyze();
    expect(
      result.violations.map((v) => ({
        id: v.id,
        description: v.description,
        nodes: v.nodes.map((n) => n.target),
      })),
    ).toEqual([]);
  }
});
test("opening finishes and morph remains responsive with motion enabled", async ({
  page,
}) => {
  await page.emulateMedia({ reducedMotion: "no-preference" });
  await page.goto("/pt/", { waitUntil: "domcontentloaded" });
  await expect(page.locator(".opening")).toHaveCount(1);
  await expect(page.locator(".opening")).toHaveCount(0, { timeout: 4000 });
  await expect(page.locator(".viewport-frame")).toHaveAttribute(
    "data-preset",
    "desktop",
  );
  await expect(page.locator(".viewport-frame")).toHaveAttribute(
    "data-preset",
    "mobile",
    { timeout: 6000 },
  );
  expect(
    await page.evaluate(
      () => document.documentElement.scrollWidth <= innerWidth,
    ),
  ).toBe(true);
});
test("Node serves known deep links and rejects missing files and unsupported methods", async ({
  request,
}) => {
  expect((await request.get("/api/health")).status()).toBe(200);
  expect((await request.get("/apps/van-cranenbroek")).status()).toBe(200);
  expect((await request.get("/assets/missing.jpg")).status()).toBe(404);
  expect((await request.post("/api/health")).status()).toBe(405);
  expect((await request.get("/route-that-does-not-exist")).status()).toBe(404);
});
test("section deep links work and the closed FAB does not block page content", async ({
  page,
}) => {
  await page.goto("/pt/#apps");
  await expect(page.locator("#apps")).toBeInViewport();
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/pt/");
  expect(
    await page.evaluate(
      () => document.elementFromPoint(218, 488)?.closest(".fab-group") === null,
    ),
  ).toBe(true);
  await page.setViewportSize({ width: 1280, height: 250 });
  await page.goto("/pt/");
  await page.locator(".contact-trigger").click();
  await expect(page.getByRole("menu")).toBeVisible();
  const popup = await page.getByRole("menu").boundingBox();
  expect(popup.y + popup.height).toBeLessThanOrEqual(250);
});
test("tablet and narrow layouts match responsive geometry without overflow", async ({
  page,
}) => {
  for (const width of [320, 650, 768, 1100]) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto("/pt/");
    expect(
      await page.evaluate(
        () => document.documentElement.scrollWidth <= innerWidth,
      ),
    ).toBe(true);
    if (width === 1100) {
      expect(
        await page
          .locator(".architecture-grid")
          .evaluate(
            (el) => getComputedStyle(el).gridTemplateColumns.split(" ").length,
          ),
      ).toBe(4);
    }
    if (width === 650) {
      expect(
        await page
          .locator(".certificate-highlights")
          .evaluate((el) => getComputedStyle(el).display),
      ).toBe("flex");
    }
  }
});

test("English article metadata follows language changes and legacy aliases survive reload", async ({
  page,
}) => {
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  await page.goto("/en/ios/artigos/identidade-visual/?preview=agents#main");
  await expect(page.locator("html")).toHaveAttribute("lang", "en");
  await expect(page).toHaveURL(
    /\/ios\/artigos\/identidade-visual\/?\?preview=agents#main$/,
  );
  await expect(page.locator('link[rel="canonical"]')).toHaveAttribute(
    "href",
    /https?:\/\/[^/]+\/artigos\/identidade-visual\/$/,
  );
  await expect(
    page.locator('link[rel="alternate"][type="text/markdown"]'),
  ).toHaveAttribute(
    "href",
    /https?:\/\/[^/]+\/artigos\/identidade-visual\/index.md$/,
  );
  await page
    .getByRole("button", { name: "Choose language: Português" })
    .click();
  await expect(page.locator("html")).toHaveAttribute("lang", "pt-BR");
  await expect(page).toHaveURL(
    /\/pt\/ios\/artigos\/identidade-visual\/?\?preview=agents#main$/,
  );
  await expect(page.locator('link[rel="canonical"]')).toHaveAttribute(
    "href",
    /\/pt\/artigos\/identidade-visual\/$/,
  );
  await page.getByRole("button", { name: "Escolher idioma: English" }).click();
  const response = await page.reload();
  expect(response.status()).toBe(200);
  await expect(page.locator("html")).toHaveAttribute("lang", "en");
  await expect(page.locator(".identity-article-page h1")).toBeVisible();
  await expect
    .poll(() => page.locator("#portfolio-structured-data").textContent())
    .toContain('"@type":"Article"');
  expect(errors).toEqual([]);
});

test("project and certificates remain readable with JavaScript disabled", async ({
  browser,
}) => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.goto("http://127.0.0.1:4173/apps/lyzer-collect/");
  await expect(page.getByRole("heading", { level: 1 })).toContainText(
    "Lyzer Collect",
  );
  await expect(page.locator("main")).toContainText("Flutter");
  await page.goto("http://127.0.0.1:4173/pt/certificacoes/");
  await expect(page.locator(".certificate-card")).toHaveCount(14);
  await expect(page.locator("main")).toContainText("Anthropic");
  await page.goto("http://127.0.0.1:4173/pt/experiencias/");
  await expect(page.locator(".experience-record")).toHaveCount(11);
  await expect(page.locator("#fullsix")).toContainText("API Python de OCR");
  await context.close();
});
