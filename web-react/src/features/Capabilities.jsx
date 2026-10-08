import { routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import { CAPABILITIES } from "../data/capabilities.js";
import "./capabilities.css";

export function Capabilities() {
  const { t, locale } = usePortfolio();
  return (
    <section id="system" className="section-frame architecture capabilities">
      <SectionHeading title={t("systemTitle")} />
      <div className="architecture-grid">
        {CAPABILITIES.map(([name, path], index) => (
          <article className="architecture-scope" key={name}>
            <span aria-hidden="true">{String(index + 1).padStart(2, "0")}</span>
            <div className="capability-content">
              <h3>{t(`architecture${name}Title`)}</h3>
              <p className="capability-copy">{t(`architecture${name}Copy`)}</p>
              <p className="capability-stack">
                {t(`architecture${name}Detail`)}
              </p>
              <a className="capability-link" href={routeHref(path, locale)}>
                <span>{t(`architecture${name}Link`)}</span>
                <Icon name="arrow-right" size={17} />
              </a>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
