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
  /// **'TEKKIM Dash'**
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

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @copyOf.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy)'**
  String copyOf(String name);

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

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

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

  /// No description provided for @fixedChartRange.
  ///
  /// In en, this message translates to:
  /// **'Fixed chart range'**
  String get fixedChartRange;

  /// No description provided for @fixedChartRangeOn.
  ///
  /// In en, this message translates to:
  /// **'Chart Y-axis uses the entered min/max'**
  String get fixedChartRangeOn;

  /// No description provided for @fixedChartRangeOff.
  ///
  /// In en, this message translates to:
  /// **'Chart Y-axis scales to received values'**
  String get fixedChartRangeOff;

  /// No description provided for @rangeRequiresMinMax.
  ///
  /// In en, this message translates to:
  /// **'Enter both min and max for a fixed range'**
  String get rangeRequiresMinMax;

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

  /// No description provided for @renameDashboard.
  ///
  /// In en, this message translates to:
  /// **'Rename dashboard'**
  String get renameDashboard;

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

  /// No description provided for @editCurve.
  ///
  /// In en, this message translates to:
  /// **'Edit curve'**
  String get editCurve;

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

  /// No description provided for @histogram.
  ///
  /// In en, this message translates to:
  /// **'Histogram'**
  String get histogram;

  /// No description provided for @column.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get column;

  /// No description provided for @bar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get bar;

  /// No description provided for @rangeArea.
  ///
  /// In en, this message translates to:
  /// **'Range area'**
  String get rangeArea;

  /// No description provided for @stackedColumn.
  ///
  /// In en, this message translates to:
  /// **'Stacked column'**
  String get stackedColumn;

  /// No description provided for @stackedBar.
  ///
  /// In en, this message translates to:
  /// **'Stacked bar'**
  String get stackedBar;

  /// No description provided for @stackedColumn100.
  ///
  /// In en, this message translates to:
  /// **'100% stacked column'**
  String get stackedColumn100;

  /// No description provided for @boxAndWhisker.
  ///
  /// In en, this message translates to:
  /// **'Box & whisker'**
  String get boxAndWhisker;

  /// No description provided for @radialBar.
  ///
  /// In en, this message translates to:
  /// **'Radial bar'**
  String get radialBar;

  /// No description provided for @doughnut.
  ///
  /// In en, this message translates to:
  /// **'Doughnut'**
  String get doughnut;

  /// No description provided for @pie.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get pie;

  /// No description provided for @errorBar.
  ///
  /// In en, this message translates to:
  /// **'Error bar'**
  String get errorBar;

  /// No description provided for @spline.
  ///
  /// In en, this message translates to:
  /// **'Spline'**
  String get spline;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get line;

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pickPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get pickPeriod;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get selectMonth;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get selectYear;

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

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

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

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get dataSource;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @smsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'SMS data sources coming soon.'**
  String get smsComingSoon;

  /// No description provided for @noSmsSources.
  ///
  /// In en, this message translates to:
  /// **'No SMS sources yet. Tap + to add one.'**
  String get noSmsSources;

  /// No description provided for @addSmsSource.
  ///
  /// In en, this message translates to:
  /// **'Add SMS source'**
  String get addSmsSource;

  /// No description provided for @editSmsSource.
  ///
  /// In en, this message translates to:
  /// **'Edit SMS source'**
  String get editSmsSource;

  /// No description provided for @smsSourceName.
  ///
  /// In en, this message translates to:
  /// **'Source name'**
  String get smsSourceName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Sender number — +216 then 8 digits'**
  String get phoneNumberHint;

  /// No description provided for @invalidTunisianNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Tunisian number (+216 then 8 digits)'**
  String get invalidTunisianNumber;

  /// No description provided for @deleteSmsSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Its metrics and readings will also be permanently removed.'**
  String deleteSmsSourceBody(String name);

  /// No description provided for @smsStationName.
  ///
  /// In en, this message translates to:
  /// **'Station name'**
  String get smsStationName;

  /// No description provided for @smsStationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Matches the first line of the message'**
  String get smsStationNameHint;

  /// No description provided for @valueMode.
  ///
  /// In en, this message translates to:
  /// **'Value mode'**
  String get valueMode;

  /// No description provided for @valueModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get valueModeAuto;

  /// No description provided for @valueModeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get valueModeNumber;

  /// No description provided for @valueModeNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Use the number inside the brackets'**
  String get valueModeNumberDesc;

  /// No description provided for @valueModeCount.
  ///
  /// In en, this message translates to:
  /// **'Active count'**
  String get valueModeCount;

  /// No description provided for @valueModeCountDesc.
  ///
  /// In en, this message translates to:
  /// **'Count active inputs (OK = 0)'**
  String get valueModeCountDesc;

  /// No description provided for @valueModePresence.
  ///
  /// In en, this message translates to:
  /// **'Presence'**
  String get valueModePresence;

  /// No description provided for @valueModePresenceDesc.
  ///
  /// In en, this message translates to:
  /// **'1 while alerting, otherwise 0'**
  String get valueModePresenceDesc;

  /// No description provided for @smsRawLog.
  ///
  /// In en, this message translates to:
  /// **'Raw SMS log'**
  String get smsRawLog;

  /// No description provided for @noSmsMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages received yet.'**
  String get noSmsMessages;

  /// No description provided for @smsStatusMatched.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get smsStatusMatched;

  /// No description provided for @smsStatusUnmatched.
  ///
  /// In en, this message translates to:
  /// **'Unmatched'**
  String get smsStatusUnmatched;

  /// No description provided for @smsStatusError.
  ///
  /// In en, this message translates to:
  /// **'Parse error'**
  String get smsStatusError;

  /// No description provided for @smsReadings.
  ///
  /// In en, this message translates to:
  /// **'{count} readings'**
  String smsReadings(int count);

  /// No description provided for @smsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'SMS permission required'**
  String get smsPermissionRequired;

  /// No description provided for @smsPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Allow reading SMS so messages from your sources become readings.'**
  String get smsPermissionRationale;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get grantPermission;

  /// No description provided for @smsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Enable SMS access in the system settings.'**
  String get smsPermissionDenied;

  /// No description provided for @smsAndroidOnly.
  ///
  /// In en, this message translates to:
  /// **'SMS data sources are only available on Android.'**
  String get smsAndroidOnly;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemDefault;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @smsSettings.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get smsSettings;

  /// No description provided for @smsTopicPresets.
  ///
  /// In en, this message translates to:
  /// **'Predefined topics'**
  String get smsTopicPresets;

  /// No description provided for @smsTopicPresetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable topic labels for SMS metrics'**
  String get smsTopicPresetsSubtitle;

  /// No description provided for @addSmsTopic.
  ///
  /// In en, this message translates to:
  /// **'Add topic'**
  String get addSmsTopic;

  /// No description provided for @smsTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic label'**
  String get smsTopicLabel;

  /// No description provided for @noSmsTopics.
  ///
  /// In en, this message translates to:
  /// **'No predefined topics yet'**
  String get noSmsTopics;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

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

  /// No description provided for @deleteNamedBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This action cannot be undone.'**
  String deleteNamedBody(String name);

  /// No description provided for @deleteBrokerBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Its metrics, dashboards, charts and readings will also be permanently removed.'**
  String deleteBrokerBody(String name);

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

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @leakGrid.
  ///
  /// In en, this message translates to:
  /// **'Leak grid'**
  String get leakGrid;

  /// No description provided for @statTile.
  ///
  /// In en, this message translates to:
  /// **'Stat tile'**
  String get statTile;

  /// No description provided for @addLeakGrid.
  ///
  /// In en, this message translates to:
  /// **'Add leak grid'**
  String get addLeakGrid;

  /// No description provided for @editLeakGrid.
  ///
  /// In en, this message translates to:
  /// **'Edit leak grid'**
  String get editLeakGrid;

  /// No description provided for @addStatTile.
  ///
  /// In en, this message translates to:
  /// **'Add stat tile'**
  String get addStatTile;

  /// No description provided for @editStatTile.
  ///
  /// In en, this message translates to:
  /// **'Edit stat tile'**
  String get editStatTile;

  /// No description provided for @alertDuration.
  ///
  /// In en, this message translates to:
  /// **'Alert duration'**
  String get alertDuration;

  /// No description provided for @addAlertDuration.
  ///
  /// In en, this message translates to:
  /// **'Add alert duration'**
  String get addAlertDuration;

  /// No description provided for @editAlertDuration.
  ///
  /// In en, this message translates to:
  /// **'Edit alert duration'**
  String get editAlertDuration;

  /// No description provided for @totalAlertTime.
  ///
  /// In en, this message translates to:
  /// **'Time in alert'**
  String get totalAlertTime;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts'**
  String get noAlerts;

  /// No description provided for @alertCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alert} other{{count} alerts}}'**
  String alertCount(int count);

  /// No description provided for @openSince.
  ///
  /// In en, this message translates to:
  /// **'Open since {time}'**
  String openSince(String time);

  /// No description provided for @sensorCount.
  ///
  /// In en, this message translates to:
  /// **'Number of sensors'**
  String get sensorCount;

  /// No description provided for @fillColor.
  ///
  /// In en, this message translates to:
  /// **'Alert (fill) color'**
  String get fillColor;

  /// No description provided for @emptyColor.
  ///
  /// In en, this message translates to:
  /// **'Empty / OK color'**
  String get emptyColor;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get backgroundColor;

  /// No description provided for @foregroundColor.
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get foregroundColor;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @noInternetBody.
  ///
  /// In en, this message translates to:
  /// **'Check your network and try again.'**
  String get noInternetBody;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @bgKeepConnected.
  ///
  /// In en, this message translates to:
  /// **'Keep brokers connected in background'**
  String get bgKeepConnected;

  /// No description provided for @bgKeepConnectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep receiving readings while the app is closed. Uses more battery.'**
  String get bgKeepConnectedSubtitle;

  /// No description provided for @bgNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'TEKKIM Dash running'**
  String get bgNotificationTitle;

  /// No description provided for @bgNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Keeping {broker} connected'**
  String bgNotificationBody(String broker);
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
