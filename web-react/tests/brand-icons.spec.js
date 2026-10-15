import { test, expect } from "@playwright/test";

test("all public icon variants have an opaque Canvas background through every edge", async ({
  page,
}) => {
  await page.emulateMedia({ reducedMotion: "reduce" });
  await page.goto("/");
  const icons = await page.evaluate(async () => {
    const root = new URL(".", document.querySelector('link[rel="icon"]').href);
    const files = new Set([
      "favicon.svg",
      "favicon-squircle.svg",
      "favicon.png",
      "favicon-32.png",
      "favicon-squircle-16.png",
      "favicon-squircle-32.png",
      "apple-touch-icon.png",
      "apple-touch-icon-squircle.png",
      "icons/ld-maskable.svg",
    ]);
    for (const manifest of ["manifest.json", "manifest-squircle.json"]) {
      const data = await (await fetch(new URL(manifest, root))).json();
      for (const icon of data.icons) files.add(icon.src.split("?")[0]);
    }
    return Promise.all(
      [...files].map(async (file) => {
        const image = new Image();
        image.src = new URL(file, root).href;
        await image.decode();
        const canvas = document.createElement("canvas");
        const w = (canvas.width = image.naturalWidth);
        const h = (canvas.height = image.naturalHeight);
        const context = canvas.getContext("2d");
        context.drawImage(image, 0, 0);
        const { data } = context.getImageData(0, 0, w, h);
        let transparent = 0;
        let badEdges = 0;
        for (let y = 0; y < h; y++) {
          for (let x = 0; x < w; x++) {
            const i = (y * w + x) * 4;
            if (data[i + 3] !== 255) transparent++;
            if (
              (x === 0 || y === 0 || x === w - 1 || y === h - 1) &&
              (data[i] !== 8 ||
                data[i + 1] !== 8 ||
                data[i + 2] !== 13 ||
                data[i + 3] !== 255)
            )
              badEdges++;
          }
        }
        return { file, transparent, badEdges };
      }),
    );
  });
  expect(icons).toHaveLength(17);
  for (const icon of icons) {
    expect(icon.transparent, icon.file).toBe(0);
    expect(icon.badEdges, icon.file).toBe(0);
  }
  for (const selector of [
    'link[rel="icon"]',
    'link[rel="alternate icon"]',
    'link[rel="apple-touch-icon"]',
    'link[rel="manifest"]',
  ]) {
    await expect(page.locator(selector)).toHaveAttribute(
      "href",
      /\?v=20261015$/,
    );
  }
  for (const selector of [
    'meta[property="og:image"]',
    'meta[name="twitter:image"]',
  ]) {
    await expect(page.locator(selector)).toHaveAttribute(
      "content",
      /\?v=20261015$/,
    );
  }
});
