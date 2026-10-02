export function SectionHeading({
  eyebrow,
  title,
  copy,
  copyBelowTitle = false,
}) {
  return (
    <div className={`section-heading${copyBelowTitle ? " copy-below" : ""}`}>
      <div>
        {eyebrow && <p className="eyebrow">{eyebrow}</p>}
        <h2>{title}</h2>
        {copyBelowTitle && copy && <p className="heading-copy">{copy}</p>}
      </div>
      {!copyBelowTitle && copy && <p className="heading-copy">{copy}</p>}
    </div>
  );
}
