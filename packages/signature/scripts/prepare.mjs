import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
const root = new URL('../../../', import.meta.url);
const pkg = new URL('../', import.meta.url);
const marks = {};
const svgSources = {};
for (const [theme, name] of [['light', 'ld-mark.svg'], ['dark', 'ld-mark-inverse.svg']]) {
  const source = await readFile(new URL(`assets/brand/${name}`, root), 'utf8');
  svgSources[theme] = source;
  await writeFile(new URL(`assets/${name}`, pkg), source);
  marks[theme] = source.replace(/<title[\s\S]*?<\/title>|<desc[\s\S]*?<\/desc>/g, '')
    .replace(/role="img"|aria-labelledby="[^"]*"/g, '')
    .replace('<svg ', `<svg class="ld-mark--${theme}" aria-hidden="true" focusable="false" `)
    .replaceAll('join-cut', '__LD_MASK__').replace(/>\s+</g, '><').trim();
}
function dartPath(data) {
  const tokens = data.match(/[MLHVQ]|-?\d+(?:\.\d+)?/g);
  let at = 0, command, x = 0, y = 0;
  const operations = [];
  const number = () => { const value = Number(tokens[at++]); if (!Number.isFinite(value)) throw new Error('Unsupported logo geometry'); return value; };
  while (at < tokens.length) {
    if (/^[A-Z]$/.test(tokens[at])) command = tokens[at++];
    if (command === 'M' || command === 'L') { x = number(); y = number(); operations.push(`..${command === 'M' ? 'moveTo' : 'lineTo'}(${x}, ${y})`); command = 'L'; }
    else if (command === 'H') { x = number(); operations.push(`..lineTo(${x}, ${y})`); }
    else if (command === 'V') { y = number(); operations.push(`..lineTo(${x}, ${y})`); }
    else if (command === 'Q') { const cx = number(), cy = number(); x = number(); y = number(); operations.push(`..quadraticBezierTo(${cx}, ${cy}, ${x}, ${y})`); }
    else throw new Error('Unsupported logo command');
  }
  return `Path()${operations.join('')}`;
}
const paths = [...svgSources.light.matchAll(/<path\b[^>]*d="([^"]+)"[^>]*>/g)].map(match => match[1]);
const colors = tone => [...svgSources[tone].matchAll(/<path\b[^>]*stroke="(#[a-fA-F0-9]{6})"/g)].map(match => match[1]).filter(value => value !== '#000000');
const light = colors('light'), dark = colors('dark');
if (paths.length !== 3 || light.length !== 2 || dark.length !== 2) throw new Error('Review the changed canonical logo before generating signatures');
const color = hex => `Color(0xFF${hex.slice(1).toUpperCase()})`;
await writeFile(new URL('flutter/lib/mark.g.dart', pkg), `// Derived from assets/brand/ld-mark*.svg. Run npm run signature:build.\npart of 'leone_signature.dart';\nvoid _paintSignatureMark(Canvas canvas, Size size, bool dark) {\ncanvas.save();canvas.scale(size.width / 256, size.height / 256);\ncanvas.saveLayer(const Rect.fromLTWH(0, 0, 256, 256), Paint());\nfinal pen=Paint()..style=PaintingStyle.stroke..strokeWidth=14..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round;\ncanvas.drawPath(${dartPath(paths[1])}, pen..color=dark?${color(dark[0])}:${color(light[0])});\ncanvas.drawPath(${dartPath(paths[2])}, pen..color=dark?${color(dark[1])}:${color(light[1])});\ncanvas.drawPath(${dartPath(paths[0])}, Paint()..style=PaintingStyle.stroke..strokeWidth=4..strokeCap=StrokeCap.round..blendMode=BlendMode.clear);\ncanvas.restore();\ncanvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(155, 155, 48, 48), const Radius.circular(17)), Paint()..color=const Color(0xFFFF6B55));\ncanvas.restore();\n}\n`);
await writeFile(new URL('web/marks.mjs', pkg), `// Derived from the canonical assets/brand SVGs. Run npm run signature:build.\nexport const marks = ${JSON.stringify(marks)};\n`);
const css = await readFile(new URL('web/styles.css', pkg), 'utf8');
await writeFile(new URL('web/styles.mjs', pkg), `// Derived from styles.css.\nexport const signatureStyles = ${JSON.stringify(css)};\n`);
const { renderSignature } = await import(new URL('web/index.mjs', pkg));
const output = new URL('web-react/public/design-system/', root);
await mkdir(output, {recursive: true});
await writeFile(new URL('signature.css', output), css);
const signature = (theme, variant, locale = 'pt') => renderSignature({theme, variant, locale, id:`demo-${theme}-${variant}`});
await writeFile(new URL('index.html', output), `<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Assinatura · Leone Daher</title><link rel="stylesheet" href="./signature.css"><style>
:root{font-family:system-ui,-apple-system,sans-serif;color:#171721;background:#f7f7fb;line-height:1.6}*{box-sizing:border-box}body{margin:0}main{max-width:1040px;margin:auto;padding:48px 28px 80px}header{display:flex;align-items:center;justify-content:space-between;padding-bottom:24px;border-bottom:1px solid #17172120}header a{font-size:13px;color:inherit;text-decoration:none}.wordmark{font-weight:650;letter-spacing:-.03em}.version{font-size:11px;color:#5d5d6b}h1{font-size:clamp(36px,7vw,64px);letter-spacing:-.055em;line-height:1.08;font-weight:550;max-width:650px;margin:60px 0 20px}.intro{color:#5d5d6b;max-width:600px;font-size:16px}.eyebrow{font-size:11px;letter-spacing:.15em;text-transform:uppercase;color:#5d5d6b;margin-top:60px}h2{font-size:23px;letter-spacing:-.025em;font-weight:550;margin:8px 0 24px}.grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}.stage{padding:32px;border-radius:20px;background:white;border:1px solid #17172112;min-width:0}.stage.dark{background:#0e0e18;color:#f3f6f5}.stage p{font-size:12px;margin:0 0 28px;color:#5d5d6b}.stage.dark p{color:#a5a2b4}.stage section{min-height:122px;display:flex;align-items:center;justify-content:center}.stage section+section{margin-top:16px;border-top:1px solid #ffffff12}.menu{max-width:280px;margin:auto;display:grid;gap:6px}.menu>span{font-size:13px;padding:10px 0;color:#a5a2b4}.menu>.ld-signature{margin-top:12px}.integration{margin-top:36px;padding:24px 28px;border-radius:16px;background:#eeedf4}.integration p{font-size:13px;color:#5d5d6b;margin:0 0 12px}pre{font:12px/1.8 ui-monospace,monospace;overflow:auto;margin:0}footer{margin-top:48px;display:flex;justify-content:space-between;gap:24px;font-size:12px;color:#5d5d6b}footer a{color:inherit}@media(max-width:620px){main{padding:24px 20px 48px}h1{margin-top:40px}.grid{grid-template-columns:1fr}.stage{padding:26px}.eyebrow{margin-top:40px}footer{flex-direction:column}}
</style></head><body><main><header><a class="wordmark" href="../">Leone Daher<span aria-hidden="true" style="color:#ff6b55">.</span></a><span class="version">Identidade / v1.0.0</span></header><h1>Uma assinatura.<br>Em todo produto.</h1><p class="intro">A marca LD acompanha a autoria com a mesma forma, cores e proporções. Um componente discreto para rodapés e menus, em web e Flutter.</p><p class="eyebrow">01 / Assinatura</p><h2>Reconhecível em qualquer tema.</h2><div class="grid"><div class="stage"><p>Fundo claro · Português</p><section>${signature('light','footer')}</section></div><div class="stage dark"><p>Fundo escuro · English</p><section>${signature('dark','footer','en')}</section></div><div class="stage dark"><p>Menu · A autoria no seu lugar</p><div class="menu"><span>Sobre o aplicativo</span><span>Política de Privacidade</span>${signature('dark','menu')}</div></div><div class="stage"><p>Compacta · Quando o espaço pede</p><section>${signature('light','compact')}</section></div></div><p class="eyebrow">02 / Integração</p><h2>Uma origem. Versões previsíveis.</h2><div class="integration"><p>React</p><pre tabindex="0" aria-label="Exemplo de uso em React">import { LeoneSignature } from '@leonedaher/signature/react';\nimport '@leonedaher/signature/styles.css';\n\n&lt;LeoneSignature locale="pt" theme="dark" /&gt;</pre></div><footer><span>SVG local · Sem rastreadores · Português, English, Español</span><a href="https://github.com/leo-daher/leo-daher.github.io/tree/main/packages/signature">Código e documentação ↗</a></footer></main></body></html>`);
console.log(`Signature assets and showcase generated: ${fileURLToPath(output)}`);
