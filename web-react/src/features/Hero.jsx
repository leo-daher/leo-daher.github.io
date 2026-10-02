import { useEffect, useId, useRef, useState } from "react";
import { usePortfolio } from "../context.jsx";
const clamp = (x, a, b) => Math.max(a, Math.min(b, x));
const lerp = (a, b, t) => a + (b - a) * t;
function bezier(t, x1, y1, x2, y2) {
  const point = (p, a, b) =>
    3 * (1 - p) ** 2 * p * a + 3 * (1 - p) * p * p * b + p * p * p;
  let low = 0,
    high = 1;
  for (let i = 0; i < 24; i++) {
    const mid = (low + high) / 2;
    if (point(mid, x1, x2) < t) low = mid;
    else high = mid;
  }
  return point((low + high) / 2, y1, y2);
}
const ease = (t) => bezier(t, 0.645, 0.045, 0.355, 1);
const easeIn = (t) => bezier(t, 0.55, 0.055, 0.675, 0.19);
const presets = { desktop: [620, 260], mobile: [178, 308], tablet: [316, 240] };
const areas = {
  desktop: [
    [0.05, 0.06, 0.9, 0.11],
    [0.05, 0.23, 0.14, 0.67],
    [0.24, 0.23, 0.41, 0.23],
    [0.24, 0.53, 0.41, 0.37],
    [0.69, 0.23, 0.26, 0.32],
    [0.69, 0.63, 0.26, 0.15],
  ],
  tablet: [
    [0.06, 0.06, 0.88, 0.12],
    [0.06, 0.24, 0.88, 0.12],
    [0.06, 0.42, 0.54, 0.19],
    [0.06, 0.67, 0.54, 0.27],
    [0.65, 0.42, 0.29, 0.31],
    [0.65, 0.8, 0.29, 0.14],
  ],
  mobile: [
    [0.08, 0.05, 0.84, 0.09],
    [0.53, 0.86, 0.39, 0.08],
    [0.08, 0.2, 0.84, 0.15],
    [0.08, 0.41, 0.84, 0.23],
    [0.08, 0.7, 0.84, 0.12],
    [0.08, 0.86, 0.39, 0.08],
  ],
};
export function LdOutline({
  width: w,
  height: h,
  stroke: override,
  radius: overrideRadius,
  radiusX: overrideRx,
  radiusY: overrideRy,
  action = false,
}) {
  const id = useId().replace(/:/g, "");
  const s = override ?? clamp(Math.min(w, h) * 0.052, 8, 14),
    r =
      overrideRadius ??
      Math.min(clamp(Math.min(w, h) * 0.22, 24, 72), Math.min(w, h) * 0.24),
    lr = 0.76 * r;
  const rx = overrideRx ?? r,
    ry = overrideRy ?? r;
  const l = s / 2,
    top = s / 2,
    right = w - s / 2,
    bottom = h - s / 2,
    o = Math.max(s * 1.55, r * 0.58),
    join = Math.max(l + lr + s, right - rx - s * 0.18);
  const L = `M${l},${top + o}V${bottom - lr}A${lr},${lr} 0 0 0 ${l + lr},${bottom}H${join}`;
  const D = `M${l + o},${top}H${right - r}A${r},${r} 0 0 1 ${right},${top + r}V${bottom - ry}A${rx},${ry} 0 0 1 ${right - rx},${bottom}H${join}`;
  const b = clamp(r * 1.04, 22, 52),
    br = b * 0.35;
  return (
    <svg
      className="ld-outline"
      width={w}
      height={h}
      viewBox={`0 0 ${w} ${h}`}
      aria-hidden="true"
    >
      <defs>
        <mask id={`cut-${id}`}>
          <rect width={w} height={h} fill="white" />
          <path
            d={`M${join - s * 0.29},${bottom + s * 0.57}L${join + s * 0.57},${bottom - s * 0.57}`}
            stroke="black"
            strokeWidth={(s * 4) / 14}
            strokeLinecap="round"
          />
        </mask>
      </defs>
      <g
        fill="none"
        strokeWidth={s}
        strokeLinejoin="round"
        mask={`url(#cut-${id})`}
      >
        <path d={L} stroke="var(--ld-l)" />
        <path d={D} stroke="var(--ld-d)" />
        <circle
          cx={l}
          cy={top + o}
          r={s / 2}
          fill="var(--ld-l)"
          stroke="none"
        />
        <circle
          cx={l + o}
          cy={top}
          r={s / 2}
          fill="var(--ld-d)"
          stroke="none"
        />
      </g>
      {action && (
        <rect
          x={right - r - (b - br)}
          y={bottom - r - (b - br)}
          width={b}
          height={b}
          rx={br}
          fill="#FF6B55"
        />
      )}
    </svg>
  );
}
function Line({ width = 82, strong = false }) {
  return (
    <span
      className={`skeleton-line${strong ? " strong" : ""}`}
      style={{ width: `${width}%` }}
    />
  );
}
function Dot({ color = "var(--violet)" }) {
  return <span className="interface-dot" style={{ background: color }} />;
}
function ContentPart({ kind, rect, t, width, height }) {
  const pixelWidth = rect[2] * width,
    pixelHeight = rect[3] * height,
    compact = pixelHeight < 48;
  const style = {
    left: `${rect[0] * 100}%`,
    top: `${rect[1] * 100}%`,
    width: `${rect[2] * 100}%`,
    height: `${rect[3] * 100}%`,
  };
  if (kind === 0)
    return (
      <div className="interface-part interface-top" style={style}>
        <Dot />
        <Line width={18} />
        <span className="interface-spacer" />
        <Line width={2} />
        <Dot color="var(--coral)" />
      </div>
    );
  if (kind === 1)
    return (
      <div
        className={`interface-part interface-nav${rect[3] > rect[2] ? " vertical" : ""}`}
        style={style}
      >
        {["var(--violet)", "#55B8FF", "#FF6F91"].map((c) => (
          <div key={c}>
            <Dot color={c} />
            <Line width={65} />
          </div>
        ))}
      </div>
    );
  if (kind === 2)
    return (
      <div className="interface-part interface-message" style={style}>
        <strong
          style={{
            fontSize: clamp(pixelHeight * 0.3, 7.5, 14),
            whiteSpace: "pre-line",
          }}
        >
          {pixelWidth < 280
            ? t("everySurface").replace(". ", ".\n")
            : t("everySurface")}
        </strong>
        <Line width={94} strong />
        {!compact && (
          <>
            <Line width={72} strong />
            <Line width={48} />
          </>
        )}
      </div>
    );
  if (kind === 5)
    return (
      <div className="interface-part interface-identifiers" style={style}>
        {["var(--violet)", "#55B8FF", "#FF6F91"].map((c) => (
          <i
            key={c}
            style={{
              background: `color-mix(in srgb, ${c} 18%, transparent)`,
              borderColor: `color-mix(in srgb, ${c} 28%, transparent)`,
            }}
          />
        ))}
      </div>
    );
  if (compact)
    return (
      <div
        className={`interface-part interface-card flat${kind === 3 ? " primary" : ""}`}
        style={style}
      >
        <Dot color={kind === 3 ? "var(--violet)" : "#55B8FF"} />
        <div className="compact-card-line">
          <Line width={82} strong />
        </div>
        <div className="compact-card-line">
          <Line width={54} />
        </div>
      </div>
    );
  return (
    <div
      className={`interface-part interface-card${kind === 3 ? " primary" : ""}`}
      style={style}
    >
      <div>
        <Dot color={kind === 3 ? "var(--violet)" : "#55B8FF"} />
        <Line width={42} />
      </div>
      <Line width={88} strong />
      <Line width={64} />
      <Line width={38} />
    </div>
  );
}
function Keyboard({ width: w, presence }) {
  const height = clamp(w * 0.26, 82, 112);
  return (
    <svg
      className="keyboard-sketch"
      width={w}
      height={height}
      style={{
        opacity: presence * 0.38,
        transform: `translateY(${(1 - presence) * 8}px)`,
      }}
      viewBox={`0 0 ${w} ${height}`}
      fill="none"
      stroke="var(--muted)"
      strokeWidth="1.15"
    >
      <rect
        x={w * 0.11}
        y={height * 0.08}
        width={w * 0.62}
        height={height * 0.68}
        rx="10"
      />
      {Array.from({ length: 3 }, (_, row) =>
        Array.from({ length: 9 }, (_, key) => {
          const left = w * (0.11 + 0.62 * 0.08),
            kw = (w * 0.62 * 0.84) / 10,
            x = left + (row === 1 ? kw * 0.35 : 0) + key * kw,
            y = height * (0.08 + 0.68 * (0.23 + row * 0.2));
          return <path key={`${row}-${key}`} d={`M${x},${y}h${kw * 0.48}`} />;
        }),
      )}
      <path
        d={`M${w * (0.11 + 0.62 * 0.34)},${height * (0.08 + 0.68) - 11}h${w * 0.62 * 0.32}`}
      />
      <rect
        x={w * 0.8}
        y={height * 0.12}
        width={w * 0.09}
        height={height * 0.58}
        rx={w * 0.09 * 0.48}
      />
      <path
        d={`M${w * 0.845},${height * (0.12 + 0.58 * 0.08)}v${height * 0.58 * 0.26}`}
      />
    </svg>
  );
}
export function Hero({ active = true }) {
  const { t, reduceMotion } = usePortfolio();
  const stage = useRef(null);
  const [bounds, setBounds] = useState([1000, 565]);
  const [morph, setMorph] = useState({ from: "desktop", to: "desktop", p: 1 });
  useEffect(() => {
    const el = stage.current;
    const obs = new ResizeObserver(([entry]) => {
      if (entry.contentRect.width > 0)
        setBounds([entry.contentRect.width, entry.contentRect.height]);
    });
    obs.observe(el);
    return () => obs.disconnect();
  }, []);
  useEffect(() => {
    if (reduceMotion || !active) return;
    let frame, timer;
    let current = "desktop";
    timer = setInterval(() => {
      const next = { desktop: "mobile", mobile: "tablet", tablet: "desktop" }[
        current
      ];
      const from = current;
      current = next;
      const start = performance.now();
      function tick(now) {
        const progress = Math.min(1, (now - start) / 900);
        setMorph({ from, to: next, p: ease(progress) });
        if (progress < 1) frame = requestAnimationFrame(tick);
      }
      frame = requestAnimationFrame(tick);
    }, 4800);
    return () => {
      clearInterval(timer);
      cancelAnimationFrame(frame);
    };
  }, [reduceMotion, active]);
  const fit = (key) => {
    const [w, h] = presets[key],
      s =
        Math.min(bounds[0] / w, bounds[1] / h) * (key === "mobile" ? 0.82 : 1);
    return [w * s, h * s];
  };
  const a = fit(morph.from),
    b = fit(morph.to),
    w = lerp(a[0], b[0], morph.p),
    h = lerp(a[1], b[1], morph.p);
  const s = clamp(Math.min(w, h) * 0.052, 8, 14),
    r = Math.min(clamp(Math.min(w, h) * 0.22, 24, 72), Math.min(w, h) * 0.24),
    inset = s + 5;
  const cr = Math.max(0, r + s / 2 - inset),
    clr = Math.max(0, 0.76 * r + s / 2 - inset);
  const presence =
    morph.to === "desktop"
      ? morph.p
      : morph.from === "desktop"
        ? 1 - morph.p
        : 0;
  return (
    <section className="hero-frame">
      <div className="hero-rings" aria-hidden="true">
        {[0.18, 0.3, 0.42, 0.54].map((v, i) => (
          <i
            key={v}
            style={{
              width: `${v * 200}%`,
              aspectRatio: 1,
              opacity: 0.085 - i * 0.014,
            }}
          />
        ))}
      </div>
      <div className="hero-content">
        <p className="hero-eyebrow">{t("yearsBuildingSoftware")}</p>
        <h1>Leone</h1>
        <p className="hero-role">{t("mobileEngineer")}</p>
        <div ref={stage} className="hero-stage">
          <div
            className="viewport-frame"
            style={{ width: w, height: h }}
            role="img"
            aria-label={t("everySurface")}
            data-preset={morph.to}
          >
            <div
              className="viewport-content"
              style={{
                inset,
                borderRadius: `${clr}px ${cr}px ${cr}px ${clr}px`,
              }}
            >
              {areas[morph.from].map((rect, i) => (
                <ContentPart
                  key={i}
                  kind={i}
                  t={t}
                  width={w - inset * 2}
                  height={h - inset * 2}
                  rect={rect.map((n, j) =>
                    lerp(n, areas[morph.to][i][j], morph.p),
                  )}
                />
              ))}
            </div>
            <LdOutline width={w} height={h} />
            <Keyboard width={w} presence={presence} />
          </div>
        </div>
      </div>
    </section>
  );
}
export function Opening({ onDone }) {
  const [time, setTime] = useState(0),
    [size, setSize] = useState([window.innerWidth, window.innerHeight]);
  useEffect(() => {
    const update = () => setSize([window.innerWidth, window.innerHeight]);
    window.addEventListener("resize", update);
    const start = performance.now();
    let raf;
    function step(now) {
      const ms = now - start;
      setTime(ms);
      if (ms < 1650) raf = requestAnimationFrame(step);
      else onDone();
    }
    raf = requestAnimationFrame(step);
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", update);
    };
  }, [onDone]);
  const [vw, vh] = size,
    short = Math.min(vw, vh),
    side = clamp(short * 0.46, 136, 204),
    p = clamp((time - 700) / 950, 0, 1);
  const grow = ease(clamp((p - 0.08) / (0.7 - 0.08), 0, 1)),
    exit = easeIn(clamp((p - 0.76) / 0.24, 0, 1)),
    overshoot = clamp(short * 0.1, 56, 96);
  const w = lerp(lerp(side, vw, grow), vw + overshoot * 2, exit),
    h = lerp(lerp(side, vh, grow), vh + overshoot * 2, exit),
    stroke = clamp(side * 0.058, 8, 12);
  const fp = ease(clamp((p - 0.12) / (0.7 - 0.12), 0, 1)),
    initialB = clamp(side * 0.19, 26, 38),
    initialBR = initialB * 0.35,
    bs = lerp(initialB, 56, fp),
    br = lerp(initialBR, 16, fp);
  const startCX =
      (vw + side) / 2 - side * 0.18 - (initialB - initialBR) + initialB / 2,
    startCY =
      (vh + side) / 2 - side * 0.18 - (initialB - initialBR) + initialB / 2;
  const cx = lerp(startCX, vw - 44, fp),
    cy = lerp(startCY, vh - 44, fp),
    x = cx - bs / 2,
    y = cy - bs / 2;
  const rx = clamp((vw + w) / 2 - stroke / 2 - cx - (bs / 2 - br), 0, w / 2),
    ry = clamp((vh + h) / 2 - stroke / 2 - cy - (bs / 2 - br), 0, h / 2),
    r = Math.min(rx, ry);

  return (
    <div className="opening" aria-label="Leone Daher" role="img">
      <div className="opening-backdrop" style={{ opacity: 1 - exit }} />
      <div
        className="opening-frame"
        style={{ width: w, height: h, left: (vw - w) / 2, top: (vh - h) / 2 }}
      >
        <LdOutline
          width={w}
          height={h}
          stroke={stroke}
          radius={r}
          radiusX={rx}
          radiusY={ry}
        />
      </div>
      <div
        className="opening-dot"
        style={{ width: bs, height: bs, borderRadius: br, left: x, top: y }}
      />
    </div>
  );
}
