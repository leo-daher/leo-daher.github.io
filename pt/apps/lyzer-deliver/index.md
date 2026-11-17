# Lyzer Deliver

Rotas, operação offline e comprovação de entrega para equipes em campo.

**Resumo publicado:** 100+ downloads · Flutter · Android · iOS

Consultado em julho de 2026.

## Case compartilhado: Lyzer Collect + Deliver

Suite operacional que conecta coleta, preparação de pedidos, rotas e entrega.

## Contexto

Logística · Portugal · Flutter · Android e iOS

## Minha atuação

Engenharia Flutter nos fluxos operacionais Android e iOS da suite Lyzer.

## Contribuição

Fluxos de picking e entrega construídos sobre uma engine proprietária baseada em GetX, com leitura de códigos de barras, sincronização offline e integrações para operação em campo.

## A etapa da entrega no celular de quem está em campo

O Lyzer Deliver é o aplicativo da suíte Lyzer voltado às rotas, à operação em campo e à comprovação de entrega. Ele se conecta a uma operação logística que também inclui gestão e preparação de pedidos. Enquanto o Collect atende à etapa de preparação, o Deliver acompanha o momento em que o pedido segue para o destino e a execução precisa ser registrada pelo operador.

Atuei na engenharia Flutter dos fluxos operacionais Android e iOS dessa suíte. O trabalho no Deliver está ligado à experiência de quem usa o aplicativo durante a operação, à representação do estado da entrega e à integração com os serviços do produto. É um contexto em que interface e dados precisam fazer sentido ao longo de uma sequência de ações, e não apenas em uma tela isolada.

## Engine e design system compartilhados entre os apps

O Deliver e o Collect compartilham dois pacotes Flutter privados: engine e design_system, consumidos como dependências Git a partir de repositórios próprios. Trabalhei na construção e evolução dos fluxos dentro dessa estrutura, conectando a interface aos dados e às regras da operação de entrega.

A engine proprietária é baseada em GetX e reúne gerenciamento de estado, controllers, navegação, serviços e funcionalidades reutilizáveis. O design system fornece os temas e componentes visuais, com uma organização baseada em Atomic Design. Essa divisão mantém a infraestrutura e a linguagem visual compartilhadas, ao mesmo tempo que cada aplicativo implementa sua própria jornada operacional.

Trabalhar nos dois produtos trouxe uma visão do caminho entre preparação e entrega e de como as informações circulam entre os aplicativos e os serviços. Essa experiência envolve utilizar e evoluir fluxos sobre uma base comum, considerando também o efeito que os padrões compartilhados têm na consistência e na manutenção da suíte.

## Continuidade da operação com dados offline

A operação em campo inclui situações em que a conectividade não está disponível. O trabalho com fluxos offline e sincronização considera essa realidade: o aplicativo precisa lidar com dados no dispositivo e com sua integração aos serviços. No Deliver, esse contexto faz parte da experiência de rotas, execução e comprovação de entrega apresentada pelo produto.

O desafio envolve acompanhar o estado da operação de forma compreensível para quem está usando o celular. A ação realizada no aplicativo e a informação que chega aos demais sistemas fazem parte do mesmo processo. Essa relação entre experiência mobile e dados foi uma das dimensões da minha atuação nos fluxos da suíte.

## Integração com serviços e acompanhamento logístico

Minha experiência na Lyzer também abrangeu um Backend for Frontend em .NET. Essa camada recebia solicitações do aplicativo Android/mobile, consultava microserviços por GraphQL e HTTP e reunia os dados em uma resposta. Centralizar a composição no backend ajudava a manter essa lógica fora do cliente mobile.

Em frentes relacionadas ao backoffice, trabalhei com componentes reutilizáveis, interface responsiva e refatorações para desempenho e manutenção. O backoffice apoiava a gestão de pedidos, a preparação e o acompanhamento de entregas. Esse trabalho complementou minha experiência com Flutter e ampliou minha visão das relações entre o aplicativo, os serviços e o acompanhamento da operação.

## Manutenção apoiada por investigação e revisão

Para a evolução de Deliver e Collect, utilizei Flutter Agent Skills e Claude com acesso ao Sentry por MCP em fluxos de investigação. A experiência incluiu investigações agendadas e preparação de cards Jira e pull requests com explicações, fontes e testes para revisão. O objetivo era transformar informações sobre os problemas em trabalho de engenharia que pudesse ser analisado pela equipe.

O Deliver tem versões públicas para Android e iOS, acessíveis pelos links oficiais acima. As telas ajudam a visualizar o produto e a diferenciá-lo do Collect. A evidência de downloads é o retrato consultado em julho de 2026; o relato desta página explica minha contribuição no desenvolvimento e na manutenção, dentro de um trabalho coletivo.

## Stack

Flutter · Android · iOS · Proprietary GetX engine · Private Flutter design system · Offline-first · Barcode · .NET BFF · GraphQL

## Prova pública

- [Lyzer Collect · Google Play](https://play.google.com/store/apps/details?id=tech.lyzer.collect): 1 mil+ downloads — Atualizado em 6 jul. 2026 · Consultado em julho de 2026.

- [Lyzer Collect · App Store](https://apps.apple.com/pt/app/lyzer-collect/id6738952338)

- [Lyzer Deliver · Google Play](https://play.google.com/store/apps/details?id=tech.lyzer.deliver): 100+ downloads — Atualizado em 14 jul. 2026 · Consultado em julho de 2026.

- [Lyzer Deliver · App Store](https://apps.apple.com/br/app/lyzer-deliver/id6748221787)

## Imagens oficiais da loja

![Lyzer Collect · Telas publicadas na loja 1](https://leonedaher.com/assets/apps/lyzer-collect-01.png)

![Lyzer Collect · Telas publicadas na loja 2](https://leonedaher.com/assets/apps/lyzer-collect-02.png)

![Lyzer Deliver · Telas publicadas na loja 1](https://leonedaher.com/assets/apps/lyzer-deliver-01.png)

![Lyzer Deliver · Telas publicadas na loja 2](https://leonedaher.com/assets/apps/lyzer-deliver-02.png)

## Proveniência e limites

- A contagem de 14 apps corresponde ao inventário de entregas Android e iOS da Latitudde/Conkord. MAG Venda Digital não é somado a essa contagem; ela não representa 14 produtos de autoria individual.
- Os cases registram a atuação e a contribuição de Leone em equipes. A existência de um app na loja comprova o produto publicado, mas não estabelece autoria exclusiva ou responsabilidade por todo o produto.
- As métricas de loja são retratos consultados em julho de 2026. Valores com + e resumos arredondados, como 11,5 mil+, não são contagens exatas nem medidas atuais; avaliações, downloads e disponibilidade podem mudar.

## Fontes públicas

[Página do portfólio](https://leonedaher.com/pt/apps/lyzer-deliver/)
