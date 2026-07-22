# Leone Daher — diretrizes da marca LD

- **Status:** identidade oficial
- **Versão:** 1.0
- **Fonte visual canônica:** `assets/brand/`
- **Tokens do produto:** `lib/brand/leone_brand.dart`

## 1. Plataforma da marca

### Nome e arquitetura

- **Marca principal:** Leone Daher.
- **Símbolo:** LD.
- **Leitura técnica secundária:** Leone Developer.
- **Descritor principal:** Mobile Software Engineer.
- **Competências adjacentes:** sistemas conectados, backend e automação com IA.

O hero mantém o descritor principal permanentemente em foco e não apresenta um
seletor entre Mobile e IA.

`Leone Developer` amplia o significado das iniciais, mas não substitui o nome
Leone Daher nem deve aparecer como uma segunda assinatura concorrente.

### Ideia central

> **A marca se torna a interface.**

A identidade não desenha apenas um dispositivo. Ela assume a proporção da
superfície em que está sendo vista e transforma um elemento do símbolo em um
controle funcional. O comportamento é a prova da promessa da marca.

### Essência

> **Adaptação com intenção.**

### Propósito

Dar forma a software que funciona no contexto real de quem usa.

### Promessa

Preservar a intenção do produto enquanto sua forma se adapta à tela, à janela e
ao sistema que o sustenta.

### Posicionamento

Para equipes de produto, empresas e recrutadores que precisam de experiências
mobile sólidas e conectadas, Leone Daher combina Flutter, arquitetura e
automação para construir produtos capazes de assumir a forma certa em cada
superfície. A diferença é demonstrada pela própria identidade: ela muda de
proporção, preserva sua estrutura e termina em uma ação real.

### Assinaturas

- **Português:** `SUAS IDEIAS. EM TODO LUGAR.`
- **Inglês:** `YOUR IDEAS. EVERYWHERE.`
- **Frase de apoio:** `A forma muda. A intenção permanece.`

As versões são localizadas e não devem aparecer juntas na mesma peça.

## 2. Arquitetura de significado

### L — Estrutura

A lateral e a base do monograma representam engenharia, sustentação e
consistência. A forma se adapta sem perder o que mantém o produto íntegro.

### D — Superfície

A curva completa o monograma e cria a leitura de viewport. Ela representa
produto, interface e a capacidade de responder ao espaço disponível.

### Ponto de ação — Squircle

O quadrado coral de cantos arredondados flutua no canto inferior direito. Na
linguagem da marca ele é chamado de **squircle**; tecnicamente, a matriz atual é
um retângulo arredondado por raios circulares, não uma superelipse matemática.
Ele representa ação disponível, intenção e transformação de interface em
produto utilizável.

Esses significados produzem três pilares verbais:

1. **Estrutura que sustenta.**
2. **Forma que se adapta.**
3. **Ação que entrega.**

Mobile é o ponto de entrada. Serviços, dados e inteligência são a continuidade
do produto além da tela.

## 3. Construção do símbolo

### Matriz oficial

A construção estática usa um artboard de `256 × 256` unidades:

| Elemento | Construção |
| --- | --- |
| Margem de referência | `24` unidades |
| Traço principal | `14` unidades, caps e joins arredondados |
| Curva inferior do L | `36` unidades |
| Curvas direitas do D | `46` unidades |
| Squircle | `48 × 48`, raio `17`, origem em `(155, 155)` |
| Microcorte da base | diagonal de `(176, 240)` a `(188, 224)`, traço `4` |

O canto inferior direito do D e o canto equivalente do squircle compartilham a
mesma **âncora construtiva** em `(186, 186)`. Essa relação é a regra que mantém o
elemento de ação opticamente preso à curva quando o frame muda de proporção.

### Invariantes

- A abertura superior esquerda deve permanecer real.
- L e D devem continuar legíveis sem virar o desenho literal de um telefone.
- O microcorte inferior preserva a separação óptica das iniciais em tamanhos
  completos.
- O conteúdo inserido no frame deve respeitar o recuo interno e nunca escapar
  pela abertura.
- O squircle permanece no canto inferior direito e conserva a âncora
  construtiva compartilhada com o D.
- O SVG quadrado nunca deve ser esticado para simular responsividade. A versão
  adaptativa reconstrói arestas, curvas, traço e âncora para o espaço disponível.
