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
  String get availableCompact => 'DISPONÍVEL';

  @override
  String get availableFull => 'DISPONÍVEL PARA NOVOS DESAFIOS';

  @override
  String get dismissNavigationMenu => 'Descartar menu de navegação';

  @override
  String get navHome => 'Início';

  @override
  String get navSystem => 'Sistema';

  @override
  String get navProjects => 'Projetos';

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
  String get everySurface => 'UM FRAME · TODA TELA';

  @override
  String get surfaceList => 'mobile  ·  desktop  ·  web';

  @override
  String get systemEyebrow => 'UM PRODUTO. O SISTEMA INTEIRO.';

  @override
  String get systemTitle => 'Mobile, serviços e inteligência conectados.';

  @override
  String get systemFlow => 'PRODUTO → SISTEMA → RESULTADO';

  @override
  String get productLabel => '01  /  PRODUTO';

  @override
  String get servicesLabel => '02  /  SERVIÇOS';

  @override
  String get intelligenceLabel => '03  /  INTELIGÊNCIA';

  @override
  String get backendDetail => 'APIs · dados · integrações';

  @override
  String get aiSystems => 'Sistemas de IA';

  @override
  String get aiDetail => 'Agentes · LLMs · automação';

  @override
  String get requests => 'REQUISIÇÕES';

  @override
  String get contextTools => 'CONTEXTO + FERRAMENTAS';

  @override
  String get resultsReturnMobile => 'RESULTADOS VOLTAM AO MOBILE';

  @override
  String get decisionsReturnProduct => 'DECISÕES + AÇÕES VOLTAM AO PRODUTO';

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
  String get projectsTitle => 'Código com impacto visível.';

  @override
  String get projectsCopy =>
      'Projetos próprios e experiência de produto transformados em demonstrações que você pode explorar.';

  @override
  String get mobileProjectCopy =>
      'Produto em movimento: interfaces adaptativas, estado sincronizado e integrações nativas em uma experiência que flui.';

  @override
  String get agentsProjectCopy =>
      'Inteligência que decide e executa: agentes conectam contexto, ferramentas e validação sem perder o controle humano.';

  @override
  String get automationProjectCopy =>
      'Processo mensurável: Python transforma tarefas repetitivas em pipelines observáveis, reproduzíveis e confiáveis.';

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
  String get verified => 'Verificado';

  @override
  String issuedBy(String issuer) {
    return 'Emitido por $issuer';
  }

  @override
  String completedIn(String year) {
    return 'Concluído em $year';
  }

  @override
  String get verifyCredential => 'Validar credencial';

  @override
  String get openArchivedPdf => 'Abrir PDF arquivado';

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
  String get clientsServed => 'CLIENTES ATENDIDOS';

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
  String get footerInvitation =>
      'Vamos construir algo que funcione de verdade?';

  @override
  String get mobileFormat => 'formato mobile';

  @override
  String get tabletFormat => 'formato tablet';

  @override
  String get desktopFormat => 'formato desktop e web';

  @override
  String viewportInFormat(String format) {
    return 'Viewport LD em $format';
  }

  @override
  String showFormat(String format) {
    return 'Mostrar $format';
  }
}
