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
  String get switchToLightTheme => 'Switch to light theme';

  @override
  String get switchToDarkTheme => 'Switch to dark theme';

  @override
  String get hireMe => 'Let\'s talk';

  @override
  String get hireMeCompact => 'Contact';

  @override
  String get contactMenuLabel => 'Contact options';

  @override
  String get dismissNavigationMenu => 'Dismiss navigation menu';

  @override
  String get navHome => 'Home';

  @override
  String get navApps => 'Apps';

  @override
  String get navSystem => 'Architecture';

  @override
  String get navClients => 'Clients';

  @override
  String get navContact => 'Contact';

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
  String get articlesEyebrow => 'ARTICLES';

  @override
  String get articlesTitle =>
      'Ideas, lessons, and decisions behind the product.';

  @override
  String get articlesCopy =>
      'A place to share processes, technical knowledge, and what I learn while building real products.';

  @override
  String get relatedArticlesTitle => 'More to read';

  @override
  String get relatedArticlesSemantics => 'More articles to read';

  @override
  String openArticle(String title, String summary) {
    return 'Open article: $title. $summary';
  }

  @override
  String articlePublishedAt(DateTime date, DateTime time, String timeZone) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Published $dateString · $timeString $timeZone';
  }

  @override
  String articleLastEditedAt(DateTime date, DateTime time, String timeZone) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Last edited $dateString · $timeString $timeZone';
  }

  @override
  String get identityArticleTitle =>
      'How I designed this portfolio\'s logo and visual identity';

  @override
  String get identityArticleSummary =>
      'The process behind the LD symbol, its visual language, and the idea of turning the brand itself into an interface.';

  @override
  String get identityArticleIntro =>
      'The logo combines my initials — L.D. — with the outline of a screen. I wanted to connect the symbol to mobile development without literally drawing a phone. The monogram therefore works both as a signature and as an interface frame.';

  @override
  String get identityArticleLogoCaption =>
      'The complete mark brings together the initials, the frame, and the action dot.';

  @override
  String get identityArticleLogoSemantics =>
      'LD logo formed by the letters L and D, the outline of a screen, and an orange dot in the bottom-right corner.';

  @override
  String get identityArticleStructureEyebrow => 'CONSTRUCTION';

  @override
  String get identityArticleStructureTitle => 'The initials and the frame';

  @override
  String get identityArticleStructureBody =>
      'The L forms the left edge and the base. The D completes the top and the curved right side, creating the outline of a screen. At the lower junction, a small diagonal cut prevents both strokes from reading as a single line and preserves the visual separation between the L and the D.';

  @override
  String get identityArticleExplodedCaption =>
      'Exploded view of the L, the D, the diagonal cut, and the orange dot.';

  @override
  String get identityArticleExplodedSemantics =>
      'Exploded view of the logo with the L separated on the left, the D separated on the right, the diagonal cut highlighted at the base, and the orange dot moved away from the frame.';

  @override
  String get identityArticleLLabel => 'L · structure';

  @override
  String get identityArticleDLabel => 'D · screen frame';

  @override
  String get identityArticleCutLabel => 'Diagonal cut · separation';

  @override
  String get identityArticleDotLabel => 'Dot · L.D. and action';

  @override
  String get identityArticleFabEyebrow => 'MATERIAL DESIGN 3';

  @override
  String get identityArticleFabTitle => 'The dot that becomes a button';

  @override
  String get identityArticleFabBody =>
      'The coral dot — a vibrant orange — serves two purposes. In the signature, it is the dot in L.D. Inside the screen formed by the letters, it occupies the position of a floating action button (FAB), one of Material Design 3\'s most recognizable components.';

  @override
  String get identityArticleFabColorBody =>
      'The relationship is not merely visual. When the site finishes opening, this same element becomes the button that provides access to navigation. Orange is reserved for action and transformation; the other vibrant colors appear as interface accents.';

  @override
  String get identityArticleFabCaption =>
      'From the signature dot to the functional FAB in the bottom-right corner.';

  @override
  String get identityArticleFabSemantics =>
      'Comparison between the orange dot inside the logo and the functional FAB with a menu icon.';

  @override
  String get identityArticleBrandDotStage => 'Brand dot';

  @override
  String get identityArticleFunctionalFabStage => 'Functional FAB';

  @override
  String get identityArticleMotionEyebrow => 'MOTION';

  @override
  String get identityArticleMotionTitle => 'When the logo becomes the page';

  @override
  String get identityArticleMotionBody =>
      'When the site opens, the logo appears centered. The application measures the viewport — the area available within the screen or window — and reconstructs the frame to match its proportions. The four edges extend toward the four sides while the dot travels to the bottom-right corner.';

  @override
  String get identityArticleMotionEffectBody =>
      'The frame briefly matches the viewport and then moves beyond its bounds. At that point, the interface already positioned behind it is revealed, and the dot assumes the form and function of the FAB. The effect is direct: the visitor enters the logo, and the brand becomes the surface of the site.';

  @override
  String get identityArticleMotionCaption =>
      'Opening sequence: centered logo, expansion, viewport, and interface with the FAB.';

  @override
  String get identityArticleMotionSemantics =>
      'Four stages of the site opening: centered logo, expanding frame, frame matching the viewport, and interface revealed with the FAB in the bottom-right corner.';

  @override
  String get identityArticleOpeningLogoStage => 'Logo';

  @override
  String get identityArticleOpeningExpansionStage => 'Expansion';

  @override
  String get identityArticleOpeningViewportStage => 'Viewport';

  @override
  String get identityArticleOpeningInterfaceStage => 'Interface';

  @override
  String get identityArticleConclusion =>
      'The construction can be summarized in three functions: the L provides structure, the D forms the surface, and the dot concentrates the action. The result is a symbol that works as a signature when static and as an interface when the page opens.';

  @override
  String get shareArticleTitle => 'Share article';

  @override
  String get shareArticleCopy =>
      'Share this article through your preferred channel.';

  @override
  String get shareOn => 'Share on';

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
  String get everySurface => 'YOUR IDEAS. EVERYWHERE.';

  @override
  String get surfaceList => 'mobile  ·  desktop  ·  web';

  @override
  String get proofAppsValue => '16 Apps published';

  @override
  String get proofAppsLabel => 'mobile apps in official stores';

  @override
  String get proofMarketsValue => 'LATAM · North America · Europe';

  @override
  String get proofMarketsLabel => 'products for real markets';

  @override
  String get productionAppsSemanticLabel =>
      'Published apps Leone Daher contributed to';

  @override
  String get productionAppsTitle => 'Apps in production.';

  @override
  String get featuredAppsTitle => 'Featured apps';

  @override
  String get featuredAppsSupportingText =>
      'Published products, real stores, and selected delivery details.';

  @override
  String get viewAllApps => 'View all';

  @override
  String get allAppsTitle => 'All apps';

  @override
  String get allAppsSupportingText =>
      'Browse the published mobile products and open each case for screens, stack, and public store proof.';

  @override
  String get openAppDetails => 'Open app details';

  @override
  String get vanCranenbroekStorefrontMetric =>
      '11.5K+ downloads · Flutter · Kotlin · Swift';

  @override
  String get lyzerCollectStorefrontSummary =>
      'Collection and order preparation built for connected field operations.';

  @override
  String get lyzerCollectStorefrontMetric =>
      '1K+ downloads · Flutter · Android · iOS';

  @override
  String get lyzerDeliverStorefrontSummary =>
      'Routes, offline execution, and proof of delivery for field teams.';

  @override
  String get lyzerDeliverStorefrontMetric =>
      '100+ downloads · Flutter · Android · iOS';

  @override
  String get magStorefrontMetric => '1K+ downloads · Android · Kotlin';

  @override
  String get appRoleLabel => 'My role';

  @override
  String get appContributionLabel => 'Contribution';

  @override
  String get appStackLabel => 'Stack';

  @override
  String get appStoreProofLabel => 'Public proof';

  @override
  String get appScreenshotsLabel => 'Screens published in the store';

  @override
  String get appImageUnavailableLabel => 'Image unavailable';

  @override
  String get storeCheckedJuly2026 => 'Checked in July 2026.';

  @override
  String get vanCranenbroekContext => 'Retail · Netherlands · Android and iOS';

  @override
  String get vanCranenbroekSummary =>
      'Offers, catalogues, stores, and customer communication in a multiplatform product.';

  @override
  String get vanCranenbroekRole =>
      'Mobile engineering in collaboration with the Latitudde team.';

  @override
  String get vanCranenbroekContribution =>
      'Work across Flutter with GetX, GetIt/Injectable, and Provider, Firebase/Firestore, deep links, interactive maps and SVGs, GitLab CI/CD and Fastlane, and Python Cloud Functions.';

  @override
  String get vanCranenbroekPlayProof => '4.6 ★ · 179 ratings · 5K+';

  @override
  String get vanCranenbroekAppStoreProof =>
      '4.7 ★ · 143 ratings · 6,511 first-time downloads';

  @override
  String get lyzerContext => 'Logistics · Portugal · Flutter · Android and iOS';

  @override
  String get lyzerSummary =>
      'An operational suite connecting collection, order preparation, routes, and delivery.';

  @override
  String get lyzerRole =>
      'Flutter engineering across the Lyzer suite\'s Android and iOS operational flows.';

  @override
  String get lyzerContribution =>
      'Picking and delivery flows built on a proprietary GetX-based engine, with barcode scanning, offline synchronization, and integrations designed for field operations.';

  @override
  String get lyzerCollectProof => '1K+ downloads';

  @override
  String get lyzerCollectProofDetails =>
      'Updated Jul 6, 2026 · Checked in July 2026.';

  @override
  String get lyzerDeliverProof => '100+ downloads';

  @override
  String get lyzerDeliverProofDetails =>
      'Updated Jul 14, 2026 · Checked in July 2026.';

  @override
  String get magContext => 'Insurance · Brazil · Android';

  @override
  String get magSummary =>
      'A digital sales tool for brokers to follow products and proposals.';

  @override
  String get magRole => 'Android engineering on the digital sales product.';

  @override
  String get magContribution =>
      'Product evolution in Java/Kotlin, offline data with Realm, Gradle flavors, Firebase/Crashlytics, and an Azure pipeline.';

  @override
  String get magPlayProof => '1K+ downloads';

  @override
  String get magPlayProofDetails =>
      'Updated Jul 16, 2026 · Checked in July 2026.';

  @override
  String get systemTitle => 'End-to-end product architecture.';

  @override
  String get architectureProductTitle => 'Product and mobile';

  @override
  String get architectureProductDetail =>
      'Flutter · Android · iOS · user flows · offline state';

  @override
  String get architectureServicesTitle => 'Services and data';

  @override
  String get architectureServicesDetail =>
      'Python · .NET · APIs · GraphQL · Firebase · sync';

  @override
  String get architectureDeliveryTitle => 'Delivery and reliability';

  @override
  String get architectureDeliveryDetail =>
      'CI/CD · AWS · Azure · store releases · Crashlytics · performance';

  @override
  String get architectureAutomationTitle => 'AI and automation';

  @override
  String get architectureAutomationDetail =>
      'Agents · LLM tooling · background workflows';

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
  String get viewAllCertificates => 'View all certificates';

  @override
  String get certificateRegister => 'Certificate register';

  @override
  String get certificateRegisterCopy =>
      'Browse credentials by year and select one to view the official record and verification options.';

  @override
  String get filterTechnologies => 'Filter by technology';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get technologies => 'Technologies';

  @override
  String issuedBy(String issuer) {
    return 'Issued by $issuer';
  }

  @override
  String get verifyCredential => 'Verify credential';

  @override
  String certificateFor(String holder) {
    return 'Certificate issued to $holder';
  }

  @override
  String get closeDialog => 'Close dialog';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

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
  String get clientsTitle => 'Clients';

  @override
  String get directRoles => 'DIRECT';

  @override
  String get viaLatituddeConsulting => 'VIA LATITUDDE / CONKORD';

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
  String get contactEyebrow => 'CONTACT';

  @override
  String get contactTitle => 'Let\'s build something great together.';

  @override
  String get contactCopy =>
      'For opportunities, projects, or a technical conversation, choose the most convenient channel.';

  @override
  String get contactLinkedIn => 'LinkedIn';

  @override
  String get contactLinkedInCopy =>
      'Experience, career history, and professional contact.';

  @override
  String get contactWhatsApp => 'WhatsApp';

  @override
  String get contactWhatsAppCopy =>
      'Direct message for projects and opportunities.';

  @override
  String get contactGitHub => 'GitHub';

  @override
  String get contactGitHubCopy => 'Public code and technical studies.';

  @override
  String get contactSchedule => 'Schedule a conversation';

  @override
  String get contactScheduleCopy => 'Calendly · 30 minutes';

  @override
  String get magRecognitionTitle => 'Authentication and identity verification';

  @override
  String get magRecognitionText =>
      'Implemented facial-recognition authentication and identity verification in Venda Digital using the SERPRO API available at the time. The post below documents the team delivery, with Leone Crespo Daher de Souza among its members.';

  @override
  String get magRecognitionImageLabel =>
      'Post by Luis Henrique Fontes Oliveira recognizing the Venda Digital team and naming Leone Crespo Daher de Souza.';
}