- A versão dinâmica preserva **peso óptico**, não espessura numérica fixa.

### Área de proteção

Defina `X` como a espessura do traço mestre (`14` unidades). A área livre mínima
ao redor do símbolo é `2X`, equivalente a `28` unidades ou `10,94%` do artboard.
Não coloque texto, bordas, ilustrações ou outros logotipos dentro dessa área.

Em ícones maskable, prevalece a safe zone da plataforma: mantenha o símbolo
dentro dos `80%` centrais.

### Tamanhos mínimos

- **32 px ou mais:** usar a construção completa.
- **16–31 px:** usar a redução otimizada de favicon, sem depender de sombra ou
  microdetalhes para a leitura.
- **Abaixo de 16 px:** não usar o monograma completo.
- **Impressão:** mínimo recomendado de `8 mm`.

## 4. Versões autorizadas

| Asset | Uso | Fundo recomendado |
| --- | --- | --- |
| `ld-mark-inverse.svg` | versão principal digital | Canvas e fundos escuros |
| `ld-mark.svg` | versão para fundos claros | branco, gelo ou superfícies muito claras |
| `ld-mark-mono.svg` | impressão ou aplicação de uma cor | fundos claros |
| `web/favicon-squircle.svg` | redução de navegador | uso próprio no favicon |
| `web/icons/ld-maskable.svg` | PWA e ícone maskable | uso próprio da plataforma |

O squircle da **marca estática** permanece sem ícone. Quando ele deixa de ser
símbolo e se torna um controle real, deve receber affordance, tooltip, nome
acessível e estado.

## 5. Identidade dinâmica

### Princípio responsivo

“Dispositivo” significa o espaço realmente concedido à aplicação: viewport,
janela redimensionada, split-screen, tablet, desktop ou tela cheia. A marca não
detecta categorias de hardware; ela responde às constraints disponíveis.

### Abertura da página

1. O monograma nasce quadrado e centralizado.
2. Permanece integralmente visível por `1000 ms`.
3. Durante os `2100 ms` seguintes, o frame se reconstrói até coincidir com a
   viewport real.
4. Há uma passagem perceptível pelo retângulo exato da viewport: nesse instante,
   a marca forma a superfície usada por quem está vendo.
5. O frame ultrapassa as bordas e desaparece por recorte espacial, revelando o
   produto. Ele não gira, encolhe ou dissolve.
6. Em paralelo, o squircle percorre uma linha direta até o canto inferior
   direito, cresce e assume a geometria do FAB funcional.

| Fase | Regra |
| --- | --- |
| Permanência | `1000 ms` |
| Transformação | `2100 ms` |
| Total | `3100 ms` |
| Curva espacial | `easeInOutCubic` |
| FAB final | `56 × 56 dp`, raio `16 dp`, elevação `6 dp` |
| Posição final | `16 dp` das bordas direita e inferior, somados às safe areas |

Cada eixo percorre a distância necessária para a proporção atual; a identidade
não pressupõe que largura e altura cresçam na mesma medida.

### Frame de apresentação

O hero alterna automaticamente entre proporções mobile (`178 × 308`), tablet
(`316 × 240`) e desktop/web (`620 × 260`), sempre ajustadas ao espaço real com
`LayoutBuilder`. Não há seletor de dispositivo nem FAB demonstrativo. Um único
frame apresenta a composição completa, e os mesmos elementos abstratos de
interface reorganizam sua hierarquia em cada formato. Em janelas estreitas, o
palco fica ancorado no topo: tablet e desktop permanecem inteiros na primeira
tela, enquanto a proporção mobile pode avançar além da área visível. O contorno
adaptativo usa as cores da versão autorizada da logo para o tema atual, preserva
a abertura superior esquerda e o microcorte inferior. As curvas do conteúdo e
do contorno compartilham os mesmos centros geométricos e são construídas com
arcos circulares, mantendo distância constante entre as bordas. No encontro
inferior, os segmentos terminam sem sobreposição antes da máscara diagonal, para
que as cores de L e D não vazem através do microcorte. O monograma da abertura e
o frame de apresentação usam a mesma construção de paths, caps, arcos e máscara;
a animação muda apenas as dimensões e a âncora do canto inferior direito.

### Redução de movimento

- A abertura é pulada e a interface final, com o FAB em seu destino, aparece
  imediatamente.
