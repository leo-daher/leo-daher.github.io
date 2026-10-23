# Assinatura Leone Daher

Componente compartilhado da identidade LD para rodapés e menus. A marca do
produto continua principal; a assinatura identifica a autoria e abre o
portfólio. Não depende da disponibilidade do portfólio para renderizar.

## Instalação web

Use uma revisão fixa do repositório, nunca uma branch móvel em produção:

```sh
npm install github:leo-daher/leo-daher.github.io#signature-v1.0.0
```

```jsx
import { LeoneSignature } from '@leonedaher/signature/react';
import '@leonedaher/signature/styles.css';

<LeoneSignature locale="pt-BR" theme="dark" variant="footer" />
```

`theme`: `light`, `dark` ou `auto` (preferência do sistema). Use o tema explícito
quando o aplicativo controlar seu próprio tema. `variant`: `footer`, `menu`
(ocupa a largura disponível) ou `compact` (somente símbolo, com nome acessível).
`className` permite posicionar o componente sem alterar a identidade.

## HTML estático / renderização no servidor

```js
import { renderSignature, signatureStyles } from '@leonedaher/signature';
const html = renderSignature({ locale: 'pt', theme: 'dark', id: 'site-footer' });
// Incluir signatureStyles no CSS da página e html no rodapé.
```

Não é necessário JavaScript no navegador. Forneça um `id` único para cada
instância estática na mesma página. O destino é fixo no portfólio, com versão
portuguesa para `pt` e inglesa para os demais idiomas. Não aceita HTML nem URLs
externas fornecidas pelo consumidor.

## Flutter

```yaml
dependencies:
  leone_signature:
    git:
      url: https://github.com/leo-daher/leo-daher.github.io.git
      ref: signature-v1.0.0
      path: packages/signature/flutter
```

```dart
import 'package:leone_signature/leone_signature.dart';

LeoneSignature(
  locale: Localizations.localeOf(context),
  onPressed: () => openPortfolio(LeoneSignature.portfolioUri(
    Localizations.localeOf(context),
  )),
)
```

O aplicativo controla a abertura do link e seu tratamento de erros. O widget
usa o tema Material atual e não adiciona dependências além do Flutter.

## Regras

- Fonte visual: `assets/brand/ld-mark*.svg` no repositório do portfólio.
- Símbolo com 40 px/dp, proporção quadrada e cores oficiais; não esticar.
- Área interativa mínima de 60 px/dp; foco visível, sem animação obrigatória.
- Textos localizados em português, inglês e espanhol; marca sempre Leone Daher.
- CSS limitado ao prefixo `ld-signature`; não modifica o tema do produto.
- Sem scripts remotos, cookies, identificadores ou rastreadores adicionais.
- As permissões de uso da marca não são transferidas pelo acesso ao código.

## Manutenção

Na raiz do portfólio: `npm run signature:build` sincroniza os SVGs e gera os
exemplos em `web-react/public/design-system/`. `npm test` valida localização,
IDs independentes, isolamento de conteúdo e sincronização dos assets. No
subdiretório `flutter/`, execute `flutter analyze` e `flutter test`.

Ao alterar forma, cores ou comportamento, incremente a versão, regenere os
arquivos e publique uma nova tag `signature-vX.Y.Z`. Os consumidores recebem a
nova versão somente quando sua referência for atualizada e validada.
