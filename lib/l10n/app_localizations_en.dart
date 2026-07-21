// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Leone Daher — Software Engineer';

  @override
  String get openingSemantics => 'Leone Daher. The brand adapts to the screen.';

  @override
  String get languageSelectorLabel => 'Choose language';

  @override
  String get portugueseLanguage => 'Português';

  @override
  String get englishLanguage => 'English';

  @override
  String get availableCompact => 'AVAILABLE';

  @override
  String get availableFull => 'OPEN TO NEW CHALLENGES';

  @override
  String get dismissNavigationMenu => 'Dismiss navigation menu';

  @override
  String get navHome => 'Home';

  @override
  String get navSystem => 'System';

  @override
  String get navProjects => 'Projects';

  @override
  String get navExperience => 'Experience';

  @override
  String get openNavigationMenu => 'Open navigation menu';

  @override
  String get closeNavigationMenu => 'Close navigation menu';

  @override
  String get expanded => 'Expanded';

  @override
  String get collapsed => 'Collapsed';

  @override
  String get closeMenu => 'Close menu';

  @override
  String get yearsBuildingSoftware => '7+ YEARS BUILDING SOFTWARE';

  @override
  String get mobileEngineer => 'Mobile Software Engineer';

  @override
  String get aiAutomationEngineer => 'AI Automation Engineer';

  @override
  String get mobileSupporting =>
      'Mobile products powered by smart, connected systems.';

  @override
  String get aiSupporting =>
      'Python, agents and automation built around real work.';

  @override
  String get aiAutomationTab => 'AI + Automation';

  @override
  String get everySurface => 'ONE FRAME · EVERY SURFACE';

  @override
  String get surfaceList => 'mobile  ·  desktop  ·  web';

  @override
  String get systemEyebrow => 'ONE PRODUCT. THE WHOLE SYSTEM.';

  @override
  String get systemTitle => 'Mobile, services and intelligence connected.';

  @override
  String get systemFlow => 'PRODUCT → SYSTEM → RESULT';

  @override
  String get productLabel => '01  /  PRODUCT';

  @override
  String get servicesLabel => '02  /  SERVICES';

  @override
  String get intelligenceLabel => '03  /  INTELLIGENCE';

  @override
  String get backendDetail => 'APIs · data · integrations';

  @override
  String get aiSystems => 'AI Systems';

  @override
  String get aiDetail => 'Agents · LLMs · automation';

  @override
  String get requests => 'REQUESTS';

  @override
  String get contextTools => 'CONTEXT + TOOLS';

  @override
  String get resultsReturnMobile => 'RESULTS RETURN TO MOBILE';

  @override
  String get decisionsReturnProduct =>
      'DECISIONS + ACTIONS RETURN TO THE PRODUCT';

  @override
  String get deviceLab => 'DEVICE LAB';

  @override
  String get oneActionEveryScreen => 'One action. Every screen.';

  @override
  String get mosaic => 'Mosaic';

  @override
  String get morph => 'Morph';

  @override
  String viewMode(String mode) {
    return '$mode view';
  }

  @override
  String get deviceDemoCaption =>
      'Explore deals, compare prices and save items — all synchronized.';

  @override
  String interactiveDealsDevice(String device) {
    return '$device with interactive Deal Radar';
  }

  @override
  String get dealRadar => 'DEAL RADAR';

  @override
  String get liveDeals => 'LIVE DEALS';

  @override
  String get searchProduct => 'Search product';

  @override
  String get offers => 'Deals';

  @override
  String get compare => 'Compare';

  @override
  String get saved => 'Saved';

  @override
  String get removeSaved => 'Remove from saved';

  @override
  String get saveDeal => 'Save deal';

  @override
  String get nothingSaved => 'Nothing saved';

  @override
  String get noDeals => 'No deals found';

  @override
  String get dealDetails => 'DEAL DETAILS';

  @override
  String get pricesInDatabase => 'PRICES IN THIS DATABASE';

  @override
  String get store => 'STORE';

  @override
  String get threeStores => '3 stores';

  @override
  String get featuredSolutions => 'FEATURED SOLUTIONS';

  @override
  String get projectsTitle => 'Code with visible impact.';

  @override
  String get projectsCopy =>
      'Independent projects and product experience turned into demonstrations you can explore.';

  @override
  String get mobileProjectCopy =>
      'Product in motion: adaptive interfaces, synchronized state and native integrations in an experience that flows.';

  @override
  String get agentsProjectCopy =>
      'Intelligence that decides and executes: agents connect context, tools and validation without losing human control.';

  @override
  String get automationProjectCopy =>
      'A measurable process: Python turns repetitive tasks into observable, reproducible and reliable pipelines.';

  @override
  String get globalExperience => 'GLOBAL EXPERIENCE';

  @override
  String get experienceTitle => 'Products used in the real world.';

  @override
  String get experienceCopy =>
      'Mobile, backend, automation and infrastructure across operations distributed in different markets.';

  @override
  String get certificationsEyebrow => 'CERTIFICATIONS';

  @override
  String get certificationsTitle => 'Continuous learning, backed by proof.';

  @override
  String get certificationsCopy =>
      'Official course records available for consultation, with source verification and archived certificates.';

  @override
  String verifiedCredentials(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verified credentials',
      one: '1 verified credential',
    );
    return '$_temp0';
  }

  @override
  String get issuers => 'issuers';

  @override
  String get viewCredentials => 'View credentials';

  @override
  String get certificateRegister => 'Certificate register';

  @override
  String get certificateRegisterCopy =>
      'Browse credentials by year and select one to view the official record and verification options.';

  @override
  String get technologies => 'Technologies';

  @override
  String get verified => 'Verified';

  @override
  String issuedBy(String issuer) {
    return 'Issued by $issuer';
  }

  @override
  String completedIn(String year) {
    return 'Completed in $year';
  }

  @override
  String get verifyCredential => 'Verify credential';

  @override
  String get openArchivedPdf => 'Open archived PDF';

  @override
  String certificateFor(String holder) {
    return 'Certificate issued to $holder';
  }

  @override
  String get closeDialog => 'Close dialog';

  @override
  String get mappedCountries => 'Mapped countries';

  @override
  String get projects => 'Projects';

  @override
  String projectCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projects',
      one: '1 project',
    );
    return '$_temp0';
  }

  @override
  String get context => 'context';

  @override
  String get clientsServed => 'CLIENTS SERVED';

  @override
  String brandCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count BRANDS',
      one: '1 BRAND',
    );
    return '$_temp0';
  }

  @override
  String get footerInvitation => 'Shall we build something that truly works?';

  @override
  String get mobileFormat => 'mobile format';

  @override
  String get tabletFormat => 'tablet format';

  @override
  String get desktopFormat => 'desktop and web format';

  @override
  String viewportInFormat(String format) {
    return 'LD viewport in $format';
  }

  @override
  String showFormat(String format) {
    return 'Show $format';
  }
}
