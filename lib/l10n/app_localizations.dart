import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MQTT Dashboard'**
  String get appTitle;

  /// No description provided for @brokers.
  ///
  /// In en, this message translates to:
  /// **'Brokers'**
  String get brokers;

  /// No description provided for @noBrokers.
  ///
  /// In en, this message translates to:
  /// **'No brokers yet. Tap + to add one.'**
  String get noBrokers;

  /// No description provided for @addBroker.
  ///
  /// In en, this message translates to:
  /// **'Add broker'**
  String get addBroker;

  /// No description provided for @editBroker.
  ///
  /// In en, this message translates to:
  /// **'Edit broker'**
  String get editBroker;

  /// No description provided for @brokerName.
  ///
  /// In en, this message translates to:
  /// **'Broker name'**
  String get brokerName;

  /// No description provided for @brokerAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get brokerAddress;

  /// No description provided for @brokerPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get brokerPort;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get password;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {broker}'**
  String connectedTo(String broker);

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// No description provided for @unableToConnect.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect: {reason}'**
  String unableToConnect(String reason);

  /// No description provided for @reasonNetwork.
  ///
  /// In en, this message translates to:
  /// **'could not reach the broker — check the address, port, and your network'**
  String get reasonNetwork;

  /// No description provided for @reasonBadCredentials.
  ///
  /// In en, this message translates to:
  /// **'the username or password was rejected'**
  String get reasonBadCredentials;

  /// No description provided for @reasonBrokerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'the broker is unavailable'**
  String get reasonBrokerUnavailable;

  /// No description provided for @reasonRejected.
  ///
  /// In en, this message translates to:
  /// **'the broker rejected the connection request'**
  String get reasonRejected;

  /// No description provided for @reasonUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown error'**
  String get reasonUnknown;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get testConnection;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get testing;

  /// No description provided for @connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get connectionSuccessful;

  /// No description provided for @secureTls.
  ///
  /// In en, this message translates to:
  /// **'Secure (TLS)'**
  String get secureTls;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @qos.
  ///
  /// In en, this message translates to:
  /// **'QoS'**
  String get qos;

  /// No description provided for @retain.
  ///
  /// In en, this message translates to:
  /// **'Retain published messages'**
  String get retain;

  /// No description provided for @keepAliveSeconds.
  ///
  /// In en, this message translates to:
  /// **'Keep-alive (s)'**
  String get keepAliveSeconds;

  /// No description provided for @timeoutSeconds.
  ///
  /// In en, this message translates to:
  /// **'Timeout (s)'**
  String get timeoutSeconds;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number'**
  String get invalidValue;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metrics;

  /// No description provided for @noMetrics.
  ///
  /// In en, this message translates to:
  /// **'No metrics yet. Tap + to add one.'**
  String get noMetrics;

  /// No description provided for @addMetric.
  ///
  /// In en, this message translates to:
  /// **'Add metric'**
  String get addMetric;

  /// No description provided for @editMetric.
  ///
  /// In en, this message translates to:
  /// **'Edit metric'**
  String get editMetric;

  /// No description provided for @metricName.
  ///
  /// In en, this message translates to:
  /// **'Metric name'**
  String get metricName;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @enablePublishing.
  ///
  /// In en, this message translates to:
  /// **'Enable publishing'**
  String get enablePublishing;

  /// No description provided for @minValue.
  ///
  /// In en, this message translates to:
  /// **'Min value'**
  String get minValue;

  /// No description provided for @maxValue.
  ///
  /// In en, this message translates to:
  /// **'Max value'**
  String get maxValue;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @valueToPublish.
  ///
  /// In en, this message translates to:
  /// **'Value to publish'**
  String get valueToPublish;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @dashboards.
  ///
  /// In en, this message translates to:
  /// **'Dashboards'**
  String get dashboards;

  /// No description provided for @noDashboards.
  ///
  /// In en, this message translates to:
  /// **'No dashboards yet. Tap + to add one.'**
  String get noDashboards;

  /// No description provided for @addDashboard.
  ///
  /// In en, this message translates to:
  /// **'Add dashboard'**
  String get addDashboard;

  /// No description provided for @dashboardName.
  ///
  /// In en, this message translates to:
  /// **'Dashboard name'**
  String get dashboardName;

  /// No description provided for @addCurve.
  ///
  /// In en, this message translates to:
  /// **'Add curve'**
  String get addCurve;

  /// No description provided for @noCharts.
  ///
  /// In en, this message translates to:
  /// **'No charts yet. Tap \"Add curve\".'**
  String get noCharts;

  /// No description provided for @chartType.
  ///
  /// In en, this message translates to:
  /// **'Chart type'**
  String get chartType;

  /// No description provided for @curve.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get curve;

  /// No description provided for @histogram.
  ///
  /// In en, this message translates to:
  /// **'Histogram'**
  String get histogram;

  /// No description provided for @spline.
  ///
  /// In en, this message translates to:
  /// **'Spline'**
  String get spline;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @scatter.
  ///
  /// In en, this message translates to:
  /// **'Scatter'**
  String get scatter;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @showInChart.
  ///
  /// In en, this message translates to:
  /// **'Show in chart'**
  String get showInChart;

  /// No description provided for @addMetricSeries.
  ///
  /// In en, this message translates to:
  /// **'Add metric'**
  String get addMetricSeries;

  /// No description provided for @selectMetric.
  ///
  /// In en, this message translates to:
  /// **'Select a metric'**
  String get selectMetric;

  /// No description provided for @chartTitle.
  ///
  /// In en, this message translates to:
  /// **'Chart title (optional)'**
  String get chartTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get noData;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get invalidNumber;

  /// No description provided for @invalidPort.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid port (1-65535)'**
  String get invalidPort;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} data export'**
  String exportTitle(String name);

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @liveConsole.
  ///
  /// In en, this message translates to:
  /// **'Live console'**
  String get liveConsole;

  /// No description provided for @consoleWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for messages…'**
  String get consoleWaiting;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @publishMessage.
  ///
  /// In en, this message translates to:
  /// **'Publish a message'**
  String get publishMessage;

  /// No description provided for @publishDisabled.
  ///
  /// In en, this message translates to:
  /// **'Publishing is disabled for this metric'**
  String get publishDisabled;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Message published'**
  String get messageSent;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
