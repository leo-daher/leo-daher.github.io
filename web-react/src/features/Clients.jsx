import { assetUrl, routeHref, usePortfolio } from "../context.jsx";
import { SectionHeading } from "../components/SectionHeading.jsx";
import { Icon } from "../components/Icon.jsx";
import { EXPERIENCES } from "../data/experiences.js";
import "./clients.css";

const direct = [
  ["MAG Seguros", "mag-official.svg"],
  ["Human Robotics", "human_robotics.png", "outline"],
  ["Visagio", "visagio.svg", "visagio"],
  ["Radix", "radix.png"],
  ["Conkord", "conkord-official.svg"],
];
const indirect = [
  ["Van Cranenbroek", "van-cranenbroek-full.svg"],
  ["Lyzer", "lyzer-official.svg", "outline"],
  ["CTT", "ctt-official.svg"],
  ["EY", "ey-official.svg", "outline"],
  ["Iberdrola", "iberdrola-official.svg"],
  ["Água Monchique", "agua-monchique-official.svg", "outline"],
  ["Fullsix", "fullsix-black.png", "mono fullsix"],
  ["Code 495", "code-495-symbol.svg", "code"],
  ["Ascendi", "ascendi-official.png", "outline"],
];
const other = [["Águas de Portugal", "adp-official.svg", "outline"]];

function clientPath(name, file) {
  const experience = EXPERIENCES.find((item) => item.logo === file);
  if (experience) return `/experiencias#${experience.id}`;
  return {
    "MAG Seguros": "/apps/mag-venda-digital",
    "Van Cranenbroek": "/apps/van-cranenbroek",
  }[name];
}

export function Clients() {
  const { t, locale } = usePortfolio();
  const brandLabel = locale === "pt" ? "MARCA" : "BRAND";
  return (
    <section id="clients" className="section-frame clients">
      <SectionHeading title={t("clientsTitle")} />
      {[
        ["directRoles", direct],
        ["viaLatituddeConsulting", indirect],
        ["otherExperiences", other],
      ].map(([title, logos]) => (
        <div className={`client-group client-group--${title}`} key={title}>
          <div className="client-group-label">
            <h3>{t(title)}</h3>
            <span>
              {logos.length} {brandLabel}
              {logos.length === 1 ? "" : "S"}
            </span>
          </div>
          <div className="clients-grid">
            {logos.map(([name, file, style = ""]) => {
              const path = clientPath(name, file);
              const Tile = path ? "a" : "div";
              return (
                <Tile
                  className={`client-tile ${style} ${path ? "client-tile--link" : "client-tile--brand"}`}
                  key={name}
                  href={path ? routeHref(path, locale) : undefined}
                  aria-label={
                    path ? `${t("viewClientExperience")}: ${name}` : undefined
                  }
                >
                  <span className="client-mark">
                    <img
                      src={assetUrl("/assets/client_logos/" + file)}
                      alt={name}
                      loading="lazy"
                    />
                    {style === "code" && <span>Code 495</span>}
                  </span>
                  {path ? (
                    <Icon
                      className="client-tile-arrow"
                      name="arrow-right"
                      size={15}
                    />
                  ) : (
                    <span className="client-brand-name">{name}</span>
                  )}
                </Tile>
              );
            })}
          </div>
        </div>
      ))}
    </section>
  );
}
