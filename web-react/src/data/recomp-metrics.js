export const RECOMP_METRICS_ENDPOINT =
  "https://recomp-portfolio-metrics.leonedaher.workers.dev/metrics";

export function isMetricsSnapshot(value) {
  const date = (text) =>
    typeof text === "string" &&
    /^\d{4}-\d{2}-\d{2}(?:T[\d:.]+Z)?$/.test(text) &&
    Number.isFinite(Date.parse(text));
  if (
    !value ||
    value.schemaVersion !== 1 ||
    value.project !== "recomp-center" ||
    value.source !== "Cloudflare Analytics" ||
    value.approximate !== true ||
    value.includesAutomatedTraffic !== true ||
    value.coverageComplete !== true ||
    !["manual", "automatic"].includes(value.collection) ||
    !date(value.asOf) ||
    Date.parse(value.asOf) > Date.now() + 60_000 ||
    ![value.metrics?.visits, value.metrics?.requests].every(
      (number) => Number.isSafeInteger(number) && number >= 0,
    )
  )
    return false;
  const period = value.period;
  return (
    (period?.kind === "rolling" && period.days === 30) ||
    (period?.kind === "cumulative" &&
      date(period.start) &&
      date(period.end) &&
      Date.parse(period.start) <= Date.parse(period.end) &&
      Date.parse(period.end) <= Date.parse(value.asOf))
  );
}

export function newerSnapshot(current, incoming) {
  if (!isMetricsSnapshot(incoming)) return current;
  if (Date.parse(incoming.asOf) < Date.parse(current.asOf)) return current;
  if (current.collection === "automatic" && incoming.collection !== "automatic")
    return current;
  // Source corrections can legitimately decrease an estimate.
  return incoming;
}
