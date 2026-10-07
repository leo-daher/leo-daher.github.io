import { after, before, test } from "node:test";
import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { createServer } from "node:net";
import { request } from "node:http";
import { readFile } from "node:fs/promises";
import {
  Client,
  StreamableHTTPClientTransport,
} from "@modelcontextprotocol/client";

const config = JSON.parse(await readFile("dist/build-config.json", "utf8"));
const catalog = JSON.parse(await readFile("dist/portfolio.json", "utf8"));
const prefix =
  config.basePath === "/" ? "" : config.basePath.replace(/\/$/, "");
let server,
  origin,
  output = "";
const local = (url) => origin + new URL(url).pathname;
const decode = (value) =>
  value.replaceAll("&amp;", "&").replaceAll("&quot;", '"');

before(async () => {
  const socket = createServer();
  await new Promise((resolve) => socket.listen(0, "127.0.0.1", resolve));
  const port = socket.address().port;
  await new Promise((resolve) => socket.close(resolve));
  origin = `http://127.0.0.1:${port}`;
  server = spawn(process.execPath, ["server.mjs"], {
    env: { ...process.env, PORT: String(port), HOST: "127.0.0.1" },
    stdio: ["ignore", "pipe", "pipe"],
  });
  server.stdout.on("data", (data) => (output += data));
  server.stderr.on("data", (data) => (output += data));
  for (let attempt = 0; attempt < 80; attempt++) {
    try {
      if ((await fetch(`${origin}/api/health`)).ok) return;
    } catch {
      /* Wait for the isolated server to listen. */
    }
    if (server.exitCode !== null) throw new Error(output);
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  throw new Error(`Node server did not start: ${output}`);
});
after(async () => {
  if (!server || server.exitCode !== null) return;
  const exited = new Promise((resolve) => server.once("exit", resolve));
  server.kill("SIGTERM");
  await exited;
});

test("all localized pages expose real content, canonical metadata and matching Markdown without JavaScript", async () => {
  for (const doc of catalog.documents) {
    const response = await fetch(local(doc.url));
    assert.equal(response.status, 200, doc.url);
    const html = await response.text();
    assert.match(html, /<main\b/);
    assert.match(
      html,
      new RegExp(`<html lang="${doc.locale === "pt" ? "pt-BR" : "en"}"`),
    );
    assert.ok(html.includes(doc.url));
    const defaultDocument = catalog.documents.find(
      (item) => item.id === doc.id && item.locale === "en",
    );
    assert.ok(
      html.includes(`hreflang="x-default" href="${defaultDocument.url}"`),
    );
    const schemaText = html.match(
      /<script id="portfolio-structured-data" type="application\/ld\+json">(.*?)<\/script>/s,
    )?.[1];
    assert.ok(schemaText, doc.path);
    assert.deepEqual(JSON.parse(schemaText), doc.schema);
    const body = html.slice(html.indexOf('<div id="root">'));
    assert.match(body, /<h[12]\b/);
    assert.ok(doc.title.includes("Leone Daher"), doc.path);
    if (doc.id === "profile" || doc.id === "apps") {
      assert.match(body, /<h1\b/);
      assert.ok(!body.includes('alt=""'), doc.path);
    }
    if (doc.id === "profile") {
      assert.match(body, /<h1[^>]*>.*Leone Daher.*<\/h1>/s);
    }
    if (doc.id === "certificates")
      assert.equal((body.match(/class="certificate-card /g) || []).length, 14);
    if (!["profile"].includes(doc.id))
      assert.ok(!body.includes('id="home"'), doc.path);
    const markdown = await fetch(local(doc.markdownUrl));
    assert.equal(markdown.status, 200);
    assert.match(markdown.headers.get("content-type"), /text\/markdown/);
    assert.equal(await markdown.text(), doc.markdown);
    assert.ok(response.headers.get("link").includes("llms.txt"));
    assert.ok(
      response.headers.get("link").includes(new URL(doc.markdownUrl).pathname),
    );
  }
});

test("legacy English routes redirect locally and retain campaign parameters", async () => {
  for (const path of [
    "/en/",
    "/en/apps/lyzer-collect/",
    "/en/ios/artigos/identidade-visual/",
    "/en/index.md",
  ]) {
    const response = await fetch(`${origin}${prefix}${path}?preview=agents`, {
      redirect: "manual",
    });
    assert.equal(response.status, 308);
    assert.equal(
      response.headers.get("location"),
      `${prefix}${path.slice(3)}?preview=agents`,
    );
    assert.equal(
      (await fetch(`${origin}${response.headers.get("location")}`)).status,
      200,
    );
  }
  for (const path of [
    "/en//example.com",
    "/en/%5C%5Cexample.com",
    "/en/a/%2e%2e/%2fexample.com",
  ]) {
    const response = await fetch(`${origin}${prefix}${path}`, {
      redirect: "manual",
    });
    const target = response.headers.get("location");
    assert.equal(response.status, 308);
    assert.ok(target.startsWith("/") && !target.startsWith("//"), target);
    assert.equal(new URL(target, origin).origin, origin);
  }
});

test("agent guide, sitemap and public data expose bounded facts and working discovery links", async () => {
  const guide = await fetch(`${origin}${prefix}/llms.txt`);
  assert.match(guide.headers.get("content-type"), /text\/plain/);
  const text = await guide.text();
  assert.match(text, /^# Leone Daher\n/);
  assert.match(text, /Latitudde\/Conkord/);
  assert.match(text, /July 2026/);
  for (const [, url] of text.matchAll(/\]\((https?:\/\/[^)]+)\)/g))
    assert.equal((await fetch(local(url))).status, 200, url);
  const map = await (await fetch(`${origin}${prefix}/sitemap.xml`)).text();
  for (const [, url] of map.matchAll(/<loc>(.*?)<\/loc>/g))
    assert.equal((await fetch(local(decode(url)))).status, 200, url);
  const json = await (await fetch(`${origin}${prefix}/portfolio.json`)).json();
  assert.equal(json.documents.length, 18);
  const lyzerDownloads = json.profile.metrics.find(
    (metric) => metric.id === "lyzer-suite-store-summary",
  );
  assert.equal(lyzerDownloads.value, 1100);
  assert.equal(lyzerDownloads.sources.length, 2);
  assert.ok(
    lyzerDownloads.sources.every((url) =>
      url.startsWith("https://play.google.com/"),
    ),
  );
  const experiences = json.documents.find(
    (doc) => doc.id === "experiences" && doc.locale === "pt",
  );
  assert.equal(experiences.schema.numberOfItems, 11);
  assert.match(experiences.markdown, /AWS EC2/);
  assert.match(experiences.markdown, /aprovação obrigatória/);
  assert.equal(
    json.profile.metrics.find((metric) => metric.id === "app-deliveries").value,
    14,
  );
  assert.ok(
    json.profile.metrics
      .find((metric) => metric.id === "app-deliveries")
      .excludes.includes("MAG Venda Digital"),
  );
  assert.match(JSON.stringify(json.profile.metrics), /2026-07/);
  const enHome = await (await fetch(`${origin}${prefix}/`)).text();
  assert.ok(enHome.includes(`href="${prefix}/apps/van-cranenbroek"`));
  const ptHome = await (await fetch(`${origin}${prefix}/pt/`)).text();
  assert.ok(ptHome.includes(`href="${prefix}/pt/apps/van-cranenbroek"`));
  assert.match(ptHome, /<html lang="pt-BR"/);
  const alias = await fetch(
    `${origin}${prefix}/en/ios/artigos/identidade-visual/`,
  );
  assert.equal(alias.status, 200);
  assert.match(await alias.text(), /<html lang="en"/);
});

test("official MCP client discovers read-only tools and reads/searches source-backed public documents", async () => {
  const client = new Client({ name: "portfolio-validation", version: "1.0.0" });
  try {
    await client.connect(
      new StreamableHTTPClientTransport(new URL(`${origin}${prefix}/mcp`)),
    );
    const { tools } = await client.listTools();
    assert.deepEqual(tools.map((tool) => tool.name).sort(), [
      "get_portfolio_overview",
      "read_portfolio_document",
      "search_portfolio",
    ]);
    assert.ok(
      tools.every(
        (tool) =>
          tool.annotations.readOnlyHint && !tool.annotations.destructiveHint,
      ),
    );
    const overview = await client.callTool({
      name: "get_portfolio_overview",
      arguments: { locale: "en" },
    });
    assert.equal(overview.structuredContent.profile.name, "Leone Daher");
    assert.equal(overview.structuredContent.documents.length, 9);
    const defaults = await client.callTool({
      name: "get_portfolio_overview",
      arguments: {},
    });
    assert.equal(defaults.structuredContent.documents.length, 9);
    assert.ok(
      defaults.structuredContent.documents.every(
        (document) => document.locale === "en",
      ),
    );
    const defaultSearch = await client.callTool({
      name: "search_portfolio",
      arguments: { query: "offline Flutter" },
    });
    assert.ok(
      defaultSearch.structuredContent.matches.some(
        (document) => document.id === "lyzer-collect",
      ),
    );
    assert.ok(
      defaultSearch.structuredContent.matches.every(
        (document) => document.locale === "en",
      ),
    );
    const defaultDocument = await client.callTool({
      name: "read_portfolio_document",
      arguments: { id: "profile" },
    });
    assert.equal(defaultDocument.structuredContent.locale, "en");
    const found = await client.callTool({
      name: "search_portfolio",
      arguments: { query: "offline Flutter", locale: "en" },
    });
    assert.ok(
      found.structuredContent.matches.some((doc) => doc.id === "lyzer-collect"),
    );
    const unknown = await client.callTool({
      name: "search_portfolio",
      arguments: { query: "quantum-zebrafish-unknown", locale: "pt" },
    });
    assert.equal(unknown.structuredContent.matches.length, 0);
    const full = await client.callTool({
      name: "read_portfolio_document",
      arguments: { id: "mag-venda-digital", locale: "pt" },
    });
    assert.match(full.structuredContent.markdown, /SERPRO/);
    const { resources } = await client.listResources();
    assert.equal(resources.length, 18);
    const certificate = resources.find(
      (resource) => resource.name === "en-certificates",
    );
    const read = await client.readResource({ uri: certificate.uri });
    assert.equal(
      read.contents[0].text,
      catalog.documents.find(
        (doc) => doc.id === "certificates" && doc.locale === "en",
      ).markdown,
    );
    const unavailable = await client.callTool({
      name: "read_portfolio_document",
      arguments: { id: "private-resume", locale: "en" },
    });
    assert.equal(unavailable.isError, true);
    assert.equal(unavailable.structuredContent, undefined);
  } finally {
    await client.close();
  }
});

test("public migration preserves social previews, install icons and social redirects without JavaScript", async () => {
  for (const doc of catalog.documents) {
    const html = await (await fetch(local(doc.url))).text();
    assert.ok(html.includes(`<meta name="twitter:title" content=`));
    assert.ok(html.includes(`<meta name="twitter:card" content="summary"`));
    assert.ok(
      html.includes(
        `property="og:type" content="${doc.id === "visual-identity" ? "article" : "website"}"`,
      ),
    );
    assert.ok(
      html.includes(
        `property="og:locale:alternate" content="${doc.locale === "pt" ? "en_US" : "pt_BR"}"`,
      ),
    );
    const image = html.match(/property="og:image" content="([^"]+)"/)?.[1];
    assert.ok(image, doc.path);
    assert.equal((await fetch(local(decode(image)))).status, 200);
  }
  for (const locale of ["", "/pt"]) {
    for (const channel of ["in", "ig"]) {
      const html = await (
        await fetch(`${origin}${prefix}${locale}/${channel}/`)
      ).text();
      const target = `${prefix}${locale}/?ref=${channel}`;
      assert.match(html, /name="robots" content="noindex"/);
      assert.ok(html.includes(`content="0;url=${target}"`));
      assert.ok(html.includes(`href="${target}"`));
      assert.equal((await fetch(origin + target)).status, 200);
    }
  }
  const manifest = await (
    await fetch(`${origin}${prefix}/manifest-squircle.json`)
  ).json();
  for (const icon of manifest.icons) {
    assert.equal((await fetch(`${origin}${prefix}/${icon.src}`)).status, 200);
  }
  assert.equal(
    (await fetch(`${origin}${prefix}/apple-touch-icon-squircle.png`)).status,
    200,
  );
  const worker = await (
    await fetch(`${origin}${prefix}/flutter_service_worker.js`)
  ).text();
  assert.match(worker, /registration\.unregister/);
  assert.match(worker, /client\.navigate\(client\.url\)/);
});

test("legacy MCP handshake works and unsafe origins, malformed requests and oversized bodies are rejected", async () => {
  const endpoint = `${origin}${prefix}/mcp`;
  const headers = {
    "Content-Type": "application/json",
    Accept: "application/json, text/event-stream",
  };
  const initialize = {
    jsonrpc: "2.0",
    id: 1,
    method: "initialize",
    params: {
      protocolVersion: "2025-11-25",
      capabilities: {},
      clientInfo: { name: "legacy-check", version: "1.0.0" },
    },
  };
  const initialized = await fetch(endpoint, {
    method: "POST",
    headers,
    body: JSON.stringify(initialize),
  });
  assert.equal(initialized.status, 200);
  assert.match(await initialized.text(), /leone-portfolio/);
  assert.equal(
    (
      await fetch(endpoint, {
        method: "POST",
        headers: { ...headers, Origin: "https://untrusted.example" },
        body: JSON.stringify(initialize),
      })
    ).status,
    403,
  );
  assert.equal(
    await new Promise((resolve, reject) => {
      const probe = request(
        endpoint,
        {
          method: "POST",
          headers: { ...headers, Host: "untrusted.example" },
        },
        (response) => {
          response.resume();
          response.once("end", () => resolve(response.statusCode));
        },
      );
      probe.once("error", reject);
      probe.end(JSON.stringify(initialize));
    }),
    403,
  );
  assert.equal(
    (await fetch(endpoint, { method: "POST", headers, body: "{invalid" }))
      .status,
    400,
  );
  assert.equal(
    (
      await fetch(endpoint, {
        method: "POST",
        headers,
        body: "x".repeat(65537),
      })
    ).status,
    413,
  );
  assert.equal(
    (
      await fetch(endpoint, {
        method: "POST",
        headers: { ...headers, "Content-Type": "text/plain" },
        body: JSON.stringify(initialize),
      })
    ).status,
    415,
  );
});
