export interface SignatureOptions {
  locale?: string;
  theme?: 'auto' | 'dark' | 'light';
  variant?: 'footer' | 'menu' | 'compact';
  /** Unique per instance when rendering static HTML. */
  id?: string;
}
export const signatureVersion: string;
export const signatureStyles: string;
export function renderSignature(options?: SignatureOptions): string;
export function signatureContent(options?: SignatureOptions): {
  href: string; label: string; accessibleLabel: string; innerHtml: string;
  theme: NonNullable<SignatureOptions['theme']>;
  variant: NonNullable<SignatureOptions['variant']>;
};
