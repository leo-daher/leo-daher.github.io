import { readFile } from "node:fs/promises";
import { APP_ITEMS, APP_CASES } from "../src/data/apps.js";

const webRoot = new URL("../", import.meta.url);
const schemaContext = "https://schema.org";
const locales = ["en", "pt"];
const readPublicJson = async (path) =>
  JSON.parse(await readFile(new URL(path, webRoot), "utf8"));
const inline = (text) => text.replace(/\s+/g, " ").trim();
const label = (text) =>
  inline(text)
    .replaceAll("\\", "\\\\")
    .replaceAll("[", "\\[")
    .replaceAll("]", "\\]");
const link = (text, href) => `[${label(text)}](${href})`;
const localPath = (path, locale) =>
  locale === "pt" ? `/pt${path === "/" ? "/" : path}` : path;
const languageCode = (locale) => (locale === "pt" ? "pt-BR" : "en");

export function normalizeBasePath(basePath = "/") {
  if (
    typeof basePath !== "string" ||
    !basePath.startsWith("/") ||
    /[?#\\]/.test(basePath)
  )
    throw new Error("basePath must be an absolute URL pathname.");
  if (
    basePath
      .split("/")
      .some((segment) => [".", ".."].includes(decodeURIComponent(segment)))
  )
    throw new Error("basePath cannot contain traversal segments.");
  return `/${basePath.split("/").filter(Boolean).join("/")}${basePath.split("/").filter(Boolean).length ? "/" : ""}`;
}

function urlFactory(basePath, siteOrigin) {
  const base = normalizeBasePath(basePath);
  const origin = new URL(siteOrigin);
  if (
    !["https:", "http:"].includes(origin.protocol) ||
    origin.username ||
    origin.password ||
    origin.pathname !== "/" ||
    origin.search ||
    origin.hash
  )
    throw new Error("siteOrigin must be an HTTP(S) origin.");
  return (path) =>
    new URL(`${base}${path.replace(/^\//, "")}`, origin.origin).href;
}

async function loadContacts() {
  // Read the interface's existing public URLs without executing its React module.
  const source = await readFile(new URL("src/context.jsx", webRoot), "utf8");
  const block = source.match(/export const contactLinks\s*=\s*\{([\s\S]*?)\};/);
  if (!block)
    throw new Error(
      "Public contact links could not be read from the interface.",
    );
  const contacts = Object.fromEntries(
    [...block[1].matchAll(/([a-zA-Z]+)\s*:\s*["']([^"']+)["']/g)].map(
      (match) => [match[1], match[2]],
    ),
  );
  for (const key of ["linkedin", "whatsapp", "github", "schedule"]) {
    if (
      !contacts[key] ||
      !["https:", "http:"].includes(new URL(contacts[key]).protocol)
    )
      throw new Error(`Missing public contact: ${key}`);
  }
  return contacts;
}

const interpretationTemplate = {
  pt: [
    "A contagem de {count} apps corresponde ao inventário de entregas Android e iOS da Latitudde/Conkord. MAG Venda Digital não é somado a essa contagem; ela não representa {count} produtos de autoria individual.",
    "Os cases registram a atuação e a contribuição de Leone em equipes. A existência de um app na loja comprova o produto publicado, mas não estabelece autoria exclusiva ou responsabilidade por todo o produto.",
    "As métricas de loja são retratos consultados em julho de 2026. Valores com + e resumos arredondados, como 11,5 mil+, não são contagens exatas nem medidas atuais; avaliações, downloads e disponibilidade podem mudar.",
    "Certificados comprovam a conclusão dos cursos descritos. Não equivalem, por si só, a experiência profissional, domínio de uma tecnologia ou fluência atual.",
    "A evidência MAG registra uma entrega coletiva. A publicação pública selecionada não informa URL nem data do post; esses dados permanecem desconhecidos.",
  ],
  en: [
    "The {count}-app count belongs to the Latitudde/Conkord inventory of Android and iOS deliveries. MAG Venda Digital is excluded; the count does not mean {count} individually authored products.",
    "Case studies describe Leone's role and contribution within teams. A store listing supports the existence of a published product, but does not establish sole authorship or responsibility for the entire product.",
    "Store metrics are snapshots checked in July 2026. Values with + and rounded summaries such as 11.5K+ are not exact counts or current measurements; ratings, downloads, and availability may change.",
    "Certificates document completion of the listed courses. They do not, on their own, establish professional experience, technology mastery, or current language fluency.",
    "The MAG evidence records a collective delivery. The selected public record provides neither a post URL nor a post date; those details remain unknown.",
  ],
};

function personSchema(profile, t) {
  return {
    "@type": "Person",
    "@id": `${profile.url}#person`,
    name: profile.name,
    url: profile.url,
    jobTitle: [t("softwareEngineer"), t("aiAutomationEngineer")],
    sameAs: profile.sameAs,
    knowsAbout: profile.skills,
  };
}

function applicationSchema(item, app, locale, t, url, person) {
  const stores = app.stores.filter((store) => store.productId === item.id);
  const path = localPath(`/apps/${item.id}`, locale);
  return {
    "@type": "SoftwareApplication",
    "@id": `${url(`${path}/`)}#application`,
    name: item.name,
    url: url(`${path}/`),
    description: t(item.summary),
    inLanguage: languageCode(locale),
    operatingSystem: [
      ...new Set(
        stores.map((store) =>
          store.store === "Google Play" ? "Android" : "iOS",
        ),
      ),
    ],
    installUrl: stores.map((store) => store.href),
    sameAs: stores.map((store) => store.href),
    image: url(`/assets/apps/${item.icons[0]}`),
    screenshot: app.screenshots
      .filter((shot) => shot.app === item.name)
      .map((shot) => url(`/assets/apps/${shot.image}`)),
    contributor: {
      "@type": "Person",
      "@id": person["@id"],
      name: person.name,
      url: person.url,
    },
  };
}

function localizedLabels(locale) {
  return locale === "pt"
    ? {
        overview: "Perfil e atuação",
        boundaries: "Proveniência e limites",
        storeSummary: "Resumo publicado",
        scope: "Contexto",
        sharedCase: "Case compartilhado",
        sources: "Fontes públicas",
        screenshots: "Imagens oficiais da loja",
        completed: "Conclusão",
        holder: "Titular",
        checked: "Verificação registrada",
        credentialImage: "Imagem oficial do certificado",
        credentialsSource: "Catálogo público de certificações",
        sourceUi: "Página do portfólio",
        recognitionSource: "Registro público da entrega coletiva",
        publication: "Publicado em",
        contact: "Contato",
        navigation: "Navegação",
        unknown: "não informado",
      }
    : {
        overview: "Profile and role",
        boundaries: "Provenance and limits",
        storeSummary: "Published summary",
        scope: "Context",
        sharedCase: "Shared case study",
        sources: "Public sources",
        screenshots: "Official store images",
        completed: "Completed",
        holder: "Holder",
        checked: "Recorded verification",
        credentialImage: "Official certificate image",
        credentialsSource: "Public certificate catalog",
        sourceUi: "Portfolio page",
        recognitionSource: "Public record of the collective delivery",
        publication: "Published",
        contact: "Contact",
        navigation: "Navigation",
        unknown: "not provided",
      };
}

function documentRecord({
  id,
  locale,
  path,
  title,
  description,
  lines,
  schema,
}) {
  return {
    id,
    locale,
    path,
    title,
    description,
    markdown: `${lines
      .filter((line) => line !== undefined)
      .join("\n\n")
      .trim()}\n`,
    schema,
  };
}

function profileDocument(profile, locale, t, url, interpretation) {
  const words = localizedLabels(locale),
    person = personSchema(profile, t);
  const path = localPath("/", locale);
  const lines = [
    `# ${profile.name}`,
    `> ${t("softwareEngineer")} · ${t("aiAutomationEngineer")}`,
    t("mobileSupporting"),
    t("aiSupporting"),
    `## ${words.overview}`,
    `- ${t("yearsBuildingSoftware")}\n- ${t("proofAppsValue")} ${inline(t("proofAppsLabel"))}\n- ${t("proofMarketsLabel")}: ${t("proofMarketsValue")}`,
    `## ${t("systemTitle")}`,
    ...["Product", "Services", "Delivery", "Automation"].map(
      (scope) =>
        `### ${t(`architecture${scope}Title`)}\n\n${t(`architecture${scope}Detail`)}`,
    ),
    `## ${t("featuredAppsTitle")}`,
    t("featuredAppsSupportingText"),
    APP_ITEMS.map(
      (item) =>
        `- ${link(item.name, url(`${localPath(`/apps/${item.id}`, locale)}/`))}: ${t(item.summary)} ${t(item.metric)}`,
    ).join("\n"),
    `## ${t("certificationsEyebrow")}`,
    t("certificationsCopy"),
    link(
      t("certificateRegister"),
      url(`${localPath("/certificacoes", locale)}/`),
    ),
    `## ${t("articlesEyebrow")}`,
    t("articlesCopy"),
    `${link(t("identityArticleTitle"), url(`${localPath("/artigos/identidade-visual", locale)}/`))}: ${t("identityArticleSummary")}`,
    `## ${words.contact}`,
    t("contactCopy"),
    Object.entries(profile.contacts)
      .map(
        ([name, href]) =>
          `- ${link({ linkedin: t("contactLinkedIn"), whatsapp: t("contactWhatsApp"), github: t("contactGitHub"), schedule: t("contactSchedule") }[name], href)}`,
      )
      .join("\n"),
    `## ${words.boundaries}`,
    interpretation[locale].map((note) => `- ${note}`).join("\n"),
    `## ${words.sources}`,
    link(words.sourceUi, url(path)),
  ];
  return documentRecord({
    id: "profile",
    locale,
    path,
    title: t("appTitle"),
    description: `${t("mobileSupporting")} ${t("aiSupporting")}`,
    lines,
    schema: {
      "@context": schemaContext,
      "@type": "ProfilePage",
      "@id": url(path),
      url: url(path),
      name: t("appTitle"),
      description: `${t("mobileSupporting")} ${t("aiSupporting")}`,
      inLanguage: languageCode(locale),
      mainEntity: person,
    },
  });
}

function appsDocument(locale, t, url, applications, interpretation) {
  const words = localizedLabels(locale),
    path = localPath("/apps", locale);
  return documentRecord({
    id: "apps",
    locale,
    path,
    title: t("allAppsTitle"),
    description: t("allAppsSupportingText"),
    lines: [
      `# ${t("allAppsTitle")}`,
      t("allAppsSupportingText"),
      ...APP_ITEMS.map((item) =>
        [
          `## ${link(item.name, url(`${localPath(`/apps/${item.id}`, locale)}/`))}`,
          t(item.summary),
          `**${words.storeSummary}:** ${t(item.metric)}`,
          t("storeCheckedJuly2026"),
        ].join("\n\n"),
      ),
      `## ${words.boundaries}`,
      interpretation[locale]
        .slice(0, 3)
        .map((note) => `- ${note}`)
        .join("\n"),
      `## ${words.sources}`,
      link(words.sourceUi, url(`${path}/`)),
    ],
    schema: {
      "@context": schemaContext,
      "@type": "ItemList",
      "@id": url(`${path}/`),
      name: t("allAppsTitle"),
      description: t("allAppsSupportingText"),
      url: url(`${path}/`),
      inLanguage: languageCode(locale),
      numberOfItems: applications.length,
      itemListElement: applications.map((item, index) => ({
        "@type": "ListItem",
        position: index + 1,
        item,
      })),
    },
  });
}

function appDocument(
  item,
  app,
  locale,
  t,
  url,
  application,
  magEvidence,
  interpretation,
) {
  const words = localizedLabels(locale),
    path = localPath(`/apps/${item.id}`, locale);
  const lines = [
    `# ${item.name}`,
    t(item.summary),
    `**${words.storeSummary}:** ${t(item.metric)}`,
    t("storeCheckedJuly2026"),
    ...(app.name !== item.name
      ? [`## ${words.sharedCase}: ${app.name}`, t(`${app.prefix}Summary`)]
      : []),
    `## ${words.scope}`,
    t(`${app.prefix}Context`),
    `## ${t("appRoleLabel")}`,
    t(`${app.prefix}Role`),
    `## ${t("appContributionLabel")}`,
    t(`${app.prefix}Contribution`),
    `## ${t("appStackLabel")}`,
    app.stack.join(" · "),
    `## ${t("appStoreProofLabel")}`,
    ...app.stores.map(
      (proof) =>
        `- ${link(`${proof.product ? `Lyzer ${proof.product} · ` : ""}${proof.store}`, proof.href)}${proof.evidence ? `: ${t(proof.evidence)}` : ""}${proof.date ? ` — ${t(proof.date)}` : ""}`,
    ),
    `## ${words.screenshots}`,
    ...app.screenshots.map(
      (shot) =>
        `![${label(`${shot.app} · ${t("appScreenshotsLabel")} ${shot.index}`)}](${url(`/assets/apps/${shot.image}`)})`,
    ),
    ...(app.recognition
      ? [
          `## ${t("magRecognitionTitle")}`,
          t("magRecognitionText"),
          `![${label(t("magRecognitionImageLabel"))}](${url("/assets/evidence/mag-venda-digital-reconhecimento-facial.png")})`,
          `${locale === "pt" ? "Autor da publicação" : "Post author"}: ${magEvidence.author}. ${locale === "pt" ? "Data do post" : "Post date"}: ${magEvidence.postDate || words.unknown}. ${locale === "pt" ? "URL do post" : "Post URL"}: ${magEvidence.postUrl || words.unknown}.`,
          link(
            words.recognitionSource,
            url(
              "/assets/evidence/mag-venda-digital-reconhecimento-facial.json",
            ),
          ),
        ]
      : []),
    `## ${words.boundaries}`,
    interpretation[locale]
      .filter((_, index) => index < 3 || (app.recognition && index === 4))
      .map((note) => `- ${note}`)
      .join("\n"),
    `## ${words.sources}`,
    link(words.sourceUi, url(`${path}/`)),
  ];
  return documentRecord({
    id: item.id,
    locale,
    path,
    title: item.name,
    description: t(item.summary),
    lines,
    schema: { "@context": schemaContext, ...application },
  });
}

function certificateDocument(records, locale, t, url, interpretation) {
  const words = localizedLabels(locale),
    path = localPath("/certificacoes", locale);
  const groups = Map.groupBy(records, (record) =>
    record.completed_on.slice(0, 4),
  );
  const lines = [
    `# ${t("certificateRegister")}`,
    t("certificateRegisterCopy"),
    t("certificationsCopy"),
    `## ${words.boundaries}`,
    interpretation[locale][3],
    ...[...groups]
      .sort(([a], [b]) => b.localeCompare(a))
      .flatMap(([year, certificates]) => [
        `## ${year}`,
        ...certificates.map((record) =>
          [
            `### ${record.title}`,
            `- ${t("issuedBy").replace("{issuer}", record.issuer)}\n- ${words.holder}: ${record.holder}\n- ${words.completed}: ${record.completed_on}\n- ${t("technologies")}: ${record.technologies.join(" · ")}\n- ${words.checked}: ${record.verified_on} (${record.verification_status})`,
            `${link(t("verifyCredential"), record.verification_url)} · ${link(words.credentialImage, url(`/${record.artifacts.image.path}`))}`,
          ].join("\n\n"),
        ),
      ]),
    `## ${words.sources}`,
    `${link(words.credentialsSource, url("/assets/certificates/catalog.json"))}\n\n${link(words.sourceUi, url(`${path}/`))}`,
  ];
  return documentRecord({
    id: "certificates",
    locale,
    path,
    title: t("certificateRegister"),
    description: t("certificateRegisterCopy"),
    lines,
    schema: {
      "@context": schemaContext,
      "@type": "ItemList",
      "@id": url(`${path}/`),
      url: url(`${path}/`),
      name: t("certificateRegister"),
      description: t("certificationsCopy"),
      inLanguage: languageCode(locale),
      numberOfItems: records.length,
      itemListElement: records.map((record, index) => ({
        "@type": "ListItem",
        position: index + 1,
        item: {
          "@type": "Thing",
          name: record.title,
          url: record.verification_url,
          image: url(`/${record.artifacts.image.path}`),
          description: `${t("issuedBy").replace("{issuer}", record.issuer)}. ${t("technologies")}: ${record.technologies.join(", ")}.`,
        },
      })),
    },
  });
}

function articleDocument(locale, t, url, person, publishedAt) {
  const path = localPath("/artigos/identidade-visual", locale),
    words = localizedLabels(locale);
  const timeZone = "America/Sao_Paulo",
    language = locale === "pt" ? "pt-BR" : "en-US";
  const date = new Intl.DateTimeFormat(language, {
    year: "numeric",
    month: "short",
    day: "numeric",
    timeZone,
  }).format(new Date(publishedAt));
  const time = new Intl.DateTimeFormat(language, {
    hour: "numeric",
    minute: "2-digit",
    timeZone,
  }).format(new Date(publishedAt));
  const publishedLabel = t("articlePublishedAt")
    .replace("{date}", date)
    .replace("{time}", time)
    .replace("{timeZone}", "BRT");
  const bodyKeys = [
    "identityArticleIntro",
    "identityArticleStructureBody",
    "identityArticleFabBody",
    "identityArticleFabColorBody",
    "identityArticleMotionBody",
    "identityArticleMotionEffectBody",
    "identityArticleConclusion",
  ];
  return documentRecord({
    id: "visual-identity",
    locale,
    path,
    title: t("identityArticleTitle"),
    description: t("identityArticleSummary"),
    lines: [
      `# ${t("identityArticleTitle")}`,
      `> ${t("identityArticleSummary")}`,
      publishedLabel,
      `![${label(t("identityArticleLogoSemantics"))}](${url("/assets/brand/ld-mark.svg")})`,
      t("identityArticleLogoCaption"),
      t("identityArticleIntro"),
      `## ${t("identityArticleStructureTitle")}`,
      t("identityArticleStructureBody"),
      `${t("identityArticleExplodedCaption")} ${t("identityArticleExplodedSemantics")}`,
      [
        "identityArticleLLabel",
        "identityArticleDLabel",
        "identityArticleCutLabel",
        "identityArticleDotLabel",
      ]
        .map((key) => `- ${t(key)}`)
        .join("\n"),
      `## ${t("identityArticleFabTitle")}`,
      t("identityArticleFabBody"),
      t("identityArticleFabColorBody"),
      `${t("identityArticleFabCaption")} ${t("identityArticleFabSemantics")}`,
      `## ${t("identityArticleMotionTitle")}`,
      t("identityArticleMotionBody"),
      t("identityArticleMotionEffectBody"),
      `${t("identityArticleMotionCaption")} ${t("identityArticleMotionSemantics")}`,
      [
        "identityArticleOpeningLogoStage",
        "identityArticleOpeningExpansionStage",
        "identityArticleOpeningViewportStage",
        "identityArticleOpeningInterfaceStage",
      ]
        .map((key, index) => `${index + 1}. ${t(key)}`)
        .join("\n"),
      t("identityArticleConclusion"),
      `## ${words.sources}`,
      link(words.sourceUi, url(`${path}/`)),
    ],
    schema: {
      "@context": schemaContext,
      "@type": "Article",
      "@id": url(`${path}/`),
      url: url(`${path}/`),
      mainEntityOfPage: url(`${path}/`),
      headline: t("identityArticleTitle"),
      description: t("identityArticleSummary"),
      inLanguage: languageCode(locale),
      datePublished: publishedAt,
      author: {
        "@type": "Person",
        "@id": person["@id"],
        name: person.name,
        url: person.url,
      },
      image: url("/assets/brand/ld-mark.svg"),
      articleBody: bodyKeys.map(t).join("\n\n"),
    },
  });
}

/** Public, source-grounded content; no private career files are read. */
export async function loadPortfolioContent({
  basePath = "/",
  siteOrigin = "https://leo-daher.github.io",
} = {}) {
  const url = urlFactory(basePath, siteOrigin);
  const [pt, en, certificateCatalog, magEvidence, contacts, articleSource] =
    await Promise.all([
      readPublicJson("src/data/pt.json"),
      readPublicJson("src/data/en.json"),
      readPublicJson("public/assets/certificates/catalog.json"),
      readPublicJson(
        "public/assets/evidence/mag-venda-digital-reconhecimento-facial.json",
      ),
      loadContacts(),
      readFile(new URL("src/features/Articles.jsx", webRoot), "utf8"),
    ]);
  if (
    certificateCatalog.schema_version !== 1 ||
    !Array.isArray(certificateCatalog.certificates)
  )
    throw new Error("Unsupported public certificate catalog.");
  const records = [...certificateCatalog.certificates].sort((a, b) =>
    b.completed_on.localeCompare(a.completed_on),
  );
  const publishedAt = articleSource.match(
    /const publicationDate\s*=\s*new Date\(["']([^"']+)["']\)/,
  )?.[1];
  if (!publishedAt || Number.isNaN(Date.parse(publishedAt)))
    throw new Error("The public article publication date is missing.");
  const copy = { pt, en };
  const interpretation = Object.fromEntries(
    locales.map((locale) => [
      locale,
      interpretationTemplate[locale].map((note) =>
        note.replaceAll("{count}", copy[locale].proofAppsValue),
      ),
    ]),
  );
  if (magEvidence.postUrl || magEvidence.postDate) {
    interpretation.pt[4] =
      "A evidência MAG registra uma entrega coletiva. URL e data do post são reproduzidas quando estão presentes no registro público selecionado; campos ausentes permanecem desconhecidos.";
    interpretation.en[4] =
      "The MAG evidence records a collective delivery. The post URL and date are reproduced when present in the selected public record; missing fields remain unknown.";
  }
  const architectureSkills = [
    "Product",
    "Services",
    "Delivery",
    "Automation",
  ].flatMap((scope) => en[`architecture${scope}Detail`].split(" · "));
  const storefrontSkills = APP_ITEMS.flatMap((item) =>
    en[item.metric].split(" · ").slice(1),
  );
  const skills = [
    ...new Set([
      ...Object.values(APP_CASES).flatMap((app) => app.stack),
      ...architectureSkills,
      ...storefrontSkills,
    ]),
  ];
  const profile = {
    name: pt.appTitle.split(" — ")[0],
    url: url("/"),
    locales,
    defaultLocale: "en",
    roles: Object.fromEntries(
      locales.map((locale) => [
        locale,
        [copy[locale].softwareEngineer, copy[locale].aiAutomationEngineer],
      ]),
    ),
    description: Object.fromEntries(
      locales.map((locale) => [
        locale,
        `${copy[locale].mobileSupporting} ${copy[locale].aiSupporting}`,
      ]),
    ),
    contacts,
    sameAs: [contacts.linkedin, contacts.github],
    skills,
    metrics: [
      {
        id: "app-deliveries",
        value: Number(pt.proofAppsValue),
        labels: {
          pt: inline(pt.proofAppsLabel),
          en: inline(en.proofAppsLabel),
        },
        kind: "reported-delivery-inventory",
        scope: "Latitudde / Conkord",
        excludes: ["MAG Venda Digital"],
        limits: { pt: interpretation.pt[0], en: interpretation.en[0] },
        sources: [
          "src/data/pt.json#proofAppsValue",
          "src/data/en.json#proofAppsValue",
        ],
      },
      {
        id: "software-experience-headline",
        display: { pt: pt.yearsBuildingSoftware, en: en.yearsBuildingSoftware },
        kind: "published-headline",
        limits: {
          pt: "Texto público de apresentação, sem uma data de início ou cronologia individual especificada.",
          en: "Public introduction headline, without a specified start date or individual timeline.",
        },
        sources: [
          "src/data/pt.json#yearsBuildingSoftware",
          "src/data/en.json#yearsBuildingSoftware",
        ],
      },
      {
        id: "international-experience",
        display: { pt: pt.proofMarketsValue, en: en.proofMarketsValue },
        kind: "published-geographic-scope",
        limits: {
          pt: "Escopo geográfico publicado; não informa residência, duração ou contribuição individual por país.",
          en: "Published geographic scope; it does not specify residence, duration, or individual contributions by country.",
        },
        sources: [
          "src/data/pt.json#proofMarketsValue",
          "src/data/en.json#proofMarketsValue",
        ],
      },
      ...APP_ITEMS.map((item) => ({
        id: `${item.id}-store-summary`,
        display: { pt: pt[item.metric], en: en[item.metric] },
        checkedAt: "2026-07",
        kind: "dated-rounded-store-summary",
        limits: { pt: interpretation.pt[2], en: interpretation.en[2] },
        sources: APP_CASES[item.caseId].stores
          .filter((store) => store.productId === item.id)
          .map((store) => store.href),
      })),
    ],
    limitations: interpretation,
    sources: [
      "src/data/pt.json",
      "src/data/en.json",
      "src/data/apps.js",
      "src/context.jsx",
      "src/features/Articles.jsx",
      "public/assets/certificates/catalog.json",
      "public/assets/evidence/mag-venda-digital-reconhecimento-facial.json",
    ],
  };
  const documents = [];
  for (const locale of locales) {
    const t = (key) => {
      const value = copy[locale][key];
      if (typeof value !== "string")
        throw new Error(`Missing public translation: ${locale}.${key}`);
      return value;
    };
    const person = personSchema(profile, t);
    const applications = APP_ITEMS.map((item) =>
      applicationSchema(item, APP_CASES[item.caseId], locale, t, url, person),
    );
    documents.push(
      profileDocument(profile, locale, t, url, interpretation),
      appsDocument(locale, t, url, applications, interpretation),
    );
    APP_ITEMS.forEach((item, index) =>
      documents.push(
        appDocument(
          item,
          APP_CASES[item.caseId],
          locale,
          t,
          url,
          applications[index],
          magEvidence,
          interpretation,
        ),
      ),
    );
    documents.push(
      certificateDocument(records, locale, t, url, interpretation),
      articleDocument(locale, t, url, person, publishedAt),
    );
  }
  return {
    basePath: normalizeBasePath(basePath),
    siteOrigin: new URL(siteOrigin).origin,
    profile,
    documents: documents.map((document) => ({
      ...document,
      url: url(
        document.path === "/" || document.path.endsWith("/")
          ? document.path
          : `${document.path}/`,
      ),
      markdownUrl: url(`${document.path.replace(/\/$/, "")}/index.md`),
    })),
  };
}
