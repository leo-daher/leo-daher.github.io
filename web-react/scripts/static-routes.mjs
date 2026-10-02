import { readFile, writeFile, mkdir } from "node:fs/promises";
import { renderRoute } from "../.prerender/entry-server.js";
import { writeAgentContent, markdownPath } from "./agent-content.mjs";
import { normalizeBasePath } from "../content/catalog.mjs";

const basePath = normalizeBasePath(process.env.VITE_BASE_PATH || "/");
const siteOrigin = process.env.SITE_ORIGIN || "https://leo-daher.github.io";
const catalog = await writeAgentContent({ basePath, siteOrigin });
const template = await readFile("dist/index.html", "utf8");
const { certificates } = JSON.parse(
  await readFile("public/assets/certificates/catalog.json", "utf8"),
);
const escape = (value) =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll('"', "&quot;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
const publicUrl = (path) =>
  new URL(`${basePath}${path.replace(/^\//, "")}`, siteOrigin).href;

function pageHtml(document, path = document.path) {
  const localizedPath = path.replace(/^\/en(?=\/|$)/, "") || "/";
  const translations = catalog.documents.filter(
    (item) => item.id === document.id,
  );
  const metadata = [
    `<meta name="description" content="${escape(document.description)}" />`,
    `<meta property="og:title" content="${escape(document.title)}" />`,
    `<meta property="og:description" content="${escape(document.description)}" />`,
    `<meta property="og:url" content="${escape(document.url)}" />`,
    `<meta property="og:type" content="${document.id === "visual-identity" ? "article" : "website"}" />`,
    `<meta property="og:locale" content="${document.locale === "pt" ? "pt_BR" : "en_US"}" />`,
    `<meta property="og:locale:alternate" content="${document.locale === "pt" ? "en_US" : "pt_BR"}" />`,
    `<meta property="og:image" content="${escape(publicUrl("/icons/Icon-squircle-512.png"))}" />`,
    `<meta property="og:image:width" content="512" />`,
    `<meta property="og:image:height" content="512" />`,
    `<meta property="og:image:alt" content="Leone Daher LD monogram" />`,
    `<meta name="twitter:title" content="${escape(document.title)}" />`,
    `<meta name="twitter:description" content="${escape(document.description)}" />`,
    `<meta name="twitter:image" content="${escape(publicUrl("/icons/Icon-squircle-512.png"))}" />`,
    `<meta name="twitter:image:alt" content="Leone Daher LD monogram" />`,
    `<link rel="canonical" href="${escape(document.url)}" />`,
    `<link rel="alternate" type="text/markdown" href="${escape(basePath + markdownPath(document.path).slice(1))}" />`,
    `<link rel="describedby" type="text/plain" href="${escape(basePath)}llms.txt" />`,
    ...translations.map(
      (item) =>
        `<link rel="alternate" hreflang="${item.locale === "pt" ? "pt-BR" : "en"}" href="${escape(item.url)}" />`,
    ),
    `<script id="portfolio-structured-data" type="application/ld+json">${JSON.stringify(document.schema).replaceAll("<", "\\u003c")}</script>`,
  ].join("\n");
  let markup = renderRoute(localizedPath, {
    locale: document.locale,
    certificates,
  });
  if (document.locale === "en") {
    markup = markup.replace(/href="([^"]*)"/g, (attribute, href) => {
      if (!href.startsWith(basePath) || /\.[a-z0-9]+(?:[?#]|$)/i.test(href))
        return attribute;
      const route = href.slice(basePath.length);
      if (route.startsWith("en/") || route.startsWith("assets/"))
        return attribute;
      return `href="${basePath}en/${route}"`;
    });
  }
  return template
    .replace(
      /<html[^>]*>/,
      `<html lang="${document.locale === "pt" ? "pt-BR" : "en"}" data-theme="dark">`,
    )
    .replace(/<title>.*?<\/title>/s, `<title>${escape(document.title)}</title>`)
    .replace(
      /<meta\s+(?:name="description"|property="og:(?:title|description|type)")[^>]*>/g,
      "",
    )
    .replace("</head>", `${metadata}\n</head>`)
    .replace('<div id="root"></div>', `<div id="root">${markup}</div>`);
}
for (const document of catalog.documents) {
  const directory = `dist${document.path === "/" ? "" : document.path.replace(/\/$/, "")}`;
  await mkdir(directory, { recursive: true });
  await writeFile(`${directory}/index.html`, pageHtml(document));
}
for (const alias of [
  "ios",
  "en/ios",
  "ios/artigos/identidade-visual",
  "en/ios/artigos/identidade-visual",
]) {
  const locale = alias.startsWith("en/") ? "en" : "pt";
  const id = alias.includes("artigos") ? "visual-identity" : "profile";
  const document = catalog.documents.find(
    (item) => item.id === id && item.locale === locale,
  );
  await mkdir(`dist/${alias}`, { recursive: true });
  await writeFile(`dist/${alias}/index.html`, pageHtml(document));
}
for (const locale of ["pt", "en"]) {
  for (const channel of ["in", "ig"]) {
    const localizedRoot = locale === "en" ? "en/" : "";
    const route = `${localizedRoot}${channel}`;
    const target = `${basePath}${localizedRoot}?ref=${channel}`;
    await mkdir(`dist/${route}`, { recursive: true });
    await writeFile(
      `dist/${route}/index.html`,
      `<!doctype html>
<html lang="${locale === "pt" ? "pt-BR" : "en"}"><head>
<meta charset="UTF-8" />
<meta name="robots" content="noindex" />
<meta http-equiv="refresh" content="0;url=${escape(target)}" />
<link rel="canonical" href="${escape(publicUrl(`/${localizedRoot}`))}" />
<title>Leone Daher — Portfolio</title>
<script>window.location.replace(${JSON.stringify(target).replaceAll("<", "\\u003c")});</script>
</head><body><a href="${escape(target)}">${locale === "pt" ? "Continuar para o portfólio" : "Continue to the portfolio"}</a></body></html>`,
    );
  }
}
await writeFile(
  "dist/404.html",
  template.replace(
    '<div id="root"></div>',
    `<div id="root">${renderRoute("/not-found")}</div>`,
  ),
);
await writeFile(
  "dist/build-config.json",
  JSON.stringify({ basePath, siteOrigin }),
);
console.log(
  `Static HTML: ${catalog.documents.length} localized pages, Markdown, structured data and crawl maps.`,
);
