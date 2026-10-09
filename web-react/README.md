# Leone Daher — React portfolio

Clone da interface atual do portfólio Flutter, com React e um servidor Node.js. Mantém a marca LD, fontes e assets originais, conteúdo em português e inglês, temas, animação de abertura, frame adaptativo, navegação, apps, certificados e artigo.

A barra superior reproduz a aparência da demonstração [Liquid Glass](https://liquid-glass.maxrovensky.com/) observada no Safari: blur uniforme de 14,88 px, saturação de 140%, raio de 32 px, reflexo contínuo e contorno fino. O blur cobre toda a superfície, sem máscaras internas, refração ou dispersão de cores. Tint e sombra acompanham o tema; os controles ficam em uma camada separada. Transparência reduzida e alto contraste usam uma superfície opaca. A implementação usa CSS para preservar esse visual também nos demais navegadores; a biblioteca `liquid-glass-react` permanece instalada, sem ser montada na página atual.

## Executar

Requer Node.js 22.12 ou superior.

```sh
npm ci
npm run dev
```

Desenvolvimento: http://127.0.0.1:5173/

Para executar a prévia da versão de produção com Node.js:

```sh
SITE_ORIGIN=http://127.0.0.1:4173 npm run build
npm start
```

Na publicação, use a origem HTTPS real em `SITE_ORIGIN`; o valor padrão é `https://leo-daher.github.io`. Assim os links do guia e as URLs canônicas apontam para o mesmo ambiente.

Prévia: http://127.0.0.1:4173/. `PORT` e `HOST` configuram o servidor. O endpoint `/api/health` confirma disponibilidade. Nenhum banco de dados é necessário para o conteúdo público do portfólio.

## Validação

```sh
npm run check
npm run build
npm run test:agents
npx playwright install chromium
npm test
```

No Mac, o Chrome existente também pode ser usado:

```sh
PLAYWRIGHT_CHROME_PATH='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' npm test
```

Os testes de agentes iniciam um servidor isolado, consultam HTML sem JavaScript, Markdown, Schema.org, sitemap, fontes e o MCP com o cliente oficial, incluindo tráfego legado e rejeição de requisições inválidas. Os testes de interface cobrem as rotas, dimensões de desktop/celular, conteúdo, assets, preferências persistentes, filtros OR, modal de certificados, foco e teclado, menu, retorno de scroll, links oficiais, referências de aquisição, acessibilidade e servidor.

## Fontes e atualização

- `src/data/pt.json` e `en.json`: textos exportados dos arquivos `lib/l10n/app_*.arb` originais.
- `src/data/app-stories.js`: relatos completos dos quatro apps em português e inglês, selecionados a partir das experiências e evidências da base profissional. As páginas individuais e as exportações públicas em Markdown reutilizam o mesmo texto; os resumos da home permanecem compactos.
- `src/data/experiences.js`: 13 relatos profissionais selecionados da base compartilhada, com quatro destaques na home e a página `/experiencias`. A fonte e os limites editoriais estão em `content/professional-experience-sources.md`.
- A home reúne Lyzer Collect e Deliver em um destaque com dois ícones e 1,1 mil+ downloads: soma dos patamares Google Play de julho de 2026 (1 mil+ e 100+). O cartão abre o case conjunto em `/apps/lyzer-collect-deliver`, com os dois produtos, telas e links das lojas. O catálogo de apps mantém os quatro produtos individuais e suas próprias aberturas; a soma não representa usuários únicos nem inclui App Store.
- Os destaques de experiência mostram a área de atuação abaixo da marca. Os vínculos com consultorias permanecem nos relatos completos e na base compartilhada. A seção de competências combina descrições do trabalho, tecnologias e links para casos; o HTML e o Markdown reutilizam esse conteúdo.
- A navegação do computador oferece atalhos na barra superior; o menu flutuante inclui certificações e artigos. Em telas baixas, a lista do menu rola dentro da área disponível e mantém o item em foco visível.
- A navegação entre páginas aplica a posição vertical final antes de exibir o conteúdo e usa apenas uma transição lateral. Voltar e avançar restauram a posição de cada entrada do histórico; preferências de movimento reduzido eliminam a animação. A navegação entre seções da mesma página mantém a rolagem suave.
- `public/assets`: cópia dos assets públicos selecionados do portfólio; certificados PDF continuam arquivados no projeto original.
- `src/features`: telas e interações portadas da versão Flutter.
- A contagem de 14 apps, contribuições profissionais e métricas das lojas seguem o conteúdo original. As consultas das lojas continuam datadas de julho de 2026.
- A troca de idioma mantém as chaves `portfolio_locale` e `portfolio_theme`, mas o idioma exibido sempre acompanha a URL; somente o tema é restaurado como preferência. Referências `ref` são sanitizadas, registradas na sessão e removidas da URL visível.
- A publicação mantém as configurações existentes de GA4 e Sentry. As referências de aquisição são sanitizadas e removidas da URL visível; prévias locais não enviam telemetria por padrão.

A implementação Flutter e a alternativa `web-astro` permanecem separadas. Alterações futuras no conteúdo original devem ser sincronizadas com este clone.

## Consulta por agentes

A construção gera o conteúdo visível das páginas em HTML, antes de carregar o JavaScript. O cliente React preserva temas, preferências, animações e interações. A raiz `/` e seus caminhos oferecem inglês por padrão; português usa `/pt/`. A URL define o idioma, independentemente do navegador ou de uma preferência anterior. Links antigos em `/en/` redirecionam aos caminhos ingleses na raiz, preservando parâmetros e fragmentos no navegador. Metadados canônicos, alternates por idioma, Schema.org e versões em Markdown acompanham o conteúdo.

- `/llms.txt`: guia bilíngue conciso com navegação, fontes e limites das evidências, conforme a proposta [llms.txt](https://llmstxt.org/).
- `/llms-full.txt`: texto público completo nos dois idiomas.
- `/index.md` e `/apps/<case>/index.md`: versões em Markdown de cada página; o HTML e o servidor indicam os links com `rel="alternate"` e `rel="describedby"`.
- `/portfolio.json`: exportação específica deste site, com perfil, métricas contextualizadas e documentos. Não é um padrão universal.
- `/sitemap.xml` e `/robots.txt`: descoberta e regras de rastreamento. O `robots.txt` tem efeito quando servido na raiz do domínio; uma cópia dentro de `/react/` não substitui as regras da raiz.

O conteúdo deriva das mesmas traduções, do catálogo compartilhado de apps e dos certificados/evidências públicos. Nenhuma base profissional privada é exportada. A contagem de 14 apps pertence ao inventário Latitudde/Conkord, métricas das lojas continuam datadas de julho de 2026 e certificados são identificados como cursos.

### MCP no servidor Node

Endpoint de consulta: `http://127.0.0.1:4173/mcp` (ou `<basePath>mcp` em uma construção para subpasta). Usa o SDK oficial, Streamable HTTP e compatibilidade com clientes MCP anteriores. O cliente precisa conectar esse endpoint; uma visita comum ao site não configura MCP automaticamente.

Ferramentas públicas, somente de leitura:

- `get_portfolio_overview`: perfil e mapa de conteúdos.
- `search_portfolio`: busca com trechos e links das fontes.
- `read_portfolio_document`: case, perfil, certificados ou artigo completo.

As três aceitam `locale: "pt" | "en"`; quando omitido, usam inglês. Há também 20 recursos Markdown, um por documento/idioma. O servidor não envia mensagens, faz candidaturas, consulta arquivos privados ou executa ações externas.

`SITE_ORIGIN` define a origem canônica usada nos links, sem subpasta. `VITE_BASE_PATH` define a subpasta na construção. Consulte `.env.example`; as variáveis são fornecidas ao processo Node/construção. O servidor valida Host e Origin no MCP, limita o corpo a 64 KiB e usa `MCP_ALLOWED_HOSTS`/`MCP_ALLOWED_ORIGINS` para destinos adicionais explícitos. Conteúdo público não exige credenciais. Para acesso remoto, hospede Node atrás de HTTPS.

HTML, Markdown e dados estruturados ajudam leitores e buscadores independentemente de MCP. `llms.txt` é uma proposta, não uma garantia de consulta ou indexação por todos os agentes; não há promessa de recomendação automática por recrutadores ou buscadores.

## Publicação

O fluxo de publicação serve esta versão React na raiz do portfólio. Ele verifica e testa a aplicação antes de construir com `VITE_BASE_PATH=/`, a origem pública e as configurações existentes de GA4/Sentry. A implementação Flutter permanece no código-fonte.

Ícones, compartilhamento social, atalhos `/in` e `/ig` com redirecionamento sem JavaScript e o worker de desativação do Flutter preservam a compatibilidade com a publicação anterior.

Para outro caminho de publicação:

```sh
VITE_BASE_PATH=/react/ npm run build
npm start
```

Todos os assets, links internos e pontos de entrada estáticos usam o caminho configurado. `/ios`, `/apps`, os quatro cases, `/experiencias`, `/certificacoes`, o artigo e os atalhos `/in` e `/ig` podem ser acessados diretamente ou recarregados.

GitHub Pages hospeda os arquivos estáticos, incluindo HTML completo, Markdown e metadados. O endpoint MCP requer o processo Node em uma hospedagem de servidor; ele não é servido pelo GitHub Pages.
