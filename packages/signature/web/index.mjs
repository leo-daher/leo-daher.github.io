import { marks } from './marks.mjs';
export { signatureStyles } from './styles.mjs';

export const signatureVersion = '1.0.0';
const copy = {
  pt: ['Desenvolvido por', 'Conheça o portfólio de Leone Daher (abre em nova aba)'],
  en: ['Developed by', 'Visit Leone Daher’s portfolio (opens in a new tab)'],
  es: ['Desarrollado por', 'Visita el portafolio de Leone Daher (se abre en otra pestaña)'],
};
const escape = value => String(value).replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));

export function signatureContent({ locale = 'en', variant = 'footer', theme = 'auto', id = 'leone-signature' } = {}) {
  const language = String(locale).toLowerCase().split(/[-_]/)[0];
  const [label, accessibleLabel] = copy[language] ?? copy.en;
  if (!['footer', 'menu', 'compact'].includes(variant)) throw new TypeError('Unknown signature variant');
  if (!['auto', 'dark', 'light'].includes(theme)) throw new TypeError('Unknown signature theme');
  if (!/^[a-zA-Z][a-zA-Z0-9_-]*$/.test(id)) throw new TypeError('A unique HTML-safe signature id is required');
  const href = language === 'pt' ? 'https://leo-daher.github.io/pt/' : 'https://leo-daher.github.io/';
  const mark = tone => marks[tone].replaceAll('__LD_MASK__', `${id}-${tone}`);
  return {
    href, label, accessibleLabel, variant, theme,
    innerHtml: `<span class="ld-signature__mark" aria-hidden="true">${mark('light')}${mark('dark')}</span><span class="ld-signature__copy"><span class="ld-signature__label">${escape(label)}</span><span class="ld-signature__name">Leone Daher</span></span><svg class="ld-signature__arrow" width="16" height="16" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M7 17 17 7M7 7h10v10" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
  };
}

// Static HTML and server rendering need neither React nor browser JavaScript.
export function renderSignature(options) {
  const c = signatureContent(options);
  return `<a class="ld-signature" data-theme="${c.theme}" data-variant="${c.variant}" href="${c.href}" target="_blank" rel="noopener noreferrer" aria-label="${escape(c.accessibleLabel)}">${c.innerHtml}</a>`;
}
