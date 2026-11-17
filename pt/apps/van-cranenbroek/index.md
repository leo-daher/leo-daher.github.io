# Van Cranenbroek

Ofertas, folhetos, lojas e comunicação com clientes em um produto multiplataforma.

**Resumo publicado:** 11,5 mil+ downloads · Flutter · Kotlin · Swift

Consultado em julho de 2026.

## Contexto

Varejo · Países Baixos · Android e iOS

## Minha atuação

Engenharia mobile em colaboração com a equipe da Latitudde.

## Contribuição

Atuação em Flutter com GetX, GetIt/Injectable e Provider, Firebase/Firestore, deep links, mapas e SVGs interativos, GitLab CI/CD e Fastlane, além de Cloud Functions em Python.

## Um aplicativo que aproxima o cliente da loja

A Van Cranenbroek é um projeto de varejo nos Países Baixos, com um aplicativo Flutter para Android e iOS que reúne ofertas, folhetos, informações sobre lojas e canais de comunicação com os clientes. O produto conecta a consulta pelo celular à visita à loja: além de acompanhar o conteúdo da empresa, o usuário encontra informações que ajudam a planejar sua ida e a navegar até o estabelecimento.

Meu trabalho pela Latitudde envolveu o desenvolvimento do produto mobile, integrações com recursos nativos e serviços de backend. Também liderei o desenvolvimento e conduzi reuniões semanais diretamente com o cliente para alinhar requisitos, escopo e custos. Esse contato fazia parte da construção do produto, permitindo discutir o que precisava ser entregue e como cada pedido se encaixava na solução.

## Flutter e os recursos de cada plataforma

A aplicação utiliza Flutter para compartilhar a interface entre Android e iOS. Na implementação, trabalhei com GetX e GetIt, além das integrações com Firebase e Firestore. Gerenciamento de estado, acesso a serviços e apresentação de dados fazem parte dessa base que sustenta os diferentes fluxos do aplicativo.

Também defini a arquitetura híbrida Flutter/Kotlin e trabalhei com integrações Android/Kotlin e iOS/Swift. Um exemplo concreto no iOS é um MethodChannel entre Dart e Swift que envia os dados da loja para um seletor nativo de aplicativos de mapas. Essa integração liga uma ação iniciada no Flutter a uma experiência própria da plataforma, respeitando as opções de navegação disponíveis no dispositivo.

## Mapas, localização e navegação

Uma das partes do trabalho foi a navegação para as lojas por meio de deep links com consultas e coordenadas. Em vez de mostrar apenas um endereço, o aplicativo oferece uma ligação entre a informação da loja e o recurso de mapas usado pelo cliente. O fluxo Android registrado utiliza uma integração Flutter para abrir o mapa; no iOS, o seletor de aplicativos inclui a comunicação nativa com Swift.

O projeto também incluiu um mapa SVG interativo com pins posicionados por coordenadas relativas. Essa abordagem permite associar pontos de interesse à representação visual do mapa, mantendo sua posição vinculada ao desenho. Foi uma frente de interface que exigiu trabalhar tanto a interação quanto a correspondência entre os dados de localização e os elementos exibidos.

## Serviços Python por trás da experiência mobile

Desenvolvi Google Cloud Functions em Python para funcionalidades de comunicação. Uma delas atendia ao envio de pedidos de suporte por email e ao cadastro na newsletter. Outra integrava a Facebook API para alimentar um feed personalizado no aplicativo, com publicações da empresa, total de seguidores e ações para acompanhar a página.

A integração com o Facebook incluía uma estratégia de cache no backend. O serviço decidia quando buscar conteúdo atualizado e quando responder com os dados já disponíveis, compartilhando esse resultado entre as requisições dos aplicativos. Isso evitava que cada celular precisasse consultar diretamente a API externa e reduzia chamadas desnecessárias, sem depender de uma implementação separada em cada cliente mobile.

## Comunicação, entrega e relação com o cliente

Configurei Firebase Cloud Messaging e Firestore para notificações e gestão de dados, além de processos automatizados de CI/CD. O trabalho, portanto, abrangia tanto a experiência dentro do aplicativo quanto os serviços que forneciam conteúdo e o processo de preparar novas versões para Android e iOS.

A Van Cranenbroek foi o primeiro projeto da Latitudde na Holanda. O produto recebeu uma avaliação muito positiva do cliente e ajudou a abrir portas para a empresa nos Países Baixos. Os links e as telas acima mostram o aplicativo publicado; as métricas exibidas preservam a consulta registrada em julho de 2026. O case reúne minha atuação em produto, mobile e backend dentro desse trabalho com a equipe.

## Stack

Flutter · GetX · GetIt · Injectable · Provider · Firebase · Firestore · Python · CI/CD

## Prova pública

- [Google Play](https://play.google.com/store/apps/details?id=nl.vancranenbroek): 4,6 ★ · 179 avaliações · 5 mil+ — Consultado em julho de 2026.

- [App Store](https://apps.apple.com/nl/app/van-cranenbroek/id6462761167): 4,7 ★ · 143 avaliações · 6,5 mil+ — Consultado em julho de 2026.

## Imagens oficiais da loja

![Van Cranenbroek · Telas publicadas na loja 1](https://leonedaher.com/assets/apps/van-cranenbroek-01.png)

![Van Cranenbroek · Telas publicadas na loja 2](https://leonedaher.com/assets/apps/van-cranenbroek-02.png)

![Van Cranenbroek · Telas publicadas na loja 3](https://leonedaher.com/assets/apps/van-cranenbroek-03.png)

## Proveniência e limites

- A contagem de 14 apps corresponde ao inventário de entregas Android e iOS da Latitudde/Conkord. MAG Venda Digital não é somado a essa contagem; ela não representa 14 produtos de autoria individual.
- Os cases registram a atuação e a contribuição de Leone em equipes. A existência de um app na loja comprova o produto publicado, mas não estabelece autoria exclusiva ou responsabilidade por todo o produto.
- As métricas de loja são retratos consultados em julho de 2026. Valores com + e resumos arredondados, como 11,5 mil+, não são contagens exatas nem medidas atuais; avaliações, downloads e disponibilidade podem mudar.

## Fontes públicas

[Página do portfólio](https://leonedaher.com/pt/apps/van-cranenbroek/)
