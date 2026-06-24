// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TEKKIM Dash';

  @override
  String get brokers => 'Brokers';

  @override
  String get noBrokers => 'No brokers yet. Tap + to add one.';

  @override
  String get addBroker => 'Add broker';

  @override
  String get editBroker => 'Edit broker';

  @override
  String get brokerName => 'Broker name';

  @override
  String get brokerAddress => 'Address';

  @override
  String get brokerPort => 'Port';

  @override
  String get username => 'Username (optional)';

  @override
  String get password => 'Password (optional)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connected => 'Connected';

  @override
  String connectedTo(String broker) {
    return 'Connected to $broker';
  }

  @override
  String get disconnected => 'Disconnected';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String unableToConnect(String reason) {
    return 'Unable to connect: $reason';
  }

  @override
  String get reasonNetwork =>
      'could not reach the broker — check the address, port, and your network';

  @override
  String get reasonBadCredentials => 'the username or password was rejected';

  @override
  String get reasonBrokerUnavailable => 'the broker is unavailable';

  @override
  String get reasonRejected => 'the broker rejected the connection request';

  @override
  String get reasonUnknown => 'unknown error';

  @override
  String get testConnection => 'Test connection';

  @override
  String get testing => 'Testing…';

  @override
  String get connectionSuccessful => 'Connection successful';

  @override
  String get secureTls => 'Secure (TLS)';

  @override
  String get advanced => 'Advanced';

  @override
  String get qos => 'QoS';

  @override
  String get retain => 'Retain published messages';

  @override
  String get keepAliveSeconds => 'Keep-alive (s)';

  @override
  String get timeoutSeconds => 'Timeout (s)';

  @override
  String get invalidValue => 'Enter a positive number';

  @override
  String get metrics => 'Metrics';

  @override
  String get noMetrics => 'No metrics yet. Tap + to add one.';

  @override
  String get addMetric => 'Add metric';

  @override
  String get editMetric => 'Edit metric';

  @override
  String get metricName => 'Metric name';

  @override
  String get topic => 'Topic';

  @override
  String get enablePublishing => 'Enable publishing';

  @override
  String get minValue => 'Min value';

  @override
  String get maxValue => 'Max value';

  @override
  String get fixedChartRange => 'Fixed chart range';

  @override
  String get fixedChartRangeOn => 'Chart Y-axis uses the entered min/max';

  @override
  String get fixedChartRangeOff => 'Chart Y-axis scales to received values';

  @override
  String get rangeRequiresMinMax => 'Enter both min and max for a fixed range';

  @override
  String get publish => 'Publish';

  @override
  String get valueToPublish => 'Value to publish';

  @override
  String get published => 'Published';

  @override
  String get dashboards => 'Dashboards';

  @override
  String get noDashboards => 'No dashboards yet. Tap + to add one.';

  @override
  String get addDashboard => 'Add dashboard';

  @override
  String get dashboardName => 'Dashboard name';

  @override
  String get addCurve => 'Add curve';

  @override
  String get editCurve => 'Edit curve';

  @override
  String get noCharts => 'No charts yet. Tap \"Add curve\".';

  @override
  String get chartType => 'Chart type';

  @override
  String get histogram => 'Histogram';

  @override
  String get column => 'Column';

  @override
  String get bar => 'Bar';

  @override
  String get rangeArea => 'Range area';

  @override
  String get stackedColumn => 'Stacked column';

  @override
  String get stackedBar => 'Stacked bar';

  @override
  String get stackedColumn100 => '100% stacked column';

  @override
  String get boxAndWhisker => 'Box & whisker';

  @override
  String get radialBar => 'Radial bar';

  @override
  String get doughnut => 'Doughnut';

  @override
  String get pie => 'Pie';

  @override
  String get errorBar => 'Error bar';

  @override
  String get spline => 'Spline';

  @override
  String get color => 'Color';

  @override
  String get showInChart => 'Show in chart';

  @override
  String get addMetricSeries => 'Add metric';

  @override
  String get selectMetric => 'Select a metric';

  @override
  String get chartTitle => 'Chart title (optional)';

  @override
  String get today => 'Today';

  @override
  String get day => 'Day';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get noData => 'No data for this period';

  @override
  String get fieldRequired => 'Required';

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String get invalidPort => 'Enter a valid port (1-65535)';

  @override
  String get dataSource => 'Data source';

  @override
  String get sms => 'SMS';

  @override
  String get smsComingSoon => 'SMS data sources coming soon.';

  @override
  String get noSmsSources => 'No SMS sources yet. Tap + to add one.';

  @override
  String get addSmsSource => 'Add SMS source';

  @override
  String get editSmsSource => 'Edit SMS source';

  @override
  String get smsSourceName => 'Source name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberHint => 'Sender number — +216 then 8 digits';

  @override
  String get invalidTunisianNumber =>
      'Enter a valid Tunisian number (+216 then 8 digits)';

  @override
  String deleteSmsSourceBody(String name) {
    return 'Delete \"$name\"? Its metrics and readings will also be permanently removed.';
  }

  @override
  String get smsStationName => 'Station name';

  @override
  String get smsStationNameHint => 'Matches the first line of the message';

  @override
  String get valueMode => 'Value mode';

  @override
  String get valueModeAuto => 'Auto-detect';

  @override
  String get valueModeNumber => 'Number';

  @override
  String get valueModeNumberDesc => 'Use the number inside the brackets';

  @override
  String get valueModeCount => 'Active count';

  @override
  String get valueModeCountDesc => 'Count active inputs (OK = 0)';

  @override
  String get valueModePresence => 'Presence';

  @override
  String get valueModePresenceDesc => '1 while alerting, otherwise 0';

  @override
  String get smsRawLog => 'Raw SMS log';

  @override
  String get noSmsMessages => 'No messages received yet.';

  @override
  String get smsStatusMatched => 'Matched';

  @override
  String get smsStatusUnmatched => 'Unmatched';

  @override
  String get smsStatusError => 'Parse error';

  @override
  String smsReadings(int count) {
    return '$count readings';
  }

  @override
  String get smsPermissionRequired => 'SMS permission required';

  @override
  String get smsPermissionRationale =>
      'Allow reading SMS so messages from your sources become readings.';

  @override
  String get grantPermission => 'Grant permission';

  @override
  String get smsPermissionDenied =>
      'Permission denied. Enable SMS access in the system settings.';

  @override
  String get smsAndroidOnly =>
      'SMS data sources are only available on Android.';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System';

  @override
  String get settings => 'Settings';

  @override
  String get smsSettings => 'SMS';

  @override
  String get smsTopicPresets => 'Predefined topics';

  @override
  String get smsTopicPresetsSubtitle => 'Reusable topic labels for SMS metrics';

  @override
  String get addSmsTopic => 'Add topic';

  @override
  String get smsTopicLabel => 'Topic label';

  @override
  String get noSmsTopics => 'No predefined topics yet';

  @override
  String get appVersion => 'App version';

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String get deleteConfirmBody => 'This action cannot be undone.';

  @override
  String deleteNamedBody(String name) {
    return 'Delete \"$name\"? This action cannot be undone.';
  }

  @override
  String deleteBrokerBody(String name) {
    return 'Delete \"$name\"? Its metrics, dashboards, charts and readings will also be permanently removed.';
  }

  @override
  String exportTitle(String name) {
    return '$name data export';
  }

  @override
  String get timestamp => 'Timestamp';

  @override
  String get value => 'Value';

  @override
  String get liveConsole => 'Live console';

  @override
  String get consoleWaiting => 'Waiting for messages…';

  @override
  String get clear => 'Clear';

  @override
  String get publishMessage => 'Publish a message';

  @override
  String get publishDisabled => 'Publishing is disabled for this metric';
}
