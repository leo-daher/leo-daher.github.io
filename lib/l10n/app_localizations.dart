import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// Browser and application title.
  ///
  /// In en, this message translates to:
  /// **'Leone Daher — Software Engineer'**
  String get appTitle;

  /// Accessible description for the opening brand animation.
  ///
  /// In en, this message translates to:
  /// **'Leone Daher. The brand adapts to the screen.'**
  String get openingSemantics;

  /// Accessible label for the language selector.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languageSelectorLabel;

  /// Autonym for Portuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get portugueseLanguage;

  /// Autonym for English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Compact availability badge.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE'**
  String get availableCompact;

  /// Full availability badge.
  ///
  /// In en, this message translates to:
  /// **'OPEN TO NEW CHALLENGES'**
  String get availableFull;

  /// Accessible label for the navigation menu barrier.
  ///
  /// In en, this message translates to:
  /// **'Dismiss navigation menu'**
  String get dismissNavigationMenu;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get navSystem;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navExperience;

  /// Accessible FAB label.
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get openNavigationMenu;

  /// Accessible FAB label.
  ///
  /// In en, this message translates to:
  /// **'Close navigation menu'**
  String get closeNavigationMenu;

  /// Accessible expanded state.
  ///
  /// In en, this message translates to:
  /// **'Expanded'**
  String get expanded;

  /// Accessible collapsed state.
  ///
  /// In en, this message translates to:
  /// **'Collapsed'**
  String get collapsed;

  /// Accessible custom action.
  ///
  /// In en, this message translates to:
  /// **'Close menu'**
  String get closeMenu;

  /// Hero experience statement.
  ///
  /// In en, this message translates to:
  /// **'7+ YEARS BUILDING SOFTWARE'**
  String get yearsBuildingSoftware;

  /// Hero role.
  ///
  /// In en, this message translates to:
  /// **'Mobile Software Engineer'**
  String get mobileEngineer;

  /// Hero role.
  ///
  /// In en, this message translates to:
  /// **'AI Automation Engineer'**
  String get aiAutomationEngineer;

  /// Hero supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Mobile products powered by smart, connected systems.'**
  String get mobileSupporting;

  /// Hero supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Python, agents and automation built around real work.'**
  String get aiSupporting;

  /// Hero focus selector label.
  ///
  /// In en, this message translates to:
  /// **'AI + Automation'**
  String get aiAutomationTab;

  /// Adaptive identity statement.
  ///
  /// In en, this message translates to:
  /// **'ONE FRAME · EVERY SURFACE'**
  String get everySurface;

  /// Supported device surfaces.
  ///
  /// In en, this message translates to:
  /// **'mobile  ·  desktop  ·  web'**
  String get surfaceList;

  /// System section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'ONE PRODUCT. THE WHOLE SYSTEM.'**
  String get systemEyebrow;

  /// System section title.
  ///
  /// In en, this message translates to:
  /// **'Mobile, services and intelligence connected.'**
  String get systemTitle;

  /// System flow summary.
  ///
  /// In en, this message translates to:
  /// **'PRODUCT → SYSTEM → RESULT'**
  String get systemFlow;

  /// Product system node label.
  ///
  /// In en, this message translates to:
  /// **'01  /  PRODUCT'**
  String get productLabel;

  /// Services system node label.
  ///
  /// In en, this message translates to:
  /// **'02  /  SERVICES'**
  String get servicesLabel;

  /// Intelligence system node label.
  ///
  /// In en, this message translates to:
  /// **'03  /  INTELLIGENCE'**
  String get intelligenceLabel;

  /// Backend capabilities.
  ///
  /// In en, this message translates to:
  /// **'APIs · data · integrations'**
  String get backendDetail;

  /// AI system node title.
  ///
  /// In en, this message translates to:
  /// **'AI Systems'**
  String get aiSystems;

  /// AI capabilities.
  ///
  /// In en, this message translates to:
  /// **'Agents · LLMs · automation'**
  String get aiDetail;

  /// System connector label.
  ///
  /// In en, this message translates to:
  /// **'REQUESTS'**
  String get requests;

  /// System connector label.
  ///
  /// In en, this message translates to:
  /// **'CONTEXT + TOOLS'**
  String get contextTools;

  /// Compact system return label.
  ///
  /// In en, this message translates to:
  /// **'RESULTS RETURN TO MOBILE'**
  String get resultsReturnMobile;

  /// System return label.
  ///
  /// In en, this message translates to:
  /// **'DECISIONS + ACTIONS RETURN TO THE PRODUCT'**
  String get decisionsReturnProduct;

  /// Device demonstration label.
  ///
  /// In en, this message translates to:
  /// **'DEVICE LAB'**
  String get deviceLab;

  /// Device demonstration title.
  ///
  /// In en, this message translates to:
  /// **'One action. Every screen.'**
  String get oneActionEveryScreen;

  /// Device demo view mode.
  ///
  /// In en, this message translates to:
  /// **'Mosaic'**
  String get mosaic;

  /// Device demo view mode.
  ///
  /// In en, this message translates to:
  /// **'Morph'**
  String get morph;

  /// Accessible device demo view mode.
  ///
  /// In en, this message translates to:
  /// **'{mode} view'**
  String viewMode(String mode);

  /// Device demo caption.
  ///
  /// In en, this message translates to:
  /// **'Explore deals, compare prices and save items — all synchronized.'**
  String get deviceDemoCaption;

  /// Accessible device preview label.
  ///
  /// In en, this message translates to:
  /// **'{device} with interactive Deal Radar'**
  String interactiveDealsDevice(String device);

  /// Localized name of the portfolio demo product.
  ///
  /// In en, this message translates to:
  /// **'DEAL RADAR'**
  String get dealRadar;

  /// Deal Radar status label.
  ///
  /// In en, this message translates to:
  /// **'LIVE DEALS'**
  String get liveDeals;

  /// Deal Radar search hint.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get searchProduct;

  /// Deal Radar tab.
  ///
  /// In en, this message translates to:
  /// **'Deals'**
  String get offers;

  /// Deal Radar tab and action.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// Deal Radar tab.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// Accessible action for a saved deal.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get removeSaved;

  /// Accessible action for a deal.
  ///
  /// In en, this message translates to:
  /// **'Save deal'**
  String get saveDeal;

  /// Saved deals empty state.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved'**
  String get nothingSaved;

  /// Deal search empty state.
  ///
  /// In en, this message translates to:
  /// **'No deals found'**
  String get noDeals;

  /// Deal detail title.
  ///
  /// In en, this message translates to:
  /// **'DEAL DETAILS'**
  String get dealDetails;

  /// Price comparison label.
  ///
  /// In en, this message translates to:
  /// **'PRICES IN THIS DATABASE'**
  String get pricesInDatabase;

  /// Store label.
  ///
  /// In en, this message translates to:
  /// **'STORE'**
  String get store;

  /// Static store count in the demo.
  ///
  /// In en, this message translates to:
  /// **'3 stores'**
  String get threeStores;

  /// Projects section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'FEATURED SOLUTIONS'**
  String get featuredSolutions;

  /// Projects section title.
  ///
  /// In en, this message translates to:
  /// **'Code with visible impact.'**
  String get projectsTitle;

  /// Projects section description.
  ///
  /// In en, this message translates to:
  /// **'Independent projects and product experience turned into demonstrations you can explore.'**
  String get projectsCopy;

  /// Mobile project description.
  ///
  /// In en, this message translates to:
  /// **'Product in motion: adaptive interfaces, synchronized state and native integrations in an experience that flows.'**
  String get mobileProjectCopy;

  /// Agentic workflows project description.
  ///
  /// In en, this message translates to:
  /// **'Intelligence that decides and executes: agents connect context, tools and validation without losing human control.'**
  String get agentsProjectCopy;

  /// Automation project description.
  ///
  /// In en, this message translates to:
  /// **'A measurable process: Python turns repetitive tasks into observable, reproducible and reliable pipelines.'**
  String get automationProjectCopy;

  /// Experience section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL EXPERIENCE'**
  String get globalExperience;

  /// Experience section title.
  ///
  /// In en, this message translates to:
  /// **'Products used in the real world.'**
  String get experienceTitle;

  /// Experience section description.
  ///
  /// In en, this message translates to:
  /// **'Mobile, backend, automation and infrastructure across operations distributed in different markets.'**
  String get experienceCopy;

  /// Certifications section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'CERTIFICATIONS'**
  String get certificationsEyebrow;

  /// Certifications section title.
  ///
  /// In en, this message translates to:
  /// **'Continuous learning, backed by proof.'**
  String get certificationsTitle;

  /// Certifications section description.
  ///
  /// In en, this message translates to:
  /// **'Official course records available for consultation, with source verification and archived certificates.'**
  String get certificationsCopy;

  /// Verified certificate count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 verified credential} other{{count} verified credentials}}'**
  String verifiedCredentials(int count);

  /// Certificate issuer count label.
  ///
  /// In en, this message translates to:
  /// **'issuers'**
  String get issuers;

  /// Opens the certificate register.
  ///
  /// In en, this message translates to:
  /// **'View credentials'**
  String get viewCredentials;

  /// Certificate catalog dialog title.
  ///
  /// In en, this message translates to:
  /// **'Certificate register'**
  String get certificateRegister;

  /// Certificate catalog dialog supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Select an item to view the official record and verification options.'**
  String get certificateRegisterCopy;

  /// Certificate verification status.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Certificate issuer label.
  ///
  /// In en, this message translates to:
  /// **'Issued by {issuer}'**
  String issuedBy(String issuer);

  /// Certificate completion year.
  ///
  /// In en, this message translates to:
  /// **'Completed in {year}'**
  String completedIn(String year);

  /// Opens the issuer verification page.
  ///
  /// In en, this message translates to:
  /// **'Verify credential'**
  String get verifyCredential;

  /// Opens the archived certificate PDF.
  ///
  /// In en, this message translates to:
  /// **'Open archived PDF'**
  String get openArchivedPdf;

  /// Certificate holder label.
  ///
  /// In en, this message translates to:
  /// **'Certificate issued to {holder}'**
  String certificateFor(String holder);

  /// Dismisses a dialog.
  ///
  /// In en, this message translates to:
  /// **'Close dialog'**
  String get closeDialog;

  /// Country list title.
  ///
  /// In en, this message translates to:
  /// **'Mapped countries'**
  String get mappedCountries;

  /// Projects label.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// Number of projects.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 project} other{{count} projects}}'**
  String projectCount(int count);

  /// Country experience metric label.
  ///
  /// In en, this message translates to:
  /// **'context'**
  String get context;

  /// Client logo section title.
  ///
  /// In en, this message translates to:
  /// **'CLIENTS SERVED'**
  String get clientsServed;

  /// Number of client brands.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 BRAND} other{{count} BRANDS}}'**
  String brandCount(int count);

  /// Footer invitation.
  ///
  /// In en, this message translates to:
  /// **'Shall we build something that truly works?'**
  String get footerInvitation;

  /// Accessible viewport format.
  ///
  /// In en, this message translates to:
  /// **'mobile format'**
  String get mobileFormat;

  /// Accessible viewport format.
  ///
  /// In en, this message translates to:
  /// **'tablet format'**
  String get tabletFormat;

  /// Accessible viewport format.
  ///
  /// In en, this message translates to:
  /// **'desktop and web format'**
  String get desktopFormat;

  /// Accessible adaptive viewport label.
  ///
  /// In en, this message translates to:
  /// **'LD viewport in {format}'**
  String viewportInFormat(String format);

  /// Accessible viewport selector action.
  ///
  /// In en, this message translates to:
  /// **'Show {format}'**
  String showFormat(String format);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
