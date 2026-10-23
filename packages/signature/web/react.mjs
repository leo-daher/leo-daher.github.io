import { createElement, useId } from 'react';
import { signatureContent } from './index.mjs';

export function LeoneSignature({ locale = 'en', theme = 'auto', variant = 'footer', className = '' } = {}) {
  const id = `ld-${useId().replace(/[^a-zA-Z0-9_-]/g, '')}`;
  const c = signatureContent({locale, theme, variant, id});
  return createElement('a', {
    className: `ld-signature ${className}`.trim(),
    'data-theme': theme,
    'data-variant': variant,
    href: c.href,
    target: '_blank',
    rel: 'noopener noreferrer',
    'aria-label': c.accessibleLabel,
    dangerouslySetInnerHTML: {__html: c.innerHtml},
  });
}
