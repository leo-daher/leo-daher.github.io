import { readFile, writeFile } from "node:fs/promises";
import { chromium } from "@playwright/test";

const root = new URL("../../", import.meta.url);
const favicon = await readFile(new URL("web/favicon.svg", root), "utf8");
const maskable = await readFile(
  new URL("web/icons/ld-maskable.svg", root),
  "utf8",
);
const variants = [
  [favicon, 16, ["favicon.png", "favicon-squircle-16.png"]],
  [favicon, 32, ["favicon-32.png", "favicon-squircle-32.png"]],
  [favicon, 180, ["apple-touch-icon.png", "apple-touch-icon-squircle.png"]],
  [favicon, 192, ["icons/Icon-192.png", "icons/Icon-squircle-192.png"]],
  [favicon, 512, ["icons/Icon-512.png", "icons/Icon-squircle-512.png"]],
  [
    maskable,
    192,
    ["icons/Icon-maskable-192.png", "icons/Icon-squircle-maskable-192.png"],
  ],
  [
    maskable,
    512,
    ["icons/Icon-maskable-512.png", "icons/Icon-squircle-maskable-512.png"],
  ],
];
const browser = await chromium.launch(
  process.env.PLAYWRIGHT_CHROME_PATH
    ? { executablePath: process.env.PLAYWRIGHT_CHROME_PATH }
    : {},
);
try {
  const page = await browser.newPage();
  for (const [svg, size, files] of variants) {
    const base64 = await page.evaluate(
      async ({ svg, size }) => {
        // Rasterize at 4x before downsampling to preserve smooth small curves.
        const source = svg.replace(
          'width="512" height="512"',
          `width="${size * 4}" height="${size * 4}"`,
        );
        const url = URL.createObjectURL(
          new Blob([source], { type: "image/svg+xml" }),
        );
        try {
          const image = new Image();
          image.src = url;
          await image.decode();
          const raster = document.createElement("canvas");
          raster.width = raster.height = size * 4;
          raster.getContext("2d").drawImage(image, 0, 0);
          const canvas = document.createElement("canvas");
          canvas.width = canvas.height = size;
          const context = canvas.getContext("2d", { alpha: false });
          context.imageSmoothingEnabled = true;
          context.imageSmoothingQuality = "high";
          context.drawImage(raster, 0, 0, size, size);
          return canvas.toDataURL("image/png").split(",")[1];
        } finally {
          URL.revokeObjectURL(url);
        }
      },
      { svg, size },
    );
    const png = Buffer.from(base64, "base64");
    for (const directory of ["web", "web-react/public"]) {
      for (const file of files) {
        await writeFile(new URL(`${directory}/${file}`, root), png);
      }
    }
  }
  for (const directory of ["web", "web-react/public"]) {
    for (const file of ["favicon.svg", "favicon-squircle.svg"]) {
      await writeFile(new URL(`${directory}/${file}`, root), favicon);
    }
    await writeFile(
      new URL(`${directory}/icons/ld-maskable.svg`, root),
      maskable,
    );
  }
} finally {
  await browser.close();
}
console.log("Web icons regenerated with an opaque Canvas background.");
