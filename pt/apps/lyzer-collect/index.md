# Lyzer Collect

Coleta e preparação de pedidos para operações de campo conectadas.

**Resumo publicado:** 1 mil+ downloads · Flutter · Android · iOS

Consultado em julho de 2026.

## Case compartilhado: Lyzer Collect + Deliver

Suite operacional que conecta coleta, preparação de pedidos, rotas e entrega.

## Contexto

Logística · Portugal · Flutter · Android e iOS

## Minha atuação

Engenharia Flutter nos fluxos operacionais Android e iOS da suite Lyzer.

## Contribuição

Fluxos de picking e entrega construídos sobre uma engine proprietária baseada em GetX, com leitura de códigos de barras, sincronização offline e integrações para operação em campo.

## Preparação de pedidos como parte da operação logística

O Lyzer Collect faz parte de uma suíte que conecta gestão de pedidos, preparação, rotas e entrega para operações de varejo e e-commerce. Seu foco está na coleta e preparação dos pedidos, uma etapa em que o trabalho realizado pelo operador precisa se refletir no estado da operação. O aplicativo mobile é uma das interfaces desse processo, ao lado dos serviços e do backoffice logístico.

Minha atuação incluiu engenharia Flutter nos fluxos operacionais da suíte para Android e iOS. Collect e Deliver são produtos relacionados, mas representam momentos diferentes da jornada: o Collect atende à preparação, enquanto o Deliver acompanha a execução da entrega em campo. A experiência compartilhada entre eles também envolve integrações com os sistemas que sustentam essa operação.

## Câmera e leitura de códigos de barras: a primeira versão

Implementei a V1 da câmera para leitura de códigos de barras nos fluxos de picking do Collect. Essa experiência conecta a captura pelo celular à preparação do pedido: o operador aponta a câmera para o produto, e o código reconhecido segue para o fluxo que identifica o item e acompanha sua coleta.

A implementação Flutter da leitura utiliza o pacote camera para controlar a câmera e fornecer as imagens, junto com google_mlkit_barcode_scanning para reconhecer os códigos com Google ML Kit. O scanner é organizado em um serviço e um widget dentro da engine compartilhada, separando a captura e a detecção da lógica específica de preparação de pedidos no Collect.

No fluxo de picking, a leitura alimenta a validação do código, a busca do produto no pedido e o tratamento de situações como um item já coletado ou um código que não pertence àquele pedido. Essa ligação entre câmera e operação transforma a leitura em uma etapa da jornada do operador, com um resultado que precisa ser compreendido e tratado pela interface.

## Engine e design system em dois pacotes Flutter privados

Collect e Deliver compartilham dois pacotes Flutter privados, mantidos em repositórios próprios: engine e design_system. Trabalhei com essa base comum no desenvolvimento dos fluxos dos aplicativos. A separação permite reutilizar infraestrutura e componentes visuais entre produtos que têm jornadas diferentes, mantendo padrões comuns para a suíte Lyzer.

A engine proprietária se apoia em GetX e reúne mais do que gerenciamento de estado: inclui classes base de controllers, navegação, serviços, acesso a dados e funcionalidades reutilizáveis, como o scanner. Já o design system concentra temas, cores, tipografia e componentes de interface, organizados segundo Atomic Design. Cada pacote tem uma responsabilidade própria na construção dos apps.

Os aplicativos consomem os dois pacotes como dependências Git privadas. Na prática, isso conecta os fluxos específicos do Collect a uma infraestrutura compartilhada com o Deliver, enquanto a interface utiliza os mesmos fundamentos visuais e componentes. Minha atuação nesses fluxos precisava considerar tanto as regras da preparação de pedidos quanto as convenções dessa base comum.

## Operação offline e sincronização

A suíte inclui operação offline e sincronização de dados para apoiar o trabalho em campo. Nesse contexto, a interface precisa representar tanto a ação do usuário quanto o estado dos dados disponíveis no dispositivo. A continuidade do fluxo e sua posterior integração com os serviços fazem parte do problema de engenharia, junto com a leitura de códigos de barras e os demais passos da preparação.

Esse trabalho conecta a experiência mobile à operação logística. A preparação de um pedido não termina na tela do operador: ela faz parte de uma jornada que também será acompanhada por outros componentes do produto. Por isso, os fluxos do aplicativo precisam ser compreendidos em conjunto com o backend e o backoffice.

## Backend e backoffice no mesmo contexto de produto

Além do mobile, trabalhei em frentes relacionadas ao backoffice logístico, com componentes reutilizáveis, interface responsiva e refatorações voltadas à manutenção e ao desempenho. Esse contexto incluía gestão de pedidos, preparação e acompanhamento de entregas, em colaboração com outras áreas da equipe.

Outra frente foi um Backend for Frontend em .NET. Ele recebia requisições do aplicativo Android/mobile, consultava os microserviços necessários por GraphQL e HTTP e compunha uma resposta para o cliente. A composição de dados ficava centralizada nessa camada, reduzindo a complexidade que precisaria ser tratada pelo aplicativo. Essas são experiências relacionadas à Lyzer, com responsabilidades que atravessam mais de um produto da suíte.

## Investigação de erros e evolução do aplicativo

O trabalho de engenharia também incluiu Flutter Agent Skills e Claude conectado ao Sentry por MCP para apoiar investigações de Collect e Deliver. Foram utilizados fluxos de investigação agendados e preparação de cards Jira e pull requests com explicações, fontes e testes para revisão. Esse uso de ferramentas fazia parte do acompanhamento e da evolução dos aplicativos.

As telas e os links oficiais desta página permitem consultar os produtos publicados. Os números de downloads mantêm a data da consulta original, em julho de 2026. Minha contribuição combina desenvolvimento mobile, integração com serviços e investigação de problemas, conectando a evolução dos fluxos ao acompanhamento do aplicativo em uso.

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

[Página do portfólio](https://leonedaher.com/pt/apps/lyzer-collect/)
