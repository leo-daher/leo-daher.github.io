import { McpServer, createMcpHandler } from "@modelcontextprotocol/server";
import {
  hostHeaderValidation,
  toNodeHandler,
} from "@modelcontextprotocol/node";
import * as z from "zod/v4";

const annotations = {
  readOnlyHint: true,
  destructiveHint: false,
  idempotentHint: true,
  openWorldHint: false,
};
const fold = (text) =>
  text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();

export function createPortfolioMcp(
  catalog,
  { basePath = "/", siteOrigin, port },
) {
  const site = new URL(siteOrigin);
  const resourceUrl = (document) => document.markdownUrl;
  const summary = (document) => ({
    id: document.id,
    locale: document.locale,
    title: document.title,
    description: document.description,
    url: document.url,
    markdownUrl: document.markdownUrl,
  });
  const result = (data) => ({
    content: [{ type: "text", text: JSON.stringify(data) }],
    structuredContent: data,
  });
  const locale = z.enum(["pt", "en"]).default("en");
  const ids = [...new Set(catalog.documents.map((document) => document.id))];
  const factory = () => {
    const server = new McpServer(
      { name: "leone-portfolio", version: "1.0.0" },
      {
        instructions:
          "Read-only public portfolio of Leone Daher. Start with get_portfolio_overview, search by technology or product, then read documents for source links and contribution details. Cite the supplied source URLs. Store statistics are dated snapshots; aggregate downloads are estimates; app delivery counts refer to the Latitudde/Conkord inventory. Certificates describe courses, not employment. Missing details are unknown. No messaging, applications or private records are available.",
      },
    );
    server.registerTool(
      "get_portfolio_overview",
      {
        title: "Public professional profile and content map",
        description:
          "Get the profile and a map of public projects, courses and article evidence.",
        inputSchema: z.object({ locale }),
        annotations,
      },
      async ({ locale }) =>
        result({
          profile: catalog.profile,
          documents: catalog.documents
            .filter((doc) => doc.locale === locale)
            .map(summary),
        }),
    );
    server.registerTool(
      "search_portfolio",
      {
        title: "Search public portfolio evidence",
        description:
          "Search project contributions, technology stacks, dated store evidence, certificates and articles. Returns source excerpts; no matching evidence produces an empty result.",
        inputSchema: z.object({
          query: z.string().trim().min(2).max(160),
          locale,
          limit: z.number().int().min(1).max(8).default(5),
        }),
        annotations,
      },
      async ({ query, locale, limit }) => {
        const terms = [...new Set(fold(query).split(/\s+/).filter(Boolean))];
        const matches = catalog.documents
          .filter((doc) => doc.locale === locale)
          .map((doc) => {
            const text = fold(doc.markdown);
            const title = fold(doc.title);
            const score = terms.reduce(
              (total, term) =>
                total +
                (text.includes(term) ? 1 : 0) +
                (title.includes(term) ? 3 : 0),
              0,
            );
            const position = Math.max(
              0,
              ...terms.map((term) => text.indexOf(term)),
            );
            return {
              ...summary(doc),
              score,
              excerpt: doc.markdown.slice(
                Math.max(0, position - 100),
                position + 360,
              ),
            };
          })
          .filter((doc) => doc.score > 0)
          .sort((a, b) => b.score - a.score)
          .slice(0, limit);
        return result({ query, locale, matches });
      },
    );
    server.registerTool(
      "read_portfolio_document",
      {
        title: "Read a complete public portfolio document",
        description:
          "Read a specific case study, profile, course catalog or article with public source links and metric limitations.",
        inputSchema: z.object({ id: z.enum(ids), locale }),
        annotations,
      },
      async ({ id, locale }) => {
        const doc = catalog.documents.find(
          (doc) => doc.id === id && doc.locale === locale,
        );
        return result({ ...summary(doc), markdown: doc.markdown });
      },
    );
    for (const doc of catalog.documents) {
      server.registerResource(
        `${doc.locale}-${doc.id}`,
        resourceUrl(doc),
        {
          title: doc.title,
          description: doc.description,
          mimeType: "text/markdown",
        },
        async (uri) => ({
          contents: [
            { uri: uri.href, mimeType: "text/markdown", text: doc.markdown },
          ],
        }),
      );
    }
    return server;
  };
  const handler = createMcpHandler(factory, {
    legacy: "stateless",
    responseMode: "json",
    maxRequestBodySize: 64 * 1024,
    maxSubscriptions: 8,
  });
  const serve = toNodeHandler(handler, { maxRequestBodySize: 64 * 1024 });
  const extraHosts = (process.env.MCP_ALLOWED_HOSTS || "")
    .split(",")
    .filter(Boolean);
  const validateHost = hostHeaderValidation([
    "localhost",
    "127.0.0.1",
    "[::1]",
    site.hostname,
    ...extraHosts,
  ]);
  const allowedOrigins = new Set([
    site.origin,
    `http://127.0.0.1:${port}`,
    `http://localhost:${port}`,
    ...(process.env.MCP_ALLOWED_ORIGINS || "").split(",").filter(Boolean),
  ]);
  return {
    close: () => handler.close(),
    async handle(req, res) {
      if (!validateHost(req, res)) return;
      const origin = req.headers.origin;
      if (origin && !allowedOrigins.has(origin)) {
        res.writeHead(403);
        return res.end("Origin not allowed");
      }
      if (origin) {
        res.setHeader("Access-Control-Allow-Origin", origin);
        res.setHeader("Vary", "Origin");
        res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        res.setHeader(
          "Access-Control-Allow-Headers",
          "Content-Type, Accept, MCP-Protocol-Version, MCP-Session-Id",
        );
      }
      res.setHeader("Cache-Control", "no-store");
      if (req.method === "OPTIONS") {
        res.writeHead(204);
        return res.end();
      }
      await serve(req, res);
    },
  };
}
