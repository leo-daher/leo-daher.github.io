# Leone Daher — identidade LD

O monograma combina duas leituras: **LD** e **viewport**. O `L` define a lateral e a base; o `D` completa a superfície adaptativa com curvas amplas. A abertura superior permanece real e preserva a leitura das iniciais. O conteúdo recebe um recuo interno seguro, por isso nunca vaza pela abertura.

## Paleta

- Fundo: `#08080D`
- L claro: `#F3F6F5`
- D claro: `#CFC7F4`
- L escuro: `#111318`
- D escuro: `#30313A`
- FAB Material 3: `#FF6B55`
- Acento interativo: `#9A7BFF`

## Elemento de ação

O antigo home indicator foi substituído por um squircle monocromático no canto inferior direito. O volume coral flutua dentro da curva do `D` com uma elevação curta, sugerindo um floating action button do Material Design sem depender de qualquer ícone interno. A forma representa a ação disponível e o ponto onde uma interface se transforma em produto.

O centro do raio da quina inferior direita é a âncora geométrica do elemento. A curva inferior direita do squircle é concêntrica a esse raio; a regra permanece válida quando o frame muda entre mobile, tablet e desktop.

## Movimento

- Na abertura da página, o monograma nasce centralizado e quadrado. Cada aresta se expande de forma independente até ultrapassar a borda correspondente, transformando progressivamente o frame na proporção da viewport atual.
- O squircle parte da posição concêntrica dentro da logo e percorre uma linha reta até o FAB real, crescendo durante o deslocamento sem acompanhar o frame para fora da tela.
- A logo permanece completamente formada e imóvel por `1000ms`. Em seguida, a transição dura `2100ms`; o frame desaparece por recorte espacial, não por redução de opacidade.
- Estados: mobile, tablet e desktop.
- Duração de transição: `900ms`, curva `easeInOutCubic`.
- Permanência: aproximadamente `4.8s` por estado.
- A espessura do traço não muda; apenas proporção e raio do frame.
- O FAB mantém a mesma relação visual com o canto inferior direito em todos os formatos.
- Com animações reduzidas, o frame permanece no estado mobile.

## Reduções

- Até 16 px: remover sombra e microcorte; preservar abertura, LD e a massa coral do FAB.
- A partir de 32 px: usar a construção completa.
- Em ícones maskable: manter o símbolo dentro de 80% da área central.