- O frame permanece no formato atual e não inicia o ciclo automático.

## 6. FAB e Material Design 3

O ponto coral nasce como parte proprietária da assinatura e termina como um
componente de interface. A mudança de geometria é intencional:

- **Na marca:** `48 × 48`, raio `17`, sem ícone.
- **Ao se tornar FAB:** `56 × 56 dp`, raio `16 dp`, ícone de `24 dp`.
- **Menu expandido:** o toggle morfa para círculo de raio `28 dp` e usa ícone de
  fechar com `20 dp`.

Regras funcionais do menu:

- ancoragem em `bottomEnd`, inset mínimo de `16 dp`;
- itens com `56 dp` de altura, formato pill, espaçamento vertical de `4 dp`;
- distância de `8 dp` entre o último item e o toggle;
- expansão dos itens de baixo para cima e recolhimento no sentido inverso;
- fechamento por seleção, toque externo, `Escape` ou ação de voltar;
- suporte a toque, mouse, teclado, foco e leitor de tela;
- itens recolhidos fora de hit testing, foco e árvore semântica.

Coral é reservado a ação e transformação. Não deve virar uma cor decorativa de
uso indiscriminado.

## 7. Sistema de cores

### Paleta principal

| Token | Hex | Papel |
| --- | --- | --- |
| Canvas | `#08080D` | fundo dominante e foreground sobre coral/violeta |
| Surface | `#0E0E18` | painéis e elevação baixa |
| Surface raised | `#151426` | superfícies elevadas |
| Ink | `#F3F6F5` | texto principal e L sobre fundo escuro |
| Muted ink | `#A5A2B4` | texto secundário |
| D lavender | `#CFC7F4` | D e superfície adaptativa sobre fundo escuro |
| Action coral | `#FF6B55` | ação, FAB e transformação |
| Interactive violet | `#9A7BFF` | seleção, foco e interação fora do FAB |
| L dark | `#111318` | L e monocromia sobre fundo claro |
| D dark | `#30313A` | D sobre fundo claro |

### Acentos editoriais

- `#55B8FF`: inteligência, automação e contexto informacional.
- `#FF6F91`: destaque editorial; não substitui o coral de ação.
- `#FFB464`: calor e ênfase pontual.

Esses acentos podem organizar conteúdo e projetos, mas nunca recolorem o
monograma principal.

### Contraste e combinações

| Par | Contraste |
| --- | ---: |
| Ink / Canvas | `18,38:1` |
| D lavender / Canvas | `12,49:1` |
| Muted ink / Canvas | `8,02:1` |
| Action coral / Canvas | `7,12:1` |
| Interactive violet / Canvas | `6,33:1` |

- Sobre coral e violeta, prefira `#08080D` para texto e ícones.
- Branco ou Ink sobre coral não atende contraste para texto normal (`2,58:1`).
- Cor nunca é o único indicador de estado; combine-a com forma, rótulo, ícone ou
  semântica.

## 8. Tipografia

A família oficial é **Inter Variable**.

| Papel | Peso | Tratamento |
| --- | --- | --- |
| Display | 700–800 | tracking negativo moderado, linhas compactas |
| Título | 700–800 | curto, direto e em sentence case |
| Corpo | 400–500 | entrelinha confortável e largura controlada |
| Label técnico | 700–800 | caixa alta, tracking amplo, textos curtos |

- Monoespaçada é reservada a código real; não deve simular “estética developer”.
- Evite fontes futuristas, outlines e blocos longos em caixa alta.
- A assinatura tipográfica `LEONE DAHER` pode acompanhar o símbolo, mas nunca
  deve ser incorporada aos paths do monograma.

## 9. Composição e linguagem visual

- Use grandes superfícies escuras, recuos seguros e hierarquia clara.
- O canto inferior direito é o território preferencial de ação.
- Trate a abertura superior como respiro, não como falha a preencher.
- Frames organizam conteúdo com intenção; não contorne todas as seções.
- Prefira demos, interfaces reais, decisões técnicas e evidência de produto.
- Use gradientes apenas como profundidade ambiental, nunca dentro do monograma.
- Evite imagens cyberpunk genéricas, chuva de código, robôs, cérebros de IA,
  mãos tocando hologramas ou mockups sem relação com o trabalho real.
- Não adicione notch, alto-falante, home indicator ou câmera ao símbolo.

