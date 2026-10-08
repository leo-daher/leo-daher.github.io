import http from "node:http";
import { createReadStream } from "node:fs";
import { stat, readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";
import { createPortfolioMcp } from "./mcp.mjs";
const root = path.resolve(fileURLToPath(new URL("./dist/", import.meta.url)));
const port = Number(process.env.PORT || 4173);
const host = process.env.HOST || "127.0.0.1";
const types = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".ttf": "font/ttf",
  ".webp": "image/webp",
  ".map": "application/json",
  ".md": "text/markdown; charset=utf-8",
  ".txt": "text/plain; charset=utf-8",
  ".xml": "application/xml; charset=utf-8",
};
const validRoutes = new Set([
  "/",
  "/ios",
  "/apps",
  "/certificacoes",
  "/artigos/identidade-visual",
  "/ios/artigos/identidade-visual",
  "/en/ios/artigos/identidade-visual",
  "/apps/van-cranenbroek",
  "/apps/lyzer-collect",
  "/apps/lyzer-deliver",
  "/apps/lyzer-collect-deliver",
  "/apps/mag-venda-digital",
  "/in",
  "/ig",
]);
try {
  await stat(path.join(root, "index.html"));
} catch {
  console.error("Build the portfolio with npm run build before starting.");
  process.exit(1);
}
const config = JSON.parse(
  await readFile(path.join(root, "build-config.json"), "utf8"),
);
const prefix =
  config.basePath === "/" ? "" : config.basePath.replace(/\/$/, "");
const catalog = JSON.parse(
  await readFile(path.join(root, "portfolio.json"), "utf8"),
);
const mcp = createPortfolioMcp(catalog, {
  basePath: config.basePath,
  siteOrigin: config.siteOrigin,
  port,
});
const markdownFor = new Map(
  catalog.documents.map((document) => [
    document.path.replace(/\/$/, "") || "/",
    new URL(document.markdownUrl).pathname,
  ]),
);
const server = http.createServer(async (req, res) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
  let pathname;
  try {
    pathname = decodeURIComponent(
      new URL(req.url, "http://localhost").pathname,
    );
  } catch {
    res.writeHead(400);
    return res.end("Bad request");
  }
  if (pathname === `${prefix}/mcp`) {
    try {
      await mcp.handle(req, res);
    } catch {
      if (!res.headersSent) res.writeHead(500);
      res.end("Unable to serve MCP request");
    }
    return;
  }
  if (!["GET", "HEAD"].includes(req.method)) {
    res.writeHead(405, { Allow: "GET, HEAD" });
    return res.end();
  }
  if (pathname === "/api/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(
      req.method === "HEAD"
        ? undefined
        : JSON.stringify({ status: "ok", app: "leone-portfolio-react" }),
    );
  }
  if (prefix && (pathname === "/" || pathname === prefix)) {
    const query = new URL(req.url, "http://localhost").search;
    res.writeHead(302, { Location: `${prefix}/${query}` });
    return res.end();
  }
  if (prefix && !pathname.startsWith(`${prefix}/`)) {
    res.writeHead(404);
    return res.end("Not found");
  }
  const localPath = prefix ? pathname.slice(prefix.length) : pathname;
  if (/^\/en(?:\/|$)/.test(localPath)) {
    const url = new URL(req.url, "http://localhost");
    const destination = new URL("http://localhost/");
    destination.pathname = `${prefix}/${localPath.slice(3).replace(/^[/\\]+/, "")}`;
    destination.search = url.search;
    res.writeHead(308, {
      Location: destination.pathname.replace(/^\/+/, "/") + destination.search,
    });
    return res.end();
  }
  const normalized = localPath.replace(/\/$/, "") || "/";
  const file = path.resolve(root, `.${localPath}`);
  if (file !== root && !file.startsWith(root + path.sep)) {
    res.writeHead(403);
    return res.end("Forbidden");
  }
  try {
    let target = file;
    let info;
    try {
      info = await stat(target);
      if (info.isDirectory()) {
        target = path.join(target, "index.html");
        info = await stat(target);
      }
    } catch {
      if (!validRoutes.has(normalized)) {
        res.writeHead(404);
        return res.end("Not found");
      }
      target = path.join(root, "index.html");
      info = await stat(target);
    }
    const markdown = markdownFor.get(normalized);
    res.setHeader(
      "Link",
      [
        `<${prefix}/llms.txt>; rel="describedby"; type="text/plain"`,
        ...(markdown && path.extname(target) === ".html"
          ? [`<${markdown}>; rel="alternate"; type="text/markdown"`]
          : []),
      ].join(", "),
    );
    res.writeHead(200, {
      "Content-Type": types[path.extname(target)] || "application/octet-stream",
      "Content-Length": info.size,
      "Cache-Control": target.includes("/assets/index-")
        ? "public, max-age=31536000, immutable"
        : "no-cache",
    });
    if (req.method === "HEAD") return res.end();
    const stream = createReadStream(target);
    stream.on("error", () => res.destroy());
    stream.pipe(res);
  } catch {
    res.writeHead(500);
    res.end("Unable to read file");
  }
});
server.listen(port, host, () =>
  console.log(`Leone portfolio: http://${host}:${port}${prefix}/`),
);
for (const signal of ["SIGINT", "SIGTERM"])
  process.on(signal, () =>
    server.close(async () => {
      await mcp.close();
      process.exit(0);
    }),
  );
