import { useEffect, useRef, useState } from "react";
import { usePortfolio, assetUrl, contactLinks, basePath } from "../context.jsx";
import { Icon } from "./Icon.jsx";
import { LiquidGlass } from "./LiquidGlass.jsx";
const destinations = [
  ["whatsapp", "contactWhatsApp", "whatsapp-symbol.svg"],
  ["schedule", "contactSchedule", null],
  ["linkedin", "contactLinkedIn", "linkedin-symbol.svg"],
  ["github", "contactGitHub", "github-symbol.svg"],
];
export function ContactIcon({ type, file }) {
  return file ? (
    <span
      className="brand-icon"
      style={{
        maskImage: `url(${assetUrl("/assets/brand/" + file)})`,
        WebkitMaskImage: `url(${assetUrl("/assets/brand/" + file)})`,
      }}
    />
  ) : (
    <Icon name={type === "schedule" ? "calendar" : "chat"} />
  );
}
export function Header({ home, onBack, visible = true }) {
  const { t, locale, setLocale, theme, setTheme, navigate } = usePortfolio();
  const [open, setOpen] = useState(false);
  const root = useRef(null),
    trigger = useRef(null),
    items = useRef([]);
  function close(returnFocus = false) {
    setOpen(false);
    if (returnFocus) trigger.current?.focus();
  }
  useEffect(() => {
    function dismiss(e) {
      if (root.current && !root.current.contains(e.target)) close();
    }
    function esc(e) {
      if (e.key === "Escape" && open) {
        e.preventDefault();
        close(true);
      }
    }
    document.addEventListener("pointerdown", dismiss);
    document.addEventListener("keydown", esc);
    return () => {
      document.removeEventListener("pointerdown", dismiss);
      document.removeEventListener("keydown", esc);
    };
  }, [open]);
  function handleKeys(e) {
    const i = items.current.indexOf(document.activeElement);
    let next;
    if (e.key === "ArrowDown") next = (i + 1) % 4;
    if (e.key === "ArrowUp") next = (i + 3) % 4;
    if (e.key === "Home") next = 0;
    if (e.key === "End") next = 3;
    if (next !== undefined) {
      e.preventDefault();
      items.current[next]?.focus();
    }
  }
  return (
    <header
      className={`topbar${!visible ? " invisible" : ""}`}
      inert={!visible}
    >
      <LiquidGlass />
      <div className="topbar-inner">
        <button
          className="icon-button brand-home"
          onClick={() => (home ? navigate("/#home") : onBack())}
          aria-label={
            home
              ? `Leone Daher · ${t("navHome")}`
              : locale === "pt"
                ? "Voltar"
                : "Back"
          }
          title={home ? t("navHome") : locale === "pt" ? "Voltar" : "Back"}
        >
          {home ? (
            <span
              className="brand-mark"
              aria-hidden="true"
              style={{
                backgroundImage: `url("${assetUrl(`/assets/brand/ld-mark${theme === "dark" ? "-inverse" : ""}.svg`)}")`,
              }}
            />
          ) : (
            <Icon name="arrow-left" />
          )}
        </button>
        <span className="brand-name">LEONE DAHER</span>
        <div className="header-actions">
          <button
            className="language-toggle"
            onClick={() => setLocale(locale === "pt" ? "en" : "pt")}
            aria-label={`${t("languageSelectorLabel")}: ${locale === "pt" ? "English" : "Português"}`}
            title={locale === "pt" ? "English" : "Português"}
          >
            <span className={locale === "en" ? "selected" : ""}>EN</span> /{" "}
            <span className={locale === "pt" ? "selected" : ""}>PT</span>
          </button>
          <button
            className="icon-button theme-toggle"
            onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            aria-label={t(
              theme === "dark" ? "switchToLightTheme" : "switchToDarkTheme",
            )}
            title={t(
              theme === "dark" ? "switchToLightTheme" : "switchToDarkTheme",
            )}
          >
            <Icon name={theme === "dark" ? "sun" : "moon"} />
          </button>
          <div className="contact-menu-anchor" ref={root}>
            <button
              ref={trigger}
              className={`contact-trigger${open ? " open" : ""}`}
              aria-label={t("contactMenuLabel")}
              aria-expanded={open}
              aria-haspopup="menu"
              aria-controls="contact-options"
              onClick={() => {
                if (open) close(true);
                else {
                  setOpen(true);
                  requestAnimationFrame(() => items.current[0]?.focus());
                }
              }}
              onKeyDown={(e) => {
                if (e.key === "ArrowDown" || e.key === "ArrowUp") {
                  e.preventDefault();
                  setOpen(true);
                  const target = e.key === "ArrowUp" ? 3 : 0;
                  requestAnimationFrame(() => items.current[target]?.focus());
                }
              }}
            >
              <Icon name="chevron-down" size={16} />
              <span>{t("hireMe")}</span>
              <Icon className="compact-contact-icon" name="chat" size={21} />
            </button>
            {open && (
              <div
                id="contact-options"
                className="contact-popup"
                role="menu"
                aria-label={t("contactMenuLabel")}
                onKeyDown={handleKeys}
              >
                {destinations.map(([id, label, file], i) => (
                  <a
                    key={id}
                    ref={(el) => (items.current[i] = el)}
                    role="menuitem"
                    href={contactLinks[id]}
                    target="_blank"
                    rel="noreferrer"
                    onClick={() => close()}
                  >
                    <ContactIcon type={id} file={file} />
                    <span>{t(label)}</span>
                    <Icon name="external" size={18} />
                  </a>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
}
const fabDestinations = [
  ["home", "navHome", "home"],
  ["apps", "navApps", "apps"],
  ["system", "navSystem", "system"],
  ["clients", "navClients", "clients"],
  ["contact", "navContact", "chat"],
];
export function FabMenu() {
  const { t, navigate } = usePortfolio();
  const [open, setOpen] = useState(false),
    [closing, setClosing] = useState(false);
  const trigger = useRef(null),
    items = useRef([]),
    timer = useRef(null);
  const close = (focus = false) => {
    setOpen(false);
    setClosing(true);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setClosing(false), 260);
    if (focus) trigger.current?.focus();
  };
  useEffect(() => {
    function key(e) {
      if (e.key === "Escape" && open) {
        e.preventDefault();
        close(true);
      }
    }
    window.addEventListener("keydown", key);
    return () => {
      window.removeEventListener("keydown", key);
    };
  }, [open]);
  useEffect(() => () => clearTimeout(timer.current), []);
  function keys(e) {
    let i = items.current.indexOf(document.activeElement);
    if (
      e.key === "ArrowDown" ||
      (e.key === "Tab" &&
        document.activeElement === trigger.current &&
        !e.shiftKey)
    ) {
      e.preventDefault();
      items.current[(i + 1) % 5]?.focus();
    }
    if (e.key === "ArrowUp" || (e.key === "Tab" && e.shiftKey && i === 0)) {
      e.preventDefault();
      if (i <= 0) trigger.current?.focus();
      else items.current[i - 1]?.focus();
    }
  }
  return (
    <>
      <button
        className={`fab-backdrop${open ? " shown" : ""}`}
        aria-label={t("dismissNavigationMenu")}
        onClick={() => close(true)}
        tabIndex={-1}
        inert={!open}
      />
      <nav
        className={`fab-group${open ? " expanded" : ""}${closing ? " closing" : ""}`}
        aria-label={t("openNavigationMenu")}
        onKeyDown={keys}
      >
        <div
          className="fab-items"
          id="fab-navigation"
          aria-hidden={!open}
          inert={!open}
        >
          {fabDestinations.map(([id, label, icon], i) => (
            <button
              key={id}
              ref={(el) => (items.current[i] = el)}
              className="fab-item"
              style={{ "--index": i }}
              onClick={() => {
                close(true);
                navigate("/#" + id);
              }}
            >
              <Icon name={icon} />
              <span>{t(label)}</span>
            </button>
          ))}
        </div>
        <button
          className="fab-toggle"
          ref={trigger}
          aria-label={t(open ? "closeNavigationMenu" : "openNavigationMenu")}
          title={t(open ? "closeNavigationMenu" : "openNavigationMenu")}
          aria-expanded={open}
          aria-controls="fab-navigation"
          onClick={() => (open ? close() : setOpen(true))}
        >
          <Icon name={open ? "close" : "menu"} size={open ? 20 : 24} />
        </button>
      </nav>
    </>
  );
}
