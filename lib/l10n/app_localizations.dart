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

  /// Theme switch action.
  ///
  /// In en, this message translates to:
  /// **'Switch to light theme'**
  String get switchToLightTheme;

  /// Theme switch action.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get switchToDarkTheme;

  /// Direct CTA that opens the scheduling page.
  ///
  /// In en, this message translates to:
  /// **'Hire me here'**
  String get hireMe;

  /// Compact direct CTA that opens the scheduling page.
  ///
  /// In en, this message translates to:
  /// **'Hire me'**
  String get hireMeCompact;

  /// Primary action that scrolls to production apps.
  ///
  /// In en, this message translates to:
  /// **'View apps'**
  String get viewApps;

  /// Compact action that scrolls to production apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get viewAppsCompact;

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
  /// **'Apps'**
  String get navApps;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get navSystem;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// Navigation destination.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

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

  /// Creative product statement.
  ///
  /// In en, this message translates to:
  /// **'YOUR IDEAS. EVERYWHERE.'**
  String get everySurface;

  /// Supported device surfaces.
  ///
  /// In en, this message translates to:
  /// **'mobile  ·  desktop  ·  web'**
  String get surfaceList;

  /// Number of highlighted production apps.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get proofAppsValue;

  /// Production app proof label.
  ///
  /// In en, this message translates to:
  /// **'production apps highlighted'**
  String get proofAppsLabel;

  /// Published mobile platforms.
  ///
  /// In en, this message translates to:
  /// **'Android + iOS'**
  String get proofPlatformsValue;

  /// Store publication proof label.
  ///
  /// In en, this message translates to:
  /// **'published in official stores'**
  String get proofPlatformsLabel;

  /// Markets represented by highlighted apps.
  ///
  /// In en, this message translates to:
  /// **'Brazil + Europe'**
  String get proofMarketsValue;

  /// Market proof label.
  ///
  /// In en, this message translates to:
  /// **'products for real markets'**
  String get proofMarketsLabel;

  /// Store data consultation month.
  ///
  /// In en, this message translates to:
  /// **'JUL 2026'**
  String get proofCheckedValue;

  /// Store data recency label.
  ///
  /// In en, this message translates to:
  /// **'store data checked'**
  String get proofCheckedLabel;

  /// Accessible production apps section label.
  ///
  /// In en, this message translates to:
  /// **'Published apps Leone Daher contributed to'**
  String get productionAppsSemanticLabel;

  /// Production apps section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTION PROOF'**
  String get productionAppsEyebrow;

  /// Production apps section title.
  ///
  /// In en, this message translates to:
  /// **'Production apps I contributed to.'**
  String get productionAppsTitle;

  /// Production apps section supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Store screens, public metrics, and the work I delivered in each product. Checked in July 2026.'**
  String get productionAppsCopy;

  /// Production app role label.
  ///
  /// In en, this message translates to:
  /// **'My role'**
  String get appRoleLabel;

  /// Production app contribution label.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get appContributionLabel;

  /// Production app technology label.
  ///
  /// In en, this message translates to:
  /// **'Stack'**
  String get appStackLabel;

  /// Production app public store proof label.
  ///
  /// In en, this message translates to:
  /// **'Public proof'**
  String get appStoreProofLabel;

  /// Production app screenshot group label.
  ///
  /// In en, this message translates to:
  /// **'Screens published in the store'**
  String get appScreenshotsLabel;

  /// Fallback for a missing app screenshot.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get appImageUnavailableLabel;

  /// Store metric consultation date.
  ///
  /// In en, this message translates to:
  /// **'Checked in July 2026.'**
  String get storeCheckedJuly2026;

  /// Van Cranenbroek case context.
  ///
  /// In en, this message translates to:
  /// **'Retail · Netherlands · Android and iOS'**
  String get vanCranenbroekContext;

  /// Van Cranenbroek case summary.
  ///
  /// In en, this message translates to:
  /// **'Offers, catalogues, stores, and customer communication in a multiplatform product.'**
  String get vanCranenbroekSummary;

  /// Van Cranenbroek role.
  ///
  /// In en, this message translates to:
  /// **'Mobile engineering in collaboration with the Latitudde team.'**
  String get vanCranenbroekRole;

  /// Van Cranenbroek contribution.
  ///
  /// In en, this message translates to:
  /// **'Work across Flutter and Kotlin, Firebase/Firestore, deep links, interactive maps and SVGs, CI/CD, and Python Cloud Functions.'**
  String get vanCranenbroekContribution;

  /// Google Play proof checked in July 2026.
  ///
  /// In en, this message translates to:
  /// **'4.6 ★ · 179 ratings · 5K+ downloads'**
  String get vanCranenbroekPlayProof;

  /// App Store proof checked in July 2026.
  ///
  /// In en, this message translates to:
  /// **'4.7 ★ · 143 ratings'**
  String get vanCranenbroekAppStoreProof;

  /// Lyzer case context.
  ///
  /// In en, this message translates to:
  /// **'Logistics · Portugal · 2 Android apps'**
  String get lyzerContext;

  /// Lyzer case summary.
  ///
  /// In en, this message translates to:
  /// **'An operational suite connecting collection, order preparation, routes, and delivery.'**
  String get lyzerSummary;

  /// Lyzer role.
  ///
  /// In en, this message translates to:
  /// **'Mobile engineering across the Lyzer suite\'s operational flows.'**
  String get lyzerRole;

  /// Lyzer contribution.
  ///
  /// In en, this message translates to:
  /// **'Picking and delivery flows, barcode scanning, offline synchronization, and integrations designed for field operations.'**
  String get lyzerContribution;

  /// Lyzer Collect Google Play proof.
  ///
  /// In en, this message translates to:
  /// **'1K+ downloads · updated Jul 6, 2026'**
  String get lyzerCollectProof;

  /// Lyzer Deliver Google Play proof.
  ///
  /// In en, this message translates to:
  /// **'100+ downloads · updated Jul 14, 2026'**
  String get lyzerDeliverProof;

  /// MAG Venda Digital case context.
  ///
  /// In en, this message translates to:
  /// **'Insurance · Brazil · Android'**
  String get magContext;

  /// MAG Venda Digital case summary.
  ///
  /// In en, this message translates to:
  /// **'A digital sales tool for brokers to follow products and proposals.'**
  String get magSummary;

  /// MAG Venda Digital role.
  ///
  /// In en, this message translates to:
  /// **'Android engineering on the digital sales product.'**
  String get magRole;

  /// MAG Venda Digital contribution.
  ///
  /// In en, this message translates to:
  /// **'Product evolution in Java/Kotlin, offline data with Realm, Gradle flavors, Firebase/Crashlytics, and an Azure pipeline.'**
  String get magContribution;

  /// MAG Venda Digital Google Play proof.
  ///
  /// In en, this message translates to:
  /// **'Active app · 1K+ downloads · updated Jul 16, 2026'**
  String get magPlayProof;

  /// System section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'END-TO-END ARCHITECTURE'**
  String get systemEyebrow;

  /// System section title.
  ///
  /// In en, this message translates to:
  /// **'I architect and deliver products end to end.'**
  String get systemTitle;

  /// End-to-end architecture supporting copy.
  ///
  /// In en, this message translates to:
  /// **'From product flows and offline state to APIs, data, CI/CD, and production operations. AI and automation enter where they add practical leverage.'**
  String get systemCopy;

  /// Product architecture scope title.
  ///
  /// In en, this message translates to:
  /// **'Product and mobile'**
  String get architectureProductTitle;

  /// Product architecture scope detail.
  ///
  /// In en, this message translates to:
  /// **'Flutter · Android · iOS · user flows · offline state'**
  String get architectureProductDetail;

  /// Services architecture scope title.
  ///
  /// In en, this message translates to:
  /// **'Services and data'**
  String get architectureServicesTitle;

  /// Services architecture scope detail.
  ///
  /// In en, this message translates to:
  /// **'Python · .NET · APIs · GraphQL · Firebase · sync'**
  String get architectureServicesDetail;

  /// Delivery architecture scope title.
  ///
  /// In en, this message translates to:
  /// **'Delivery and reliability'**
  String get architectureDeliveryTitle;

  /// Delivery architecture scope detail.
  ///
  /// In en, this message translates to:
  /// **'CI/CD · Azure · store releases · Crashlytics · performance'**
  String get architectureDeliveryDetail;

  /// Automation architecture scope title.
  ///
  /// In en, this message translates to:
  /// **'AI and automation'**
  String get architectureAutomationTitle;

  /// Automation architecture scope detail.
  ///
  /// In en, this message translates to:
  /// **'Agents · LLM tooling · background workflows'**
  String get architectureAutomationDetail;

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
  /// **'Browse credentials by year and select one to view the official record and verification options.'**
  String get certificateRegisterCopy;

  /// Certificate technology filter label.
  ///
  /// In en, this message translates to:
  /// **'Filter by technology'**
  String get filterTechnologies;

  /// Clears selected certificate technology filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// Technology tag group label.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get technologies;

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

  /// Client section title.
  ///
  /// In en, this message translates to:
  /// **'Brands and operations in real contexts.'**
  String get clientsTitle;

  /// Client section supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Projects delivered through employers, consultancies, and partner teams. The cases above detail the contributions that can be verified publicly.'**
  String get clientsCopy;

  /// Number of client brands.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 BRAND} other{{count} BRANDS}}'**
  String brandCount(int count);

  /// Contact section eyebrow.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get contactEyebrow;

  /// Contact section title.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build something great together.'**
  String get contactTitle;

  /// Contact section supporting copy.
  ///
  /// In en, this message translates to:
  /// **'For opportunities, projects, or a technical conversation, choose the most convenient channel.'**
  String get contactCopy;

  /// LinkedIn contact label.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get contactLinkedIn;

  /// LinkedIn contact supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Experience, career history, and professional contact.'**
  String get contactLinkedInCopy;

  /// WhatsApp contact label.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsApp;

  /// WhatsApp contact supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Direct message for projects and opportunities.'**
  String get contactWhatsAppCopy;

  /// GitHub contact label.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get contactGitHub;

  /// GitHub contact supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Public code and technical studies.'**
  String get contactGitHubCopy;

  /// Calendly contact label.
  ///
  /// In en, this message translates to:
  /// **'Schedule a conversation'**
  String get contactSchedule;

  /// Calendly contact supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Calendly · 30 minutes'**
  String get contactScheduleCopy;
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
