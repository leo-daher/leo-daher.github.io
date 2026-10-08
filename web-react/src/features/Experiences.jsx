import { assetUrl, routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import { EXPERIENCES, FEATURED_EXPERIENCES } from "../data/experiences.js";
import "./experiences.css";

function ExperienceHeading({ item, level = 3, preview = false }) {
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
          <p className="experience-engagement">
            {item.consulting && !preview
              ? t("experienceViaConsulting")
              : copy.area}
          </p>
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
        {EXPERIENCES.map((item) => (
          <article id={item.id} className="experience-record" key={item.id}>
            <ExperienceHeading item={item} level={2} />
            <h3 className="experience-contribution-label">
              {t("appContributionLabel")}
            </h3>
            <ul>
              {item[locale].contributions.map((contribution) => (
                <li key={contribution}>{contribution}</li>
              ))}
            </ul>
            <p
              className="experience-stack"
              aria-label={`${t("appStackLabel")}: ${item.stack.join(", ")}`}
            >
              {item.stack.join(" · ")}
            </p>
          </article>
        ))}
      </div>
      <a className="experience-view-all" href={routeHref("/apps", locale)}>
        {t("experiencePublishedApps")} <Icon name="arrow-right" size={20} />
      </a>
    </section>
  );
}
