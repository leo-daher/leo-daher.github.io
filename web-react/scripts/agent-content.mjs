import { mkdir, writeFile } from "node:fs/promises";
import { dirname, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";
import {
  loadPortfolioContent,
  normalizeBasePath,
} from "../content/catalog.mjs";

const defaultOrigin = "https://leo-daher.github.io";
const xmlEscape = (value) =>
  value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
const label = (value) =>
  value
    .replace(/\s+/g, " ")
    .replaceAll("\\", "\\\\")
    .replaceAll("[", "\\[")
    .replaceAll("]", "\\]");
export function markdownPath(path) {
  return `${path.replace(/\/$/, "")}/index.md`;
}

function publicUrl(path, basePath, siteOrigin) {
  return new URL(`${basePath}${path.replace(/^\//, "")}`, siteOrigin).href;
}

function llmsIndex(content, basePath, siteOrigin) {
  const { profile, documents } = content;
  const url = (path) => publicUrl(path, basePath, siteOrigin);
  const lines = [
    `# ${profile.name}`,
    "> Public portfolio covering mobile engineering, connected systems, AI automation, selected published apps, verified course records, and an article about the LD visual identity. Portuguese and English documents are available.",
    "The Markdown versions mirror the public portfolio copy and selected public evidence. Cases describe contribution within teams; store listings are product evidence. The contact section gives the public professional channels.",
    ...profile.limitations.en,
    `Português: os documentos abaixo reproduzem o conteúdo público do portfólio. Os ${profile.metrics.find((metric) => metric.id === "app-deliveries").value} apps pertencem ao inventário Latitudde/Conkord, sem somar MAG. Métricas de loja foram consultadas em julho de 2026; cursos não substituem experiência profissional.`,
  ];
  for (const [locale, heading] of [
    ["pt", "Português"],
    ["en", "English"],
  ]) {
    lines.push(`## ${heading}`);
    lines.push(
      documents
        .filter((document) => document.locale === locale)
        .map(
          (document) =>
            `- [${label(document.title)}](${url(markdownPath(document.path))}): ${label(document.description)}`,
        )
        .join("\n"),
    );
  }
  lines.push("## Optional");
  lines.push(
    [
      `- [Full public content](${url("/llms-full.txt")}): All Portuguese and English Markdown documents with their source-page links.`,
      `- [Public content catalog](${url("/portfolio.json")}): Profile, bounded metrics, document metadata, Markdown, and Schema.org JSON-LD. This is a site-specific JSON export.`,
      `- [Certificate source records](${url("/assets/certificates/catalog.json")}): The existing public catalog, verification dates, issuers, tags, and official validation URLs.`,
      `- [MAG collective-delivery evidence](${url("/assets/evidence/mag-venda-digital-reconhecimento-facial.json")}): The selected public record of a team delivery; original post metadata is included only when published.`,
    ].join("\n"),
  );
  return `${lines.join("\n\n")}\n`;
}

function fullContent(content, basePath, siteOrigin) {
  const url = (path) => publicUrl(path, basePath, siteOrigin);
  const documents = content.documents
    .map((document) =>
      [
        `## ${document.locale.toUpperCase()} · ${document.id}`,
        `Source page: ${url(document.path === "/" || document.path.endsWith("/") ? document.path : `${document.path}/`)}`,
        `Markdown: ${url(markdownPath(document.path))}`,
        document.markdown.trim(),
      ].join("\n\n"),
    )
    .join("\n\n---\n\n");
  return `# ${content.profile.name} — full public portfolio\n\n> Portuguese and English content generated from the same public interface copy, selected app catalog, public credential records, and selected MAG evidence.\n\n${documents}\n`;
}

function sitemap(content, basePath, siteOrigin) {
  const url = (document) =>
    publicUrl(
      document.path === "/" || document.path.endsWith("/")
        ? document.path
        : `${document.path}/`,
      basePath,
      siteOrigin,
    );
  const entries = content.documents.map((document) => {
    const translations = content.documents.filter(
      (other) => other.id === document.id,
    );
    const alternates = translations.map(
      (other) =>
        `    <xhtml:link rel="alternate" hreflang="${other.locale === "pt" ? "pt-BR" : "en"}" href="${xmlEscape(url(other))}" />`,
    );
    const primary = translations.find((other) => other.locale === "pt");
    if (primary)
      alternates.push(
        `    <xhtml:link rel="alternate" hreflang="x-default" href="${xmlEscape(url(primary))}" />`,
      );
    return `  <url>\n    <loc>${xmlEscape(url(document))}</loc>\n${alternates.join("\n")}\n  </url>`;
  });
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">\n${entries.join("\n")}\n</urlset>\n`;
}

/** Generate public agent-readable artifacts; this does not configure an MCP endpoint. */
export async function writeAgentContent({
  outDir = "dist",
  basePath = "/",
  siteOrigin = defaultOrigin,
} = {}) {
  const base = normalizeBasePath(basePath);
  const content = await loadPortfolioContent({ basePath: base, siteOrigin });
  const target = resolve(outDir);
  const files = [];
  const write = async (path, value) => {
    const file = resolve(target, path.replace(/^\//, ""));
    if (!file.startsWith(`${target}${sep}`))
      throw new Error(`Output escapes the content directory: ${path}`);
    await mkdir(dirname(file), { recursive: true });
    await writeFile(file, value, "utf8");
    files.push(file);
  };
  for (const document of content.documents)
    await write(markdownPath(document.path), document.markdown);
  await write("/llms.txt", llmsIndex(content, base, siteOrigin));
  await write("/llms-full.txt", fullContent(content, base, siteOrigin));
  await write(
    "/portfolio.json",
    `${JSON.stringify({ schemaVersion: 1, kind: "public-portfolio", siteOrigin: new URL(siteOrigin).origin, basePath: base, generatedAt: new Date().toISOString(), ...content }, null, 2)}\n`,
  );
  await write("/sitemap.xml", sitemap(content, base, siteOrigin));
  await write(
    "/robots.txt",
    `# Crawl rules apply when this file is served at the origin root.\nUser-agent: *\nAllow: ${base}\nSitemap: ${publicUrl("/sitemap.xml", base, siteOrigin)}\n`,
  );
  return { ...content, outDir: target, files };
}

if (
  process.argv[1] &&
  resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
  const result = await writeAgentContent({
    outDir: process.argv[2] || "dist",
    basePath: process.env.VITE_BASE_PATH || "/",
    siteOrigin: process.env.SITE_ORIGIN || defaultOrigin,
  });
  console.log(
    `Public content: ${result.documents.length} documents, ${result.files.length} artifacts in ${result.outDir}`,
  );
}
