import { useEffect, useRef, useState } from "react";
import { usePortfolio } from "../context.jsx";
import { Icon } from "../components/Icon.jsx";
import projects from "../data/project-highlights.generated.json";
import initialSnapshot from "../data/recomp-metrics.snapshot.json";
import {
  newerSnapshot,
  RECOMP_METRICS_ENDPOINT,
} from "../data/recomp-metrics.js";
import "./recomp-project.css";

const project = projects.find((item) => item.id === "recomp-center");

function useCount(value, visible, reduceMotion) {
  const [display, setDisplay] = useState(value);
  const previous = useRef(null);
  useEffect(() => {
    if (!visible || reduceMotion) {
      setDisplay(value);
      return;
    }
    const from = previous.current ?? 0;
    previous.current = value;
    let frame;
    let started;
    const animate = (time) => {
      started ??= time;
      const progress = Math.min(1, (time - started) / 850);
      setDisplay(Math.round(from + (value - from) * (1 - (1 - progress) ** 3)));
      if (progress < 1) frame = requestAnimationFrame(animate);
    };
    frame = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frame);
  }, [value, visible, reduceMotion]);
  return display;
}

export function RecompProject() {
  const { locale, t, reduceMotion, staticRender } = usePortfolio();
  const [snapshot, setSnapshot] = useState(initialSnapshot);
  const [visible, setVisible] = useState(false);
  const section = useRef(null);
  const language = locale === "pt" ? "pt-BR" : "en";
  const count = useCount(snapshot.metrics.visits, visible, reduceMotion);
  const number = new Intl.NumberFormat(language, {
    notation: "compact",
    maximumFractionDigits: 2,
  });
  const date = (value) =>
    new Intl.DateTimeFormat(language, {
      day: "numeric",
      month: "short",
      year: "numeric",
    }).format(new Date(value.length === 10 ? `${value}T12:00:00Z` : value));
  const period =
    snapshot.period.kind === "cumulative"
      ? t("recompMetricsSince", { date: date(snapshot.period.start) })
      : t("recompMetricsLast30Days");

  useEffect(() => {
    if (staticRender) return;
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setVisible(true);
          observer.disconnect();
        }
      },
      { rootMargin: "160px" },
    );
    observer.observe(section.current);
    return () => observer.disconnect();
  }, [staticRender]);

  useEffect(() => {
    if (staticRender || !visible) return;
    let controller;
    let mounted = true;
    async function update() {
      if (document.hidden) return;
      controller?.abort();
      controller = new AbortController();
      const request = controller;
      const timeout = setTimeout(() => request.abort(), 6000);
      try {
        const response = await fetch(RECOMP_METRICS_ENDPOINT, {
          credentials: "omit",
          signal: request.signal,
        });
        if (!response.ok) return;
        const text = await response.text();
        if (text.length > 8192) return;
        const incoming = JSON.parse(text);
        if (mounted) setSnapshot((current) => newerSnapshot(current, incoming));
      } catch {
        // Keep the last verified values and their original observation date.
      } finally {
        clearTimeout(timeout);
      }
    }
    update();
    const timer = setInterval(update, 5 * 60_000);
    document.addEventListener("visibilitychange", update);
    return () => {
      mounted = false;
      clearInterval(timer);
      controller?.abort();
      document.removeEventListener("visibilitychange", update);
    };
  }, [visible, staticRender]);

  return (
    <section
      ref={section}
      id="recomp-center"
      className="recomp-highlight section-frame"
      aria-label={t("recompProjectLabel")}
    >
      <div className="recomp-card">
        <div className="recomp-project-copy">
          <p className="eyebrow">RECOMP.CENTER</p>
          <h2>{project.name}</h2>
          <p>{project.description[locale]}</p>
          <a href={project.href} target="_blank" rel="noreferrer">
            {t("recompExploreCatalog")}
            <Icon name="external" size={18} />
          </a>
        </div>
        <div className="recomp-metrics">
          <strong className="recomp-metric-value" aria-hidden="true">
            ≈ {number.format(count)}
          </strong>
          <span className="recomp-metric-label" aria-hidden="true">
            {t("recompVisits")}
          </span>
          <span className="sr-only" aria-live="polite">
            {t("recompVisitsAccessible", {
              count: new Intl.NumberFormat(language).format(
                snapshot.metrics.visits,
              ),
            })}
          </span>
          <p className="recomp-secondary-metric">
            {t("recompRequests", {
              count: number.format(snapshot.metrics.requests),
            })}
          </p>
        </div>
        <div className="recomp-metrics-source">
          <span>{period} · Cloudflare</span>
          <span>
            {t("recompMetricsChecked", { date: date(snapshot.asOf) })}
          </span>
        </div>
        <details className="recomp-metrics-details">
          <summary>{t("recompAboutMetrics")}</summary>
          <p>{t("recompMetricsLimits")}</p>
          {snapshot.period.kind === "cumulative" && (
            <p>{t("recompCumulativeLimits")}</p>
          )}
        </details>
      </div>
    </section>
  );
}
