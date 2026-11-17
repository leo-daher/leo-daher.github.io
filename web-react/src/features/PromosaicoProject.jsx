import { usePortfolio } from "../context.jsx";
import { Icon } from "../components/Icon.jsx";
import projects from "../data/project-highlights.generated.json";
import "./promosaico-project.css";

const project = projects.find((item) => item.id === "radar-ofertas");

export function PromosaicoProject() {
  const { locale, t } = usePortfolio();
  return (
    <section
      id="promosaico"
      className="promosaico-highlight section-frame"
      aria-labelledby="promosaico-title"
    >
      <div className="promosaico-card">
        <div className="promosaico-project-copy">
          <p className="eyebrow">{t("personalProject")}</p>
          <h2 id="promosaico-title">{project.name}</h2>
          <p>{project.description[locale]}</p>
        </div>
        <div className="promosaico-project-links">
          <a
            className="promosaico-app-link"
            href={project.appStoreHref}
            target="_blank"
            rel="noreferrer"
          >
            {t("promosaicoAppStore")}
            <Icon name="external" size={18} />
          </a>
          <a href={project.href} target="_blank" rel="noreferrer">
            {t("promosaicoWebsite")}
            <Icon name="external" size={18} />
          </a>
        </div>
      </div>
    </section>
  );
}
