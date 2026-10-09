import { assetUrl, routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import { EXPERIENCES, FEATURED_EXPERIENCES } from "../data/experiences.js";
import { experienceProjects } from "../data/project-links.js";
import "./experiences.css";

function ExperienceHeading({
  item,
  level = 3,
  preview = false,
  minimal = false,
}) {
  const { locale, t } = usePortfolio();
  const copy = item[locale];
  const Heading = level === 2 ? "h2" : "h3";
  return (
    <>
      <div className="experience-company">
        <span
          className={`experience-logo experience-logo--${item.id}`}
          aria-hidden="true"
        >
          <img
            src={assetUrl(`/assets/client_logos/${item.logo}`)}
            alt={item.company}
            loading="lazy"
          />
        </span>
        <div>
          <p className="experience-company-name">{item.company}</p>
          {!minimal && (
            <p className="experience-engagement">
              {item.consulting && !preview
                ? t("experienceViaConsulting")
                : copy.area}
            </p>
          )}
        </div>
      </div>
      {item.consulting && !preview && (
        <p className="experience-area">{copy.area}</p>
      )}
      <Heading>{copy.title}</Heading>
      <p className="experience-summary">{copy.summary}</p>
    </>
  );
}

function ExperienceProjects({ item }) {
  const { locale, t } = usePortfolio();
  const projects = experienceProjects(item);
  if (!projects.length) return null;
  const headingId = `${item.id}-projects-title`;
  return (
    <nav className="experience-projects" aria-labelledby={headingId}>
      <h3 id={headingId}>{t("projects")}</h3>
      <ul className="experience-project-list">
        {projects.map((project) => (
          <li key={project.id}>
            <a
              className="experience-project-link"
              href={routeHref(project.path, locale)}
            >
              <span
                className={`experience-project-logo ${project.style || ""} ${project.logo.startsWith("/assets/apps/") ? "experience-project-logo--app" : ""}`}
                aria-hidden="true"
              >
                <img
                  src={assetUrl(project.logo)}
                  alt={project.company}
                  loading="lazy"
                />
              </span>
              <span className="experience-project-copy">
                <span className="experience-project-company">
                  {project.company}
                </span>
                <span className="experience-project-title">
                  {project[locale]}
                </span>
              </span>
              <Icon name="arrow-right" size={18} />
            </a>
          </li>
        ))}
      </ul>
    </nav>
  );
}

export function ExperiencesSection() {
  const { locale, t } = usePortfolio();
  return (
    <section id="experience" className="section-frame experiences-section">
      <SectionHeading
        eyebrow={t("professionalExperienceEyebrow")}
        title={t("professionalExperienceTitle")}
        copy={t("professionalExperienceCopy")}
        copyBelowTitle
      />
      <div className="experience-featured-grid">
        {FEATURED_EXPERIENCES.map((item) => (
          <a
            key={item.id}
            className="experience-preview"
            href={`${routeHref("/experiencias", locale)}#${item.id}`}
          >
            <ExperienceHeading item={item} preview />
            <span className="experience-preview-footer">
              <span>{item.stack.slice(0, 3).join(" · ")}</span>
              <Icon name="arrow-right" size={20} />
            </span>
          </a>
        ))}
      </div>
      <a
        className="experience-view-all"
        href={routeHref("/experiencias", locale)}
      >
        {t("viewAllExperiences")} <Icon name="arrow-right" size={20} />
      </a>
    </section>
  );
}

export function ExperiencesPage() {
  const { locale, t } = usePortfolio();
  return (
    <section className="section-frame experiences-page">
      <SectionHeading
        level={1}
        eyebrow={t("professionalExperienceEyebrow")}
        title={t("allExperiencesTitle")}
        copy={t("allExperiencesCopy")}
        copyBelowTitle
      />
      <div className="experience-records">
        {EXPERIENCES.map((item) => {
          const contributions = item[locale].contributions;
          return (
            <article
              id={item.id}
              className={`experience-record${item.id === "conkord" ? " experience-record--consultancy" : ""}`}
              key={item.id}
            >
              <ExperienceHeading
                item={item}
                level={2}
                minimal={item.id === "radix"}
              />
              {item.id !== "conkord" && contributions.length > 0 && (
                <>
                  <h3 className="experience-contribution-label">
                    {t("appContributionLabel")}
                  </h3>
                  <ul>
                    {contributions.map((contribution) => (
                      <li key={contribution}>{contribution}</li>
                    ))}
                  </ul>
                </>
              )}
              {item.stack.length > 0 && (
                <p
                  className="experience-stack"
                  aria-label={`${t("appStackLabel")}: ${item.stack.join(", ")}`}
                >
                  {item.stack.join(" · ")}
                </p>
              )}
              {item.id === "conkord" && <ExperienceProjects item={item} />}
            </article>
          );
        })}
      </div>
      <a className="experience-view-all" href={routeHref("/apps", locale)}>
        {t("experiencePublishedApps")} <Icon name="arrow-right" size={20} />
      </a>
    </section>
  );
}
