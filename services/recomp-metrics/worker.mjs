import { readSnapshot, synchronizeMetrics } from "./metrics.mjs";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
  "X-Content-Type-Options": "nosniff",
};

export default {
  async fetch(request, env) {
    const path = new URL(request.url).pathname;
    if (!["/metrics", "/health"].includes(path))
      return new Response("Not found", { status: 404, headers: cors });
    if (request.method === "OPTIONS")
      return new Response(null, { status: 204, headers: cors });
    if (!["GET", "HEAD"].includes(request.method))
      return new Response("Method not allowed", {
        status: 405,
        headers: { ...cors, Allow: "GET, HEAD, OPTIONS" },
      });
    try {
      const snapshot = await readSnapshot(env);
      const result =
        path === "/health"
          ? { status: snapshot.collection, asOf: snapshot.asOf }
          : snapshot;
      return new Response(
        request.method === "HEAD" ? null : JSON.stringify(result),
        {
          headers: {
            ...cors,
            "Content-Type": "application/json; charset=utf-8",
            "Cache-Control": "public, max-age=300, stale-while-revalidate=3600",
          },
        },
      );
    } catch {
      return new Response("Metrics unavailable", {
        status: 503,
        headers: { ...cors, "Cache-Control": "no-store" },
      });
    }
  },
  async scheduled(_event, env, context) {
    context.waitUntil(
      synchronizeMetrics(env).catch(() => {
        // Never log upstream bodies, credentials or visitor data.
        console.error("Recomp metrics synchronization failed");
        throw new Error("metrics_sync_failed");
      }),
    );
  },
};
