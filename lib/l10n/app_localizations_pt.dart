// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Leone Daher — Engenheiro de Software';

  @override
  String get openingSemantics => 'Leone Daher. A marca se adapta à tela.';

  @override
  String get languageSelectorLabel => 'Escolher idioma';

  @override
  String get portugueseLanguage => 'Português';

  @override
  String get englishLanguage => 'English';

  @override
  String get switchToLightTheme => 'Mudar para tema claro';

  @override
  String get switchToDarkTheme => 'Mudar para tema escuro';

  @override
  String get hireMe => 'Vamos conversar';

  @override
  String get hireMeCompact => 'Conversar';

  @override
  String get viewApps => 'Ver apps';

  @override
  String get viewAppsCompact => 'Apps';

  @override
  String get dismissNavigationMenu => 'Descartar menu de navegação';

  @override
  String get navHome => 'Início';

  @override
  String get navApps => 'Apps';

  @override
  String get navSystem => 'Arquitetura';

  @override
  String get navClients => 'Clientes';

  @override
  String get navContact => 'Contato';

  @override
  String get navExperience => 'Experiência';

  @override
  String get openNavigationMenu => 'Abrir menu de navegação';

  @override
  String get closeNavigationMenu => 'Fechar menu de navegação';

  @override
  String get expanded => 'Expandido';

  @override
  String get collapsed => 'Recolhido';

  @override
  String get closeMenu => 'Fechar menu';

  @override
  String get articlesEyebrow => 'ARTIGOS';

  @override
  String get articlesTitle =>
      'Ideias, aprendizados e decisões por trás do produto.';

  @override
  String get articlesCopy =>
      'Um espaço para compartilhar processos, conhecimento técnico e o que aprendo construindo produtos reais.';

  @override
  String get articlesPageTitle => 'Artigos';

  @override
  String get articleNavigationSemantics => 'Navegação rápida entre artigos';

  @override
  String currentArticle(String title, String summary) {
    return 'Artigo atual: $title. $summary';
  }

  @override
  String openArticle(String title, String summary) {
    return 'Abrir artigo: $title. $summary';
  }

  @override
  String articlePublishedAt(DateTime date, DateTime time, String timeZone) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Publicado em $dateString · $timeString $timeZone';
  }

  @override
  String articleLastEditedAt(DateTime date, DateTime time, String timeZone) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Última edição em $dateString · $timeString $timeZone';
  }

  @override
  String get identityArticleTitle =>
      'Como desenvolvi a logo e a identidade visual deste portfólio';

  @override
  String get identityArticleSummary =>
      'O processo por trás do símbolo LD, da linguagem visual e da ideia de transformar a própria marca em interface.';

  @override
  String get identityArticleIntro =>
      'A logo combina as minhas iniciais — L.D. — com o contorno de uma tela. Eu queria ligar o símbolo ao desenvolvimento mobile sem desenhar um telefone de forma literal. Por isso, o monograma funciona ao mesmo tempo como assinatura e como frame de interface.';

  @override
  String get identityArticleLogoCaption =>
      'A forma completa reúne as iniciais, o frame e o ponto de ação.';

  @override
  String get identityArticleLogoSemantics =>
      'Logo LD formada pelas letras L e D, pelo contorno de uma tela e por um ponto laranja no canto inferior direito.';

  @override
  String get identityArticleStructureEyebrow => 'CONSTRUÇÃO';

  @override
  String get identityArticleStructureTitle => 'As iniciais e o frame';

  @override
  String get identityArticleStructureBody =>
      'O L forma a lateral esquerda e a base. O D completa o topo e a curva direita, criando a leitura de uma tela. Na junção inferior, um pequeno corte diagonal impede que os dois traços pareçam uma única linha e mantém a separação visual entre L e D.';

  @override
  String get identityArticleExplodedCaption =>
      'Vista explodida do L, do D, do microcorte e do ponto laranja.';

  @override
  String get identityArticleExplodedSemantics =>
      'Vista explodida da logo com o L separado à esquerda, o D separado à direita, o microcorte diagonal destacado na base e o ponto laranja afastado do frame.';

  @override
  String get identityArticleLLabel => 'L · estrutura';

  @override
  String get identityArticleDLabel => 'D · frame da tela';

  @override
  String get identityArticleCutLabel => 'Microcorte · separação';

  @override
  String get identityArticleDotLabel => 'Ponto · L.D. e ação';

  @override
  String get identityArticleFabEyebrow => 'MATERIAL DESIGN 3';

  @override
  String get identityArticleFabTitle => 'O ponto que vira ação';

  @override
  String get identityArticleFabBody =>
      'O ponto coral — um laranja vibrante — cumpre duas funções. Na assinatura, ele representa o ponto de L.D. Dentro da tela formada pelas letras, ocupa a posição de um botão de ação flutuante (FAB), um dos componentes mais reconhecíveis do Material Design 3.';

  @override
  String get identityArticleFabColorBody =>
      'A relação não é apenas visual. Quando o site termina de abrir, esse mesmo elemento se torna o botão que dá acesso à navegação. O laranja fica reservado à ação e à transformação; as outras cores vibrantes aparecem como destaques da interface.';

  @override
  String get identityArticleFabCaption =>
      'Do ponto da assinatura ao FAB funcional no canto inferior direito.';

  @override
  String get identityArticleFabSemantics =>
      'Comparação entre o ponto laranja dentro da logo e o FAB funcional com ícone de menu.';

  @override
  String get identityArticleBrandDotStage => 'Ponto da marca';

  @override
  String get identityArticleFunctionalFabStage => 'FAB funcional';

  @override
  String get identityArticleMotionEyebrow => 'MOVIMENTO';

  @override
  String get identityArticleMotionTitle => 'Quando a logo se torna a página';

  @override
  String get identityArticleMotionBody =>
      'Na abertura, a logo aparece centralizada. A aplicação mede a viewport — a área disponível da tela ou da janela — e reconstrói o frame para essa proporção. Cada borda avança em direção ao lado correspondente enquanto o ponto percorre o caminho até o canto inferior direito.';

  @override
  String get identityArticleMotionEffectBody =>
      'O frame coincide por um instante com a viewport e depois ultrapassa seus limites. Nesse momento, a interface que já está posicionada atrás dele é revelada e o ponto assume a forma e a função do FAB. O efeito é direto: o visitante entra na logo, e a marca passa a ser a superfície do site.';

  @override
  String get identityArticleMotionCaption =>
      'Sequência da abertura: logo centralizada, expansão, viewport e interface com o FAB.';

  @override
  String get identityArticleMotionSemantics =>
      'Quatro etapas da abertura do site: logo centralizada, frame em expansão, frame coincidindo com a viewport e interface revelada com o FAB no canto inferior direito.';

  @override
  String get identityArticleOpeningLogoStage => 'Logo';

  @override
  String get identityArticleOpeningExpansionStage => 'Expansão';

  @override
  String get identityArticleOpeningViewportStage => 'Viewport';

  @override
  String get identityArticleOpeningInterfaceStage => 'Interface';

  @override
  String get identityArticleConclusion =>
      'A construção se resume a três funções: o L dá estrutura, o D forma a superfície e o ponto concentra a ação. O resultado é um símbolo que funciona como assinatura no estado estático e como interface na abertura da página.';

  @override
  String get shareArticleTitle => 'Compartilhar artigo';

  @override
  String get shareArticleCopy =>
      'Compartilhe este texto pelo canal que preferir.';

  @override
  String get shareOn => 'Compartilhar no';

  @override
  String get yearsBuildingSoftware => '7+ ANOS CONSTRUINDO SOFTWARE';

  @override
  String get mobileEngineer => 'Engenheiro de Software Mobile';

  @override
  String get aiAutomationEngineer => 'Engenheiro de Automação com IA';

  @override
  String get mobileSupporting =>
      'Produtos mobile movidos por sistemas inteligentes e conectados.';

  @override
  String get aiSupporting =>
      'Python, agentes e automação construídos para o trabalho real.';

  @override
  String get aiAutomationTab => 'IA + Automação';

  @override
  String get everySurface => 'SUAS IDEIAS. EM TODO LUGAR.';

  @override
  String get surfaceList => 'mobile  ·  desktop  ·  web';

  @override
  String get proofAppsValue => '16 apps publicados';

  @override
  String get proofAppsLabel => 'apps mobile em lojas oficiais';

  @override
  String get proofMarketsValue => 'LATAM · USA · EU';

  @override
  String get proofMarketsLabel => 'produtos para mercados reais';

  @override
  String get productionAppsSemanticLabel =>
      'Apps publicados em que Leone Daher atuou';

  @override
  String get productionAppsTitle => 'Apps em produção.';

  @override
  String get featuredAppsTitle => 'Apps em destaque';

  @override
  String get featuredAppsSupportingText =>
      'Produtos publicados, lojas reais e detalhes selecionados da entrega.';

  @override
  String get viewAllApps => 'Ver todos';

  @override
  String get allAppsTitle => 'Todos os apps';

  @override
  String get allAppsSupportingText =>
      'Explore os produtos mobile publicados e abra cada case para ver telas, stack e provas públicas nas lojas.';

  @override
  String get openAppDetails => 'Abrir detalhes do app';

  @override
  String get vanCranenbroekStorefrontMetric =>
      '11,5 mil+ downloads · Flutter · Kotlin · Swift';

  @override
  String get lyzerCollectStorefrontSummary =>
      'Coleta e preparação de pedidos para operações de campo conectadas.';

  @override
  String get lyzerCollectStorefrontMetric =>
      '1 mil+ downloads · Flutter · Android · iOS';

  @override
  String get lyzerDeliverStorefrontSummary =>
      'Rotas, operação offline e comprovação de entrega para equipes em campo.';

  @override
  String get lyzerDeliverStorefrontMetric =>
      '100+ downloads · Flutter · Android · iOS';

  @override
  String get magStorefrontMetric => '1 mil+ downloads · Android · Kotlin';

  @override
  String get appRoleLabel => 'Minha atuação';

  @override
  String get appContributionLabel => 'Contribuição';

  @override
  String get appStackLabel => 'Stack';

  @override
  String get appStoreProofLabel => 'Prova pública';

  @override
  String get appScreenshotsLabel => 'Telas publicadas na loja';

  @override
  String get appImageUnavailableLabel => 'Imagem indisponível';

  @override
  String get storeCheckedJuly2026 => 'Consultado em julho de 2026.';

  @override
  String get vanCranenbroekContext => 'Varejo · Países Baixos · Android e iOS';

  @override
  String get vanCranenbroekSummary =>
      'Ofertas, folhetos, lojas e comunicação com clientes em um produto multiplataforma.';

  @override
  String get vanCranenbroekRole =>
      'Engenharia mobile em colaboração com a equipe da Latitudde.';

  @override
  String get vanCranenbroekContribution =>
      'Atuação em Flutter com GetX, GetIt/Injectable e Provider, Firebase/Firestore, deep links, mapas e SVGs interativos, GitLab CI/CD e Fastlane, além de Cloud Functions em Python.';

  @override
  String get vanCranenbroekPlayProof => '4,6 ★ · 179 avaliações · 5 mil+';

  @override
  String get vanCranenbroekAppStoreProof => '4,7 ★ · 143 avaliações · 6,5 mil+';

  @override
  String get lyzerContext => 'Logística · Portugal · Flutter · Android e iOS';

  @override
  String get lyzerSummary =>
      'Suite operacional que conecta coleta, preparação de pedidos, rotas e entrega.';

  @override
  String get lyzerRole =>
      'Engenharia Flutter nos fluxos operacionais Android e iOS da suite Lyzer.';

  @override
  String get lyzerContribution =>
      'Fluxos de picking e entrega construídos sobre uma engine proprietária baseada em GetX, com leitura de códigos de barras, sincronização offline e integrações para operação em campo.';

  @override
  String get lyzerCollectProof => '1 mil+ downloads';

  @override
  String get lyzerCollectProofDetails =>
      'Atualizado em 6 jul. 2026 · Consultado em julho de 2026.';

  @override
  String get lyzerDeliverProof => '100+ downloads';

  @override
  String get lyzerDeliverProofDetails =>
      'Atualizado em 14 jul. 2026 · Consultado em julho de 2026.';

  @override
  String get magContext => 'Seguros · Brasil · Android';

  @override
  String get magSummary =>
      'Ferramenta de venda digital para corretores acompanharem produtos e propostas.';

  @override
  String get magRole => 'Engenharia Android no produto de venda digital.';

  @override
  String get magContribution =>
      'Evolução em Java/Kotlin, dados offline com Realm, flavors Gradle, Firebase/Crashlytics e pipeline no Azure.';

  @override
  String get magPlayProof => '1 mil+ downloads';

  @override
  String get magPlayProofDetails =>
      'Atualizado em 16 jul. 2026 · Consultado em julho de 2026.';

  @override
  String get systemTitle => 'Arquitetura de produto ponta a ponta.';

  @override
  String get architectureProductTitle => 'Produto e mobile';

  @override
  String get architectureProductDetail =>
      'Flutter · Android · iOS · jornadas · estado offline';

  @override
  String get architectureServicesTitle => 'Serviços e dados';

  @override
  String get architectureServicesDetail =>
      'Python · .NET · APIs · GraphQL · Firebase · sincronização';

  @override
  String get architectureDeliveryTitle => 'Entrega e confiabilidade';

  @override
  String get architectureDeliveryDetail =>
      'CI/CD · AWS · Azure · publicação nas lojas · Crashlytics · performance';

  @override
  String get architectureAutomationTitle => 'IA e automação';

  @override
  String get architectureAutomationDetail =>
      'Agentes · ferramentas com LLMs · fluxos em segundo plano';

  @override
  String get deviceLab => 'LABORATÓRIO DE DISPOSITIVOS';

  @override
  String get oneActionEveryScreen => 'Uma ação. Todas as telas.';

  @override
  String get mosaic => 'Mosaico';

  @override
  String get morph => 'Metamorfo';

  @override
  String viewMode(String mode) {
    return 'Visualização $mode';
  }

  @override
  String get deviceDemoCaption =>
      'Explore ofertas, compare preços e salve itens — tudo sincronizado.';

  @override
  String interactiveDealsDevice(String device) {
    return '$device com Radar de Ofertas interativo';
  }

  @override
  String get dealRadar => 'RADAR DE OFERTAS';

  @override
  String get liveDeals => 'OFERTAS AO VIVO';

  @override
  String get searchProduct => 'Buscar produto';

  @override
  String get offers => 'Ofertas';

  @override
  String get compare => 'Comparar';

  @override
  String get saved => 'Salvos';

  @override
  String get removeSaved => 'Remover dos salvos';

  @override
  String get saveDeal => 'Salvar oferta';

  @override
  String get nothingSaved => 'Nada salvo';

  @override
  String get noDeals => 'Nenhuma oferta';

  @override
  String get dealDetails => 'DETALHES DA OFERTA';

  @override
  String get pricesInDatabase => 'PREÇOS NESTA BASE';

  @override
  String get store => 'LOJA';

  @override
  String get threeStores => '3 lojas';

  @override
  String get globalExperience => 'EXPERIÊNCIA GLOBAL';

  @override
  String get experienceTitle => 'Produtos usados no mundo real.';

  @override
  String get experienceCopy =>
      'Mobile, backend, automação e infraestrutura em operações distribuídas por diferentes mercados.';

  @override
  String get certificationsEyebrow => 'CERTIFICAÇÕES';

  @override
  String get certificationsTitle => 'Aprendizado contínuo, com comprovação.';

  @override
  String get certificationsCopy =>
      'Registros oficiais de cursos disponíveis para consulta, com validação na fonte e certificados arquivados.';

  @override
  String verifiedCredentials(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count credenciais verificadas',
      one: '1 credencial verificada',
    );
    return '$_temp0';
  }

  @override
  String get issuers => 'emissores';

  @override
  String get viewCredentials => 'Ver credenciais';

  @override
  String get viewAllCertificates => 'Ver todas as certificações';

  @override
  String get certificateRegister => 'Registro de certificações';

  @override
  String get certificateRegisterCopy =>
      'Navegue pelas credenciais por ano e selecione uma para ver o registro oficial e as opções de validação.';

  @override
  String get filterTechnologies => 'Filtrar por tecnologia';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get technologies => 'Tecnologias';

  @override
  String issuedBy(String issuer) {
    return 'Emitido por $issuer';
  }

  @override
  String get verifyCredential => 'Validar credencial';

  @override
  String certificateFor(String holder) {
    return 'Certificado emitido para $holder';
  }

  @override
  String get closeDialog => 'Fechar diálogo';

  @override
  String get mappedCountries => 'Países mapeados';

  @override
  String get projects => 'Projetos';

  @override
  String projectCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projetos',
      one: '1 projeto',
    );
    return '$_temp0';
  }

  @override
  String get context => 'contexto';

  @override
  String get clientsTitle => 'Clientes';

  @override
  String get directRoles => 'DIRETOS';

  @override
  String get viaLatituddeConsulting => 'VIA LATITUDDE / CONKORD';

  @override
  String brandCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count MARCAS',
      one: '1 MARCA',
    );
    return '$_temp0';
  }

  @override
  String get contactEyebrow => 'CONTATO';

  @override
  String get contactTitle => 'Vamos construir algo incrível juntos.';

  @override
  String get contactCopy =>
      'Para oportunidades, projetos ou uma troca técnica, escolha o canal mais conveniente.';

  @override
  String get contactLinkedIn => 'LinkedIn';

  @override
  String get contactLinkedInCopy =>
      'Experiência, trajetória e contato profissional.';

  @override
  String get contactWhatsApp => 'WhatsApp';

  @override
  String get contactWhatsAppCopy =>
      'Mensagem direta para projetos e oportunidades.';

  @override
  String get contactGitHub => 'GitHub';

  @override
  String get contactGitHubCopy => 'Código público e estudos técnicos.';

  @override
  String get contactSchedule => 'Agendar conversa';

  @override
  String get contactScheduleCopy => 'Calendly · 30 minutos';

  @override
  String get magRecognitionTitle => 'Autenticação e validação de identidade';

  @override
  String get magRecognitionText =>
      'Implementei autenticação e validação de identidade por reconhecimento facial no Venda Digital utilizando a API do SERPRO disponível à época. A publicação abaixo registra a entrega da equipe, da qual Leone Crespo Daher de Souza fez parte.';

  @override
  String get magRecognitionImageLabel =>
      'Publicação de Luis Henrique Fontes Oliveira reconhecendo a equipe Venda Digital e citando Leone Crespo Daher de Souza.';
}
