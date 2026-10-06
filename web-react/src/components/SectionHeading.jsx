export function SectionHeading({
  eyebrow,
  title,
  copy,
  copyBelowTitle = false,
  level = 2,
}) {
  const Heading = level === 1 ? "h1" : "h2";
  return (
    <div className={`section-heading${copyBelowTitle ? " copy-below" : ""}`}>
      <div>
        {eyebrow && <p className="eyebrow">{eyebrow}</p>}
        <Heading>{title}</Heading>
        {copyBelowTitle && copy && <p className="heading-copy">{copy}</p>}
      </div>
      {!copyBelowTitle && copy && <p className="heading-copy">{copy}</p>}
    </div>
  );
}