## 10. Voz da marca

A marca fala de forma direta, concreta e humana.

### Personalidade

- **Adaptável, não instável.** Muda o contêiner, preserva intenção.
- **Precisa, não rígida.** Toda decisão visual ou técnica tem motivo.
- **Ativa, não frenética.** Movimento sempre conduz a uma função.
- **Autoral, não autocentrada.** A assinatura aparece no modo de construir.
- **Confiante, não inflada.** Trabalho e resultado vêm antes do superlativo.
- **Técnica, não hermética.** Usa termos corretos e explica o valor deles.

### Regras de escrita

- Prefira primeira pessoa do singular: “eu projeto”, “eu construí”, “eu
  validei”. Use “nós” apenas para colaboração real.
- Comece pelo resultado ou pela decisão mais importante.
- Use verbos ativos e uma ideia principal por frase.
- Mostre problema, decisão e efeito; não liste tecnologia sem contexto.
- Use Flutter, viewport e FAB quando os termos ajudam a explicar o produto.
- Não misture português e inglês no mesmo bloco. Cada versão deve ser
  integralmente localizada.
- Evite “inovador”, “disruptivo”, “solução 360”, “seamless” e “tecnologia de
  ponta” sem prova concreta.

**Exemplo alinhado**

> A interface se adapta à superfície. A arquitetura preserva estado, contexto e
> intenção.

**Exemplo a evitar**

> Criando soluções inovadoras e disruptivas com experiências digitais seamless.

### Manifesto curto

> Eu construo para telas que mudam, pessoas que se movem e sistemas que precisam
> continuar funcionando. Por isso, esta marca não desenha um aparelho: assume a
> proporção de quem a vê. O L dá estrutura. O D abre a superfície. O squircle
> transforma presença em ação. A forma muda; a intenção permanece.

## 11. Aplicações

- **Cabeçalho:** marca inversa entre `28–34 px`, acompanhada de `LEONE DAHER`.
- **Avatar e app icon:** fundo Canvas e marca centralizada; não combinar com
  fotografia no mesmo contêiner.
- **Case studies:** o frame pode conter produto ou screenshot, sempre com recuo
  seguro e sem vazamento pela abertura.
- **Vídeo:** expansão do frame ou percurso do squircle podem funcionar como
  transição; nunca como spinner ou loading infinito.
- **Projetos:** cores próprias podem viver dentro do case, sem alterar a marca
  principal.
- **Currículo e impressão:** usar a versão monocromática quando a reprodução de
  cor não for confiável.

## 12. Usos incorretos

- Esticar o SVG para simular responsividade.
- Fechar a abertura superior.
- Reposicionar o squircle “no olho”.
- Transformar o frame em um telefone literal.
- Inserir `</>`, cursor, raio ou iconografia clichê dentro da marca.
- Aplicar gradiente, textura ou fotografia nos paths do monograma.
- Trocar o coral pela cor de cada projeto.
- Usar o squircle como enfeite sem relação com ação.
- Animar com bounce, rotação, partículas ou comportamento de loading.
- Tratar Leone Daher e Leone Developer como marcas distintas.
- Incorporar tagline permanentemente ao desenho da logo.

## 13. Governança

- `assets/brand/` contém a identidade oficial atual.
- `lib/brand/leone_brand.dart` é a fonte executável dos tokens do portfólio.
- `web/` contém derivados específicos de favicon, PWA e plataformas.
- Explorações fora de `assets/brand/` não são automaticamente aprovadas.
- Mudanças em cor, geometria, motion ou significado exigem atualização conjunta
  deste documento, dos tokens e dos testes.
- Não edite SVG, painter e favicon de forma independente quando a mudança afetar
  uma relação construtiva compartilhada.

## 14. Checklist de aprovação

Uma aplicação só pertence ao sistema se todas as respostas forem “sim”:

- LD continua legível?
- A abertura superior foi preservada?
- A âncora compartilhada do D e do squircle continua correta?
- A adaptação foi reconstruída para o espaço, não esticada?
- Coral indica ação ou transformação?
- O movimento termina em função?
- A mensagem apresenta uma decisão ou prova concreta?
- A aplicação funciona com redução de movimento?
- Alvos, foco, semântica e contraste são acessíveis?
- O resultado parece produto real, e não estética genérica de tecnologia?
