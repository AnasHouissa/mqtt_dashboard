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
  String get navData => 'Data';

  @override
  String get navBoards => 'Boards';

  @override
  String get navSettings => 'Settings';

  @override
  String get brokers => 'Brokers';

  @override
  String get noBrokers => 'No brokers yet. Tap + to add one.';

  @override
  String get addBroker => 'Add broker';

  @override
  String get editBroker => 'Edit broker';

  @override
  String get duplicate => 'Duplicate';

  @override
  String copyOf(String name) {
    return '$name (copy)';
  }

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
  String lastUpdate(String date) {
    return 'Last updated: $date';
  }

  @override
  String get disconnected => 'Disconnected';

  @override
  String get notConnectedTap => 'Not connected — tap to connect';

  @override
  String get selectBrokerToConnect => 'Connect to a broker';

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
  String get renameDashboard => 'Rename dashboard';

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
  String get line => 'Line';

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
  String get day => 'Day';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get ok => 'OK';

  @override
  String get pickPeriod => 'Select period';

  @override
  String get selectMonth => 'Select month';

  @override
  String get selectYear => 'Select year';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportRange => 'Export range';

  @override
  String get export => 'Export';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get invalidRange => 'The start must be before the end.';

  @override
  String get timeRange => 'Time range';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

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
  String get editSmsSource => 'Edit';

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
  String get data => 'Data';

  @override
  String get downloadSqlBackup => 'Download SQL backup';

  @override
  String get downloadSqlBackupSubtitle =>
      'Export the entire database as a .sql file';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String get deleteConfirmBody => 'This action cannot be undone.';

  @override
  String deleteNamedBody(String name) {
    return 'Delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get deleteHistory => 'Delete history';

  @override
  String historyDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings deleted',
      one: '1 reading deleted',
      zero: 'No readings deleted',
    );
    return '$_temp0';
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
  String get csvDate => 'Date';

  @override
  String get csvTime => 'Time';

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

  @override
  String get add => 'Add';

  @override
  String get name => 'Name';

  @override
  String get leakGrid => 'Leak grid';

  @override
  String get statTile => 'Stat tile';

  @override
  String get addLeakGrid => 'Add leak grid';

  @override
  String get editLeakGrid => 'Edit leak grid';

  @override
  String get addStatTile => 'Add stat tile';

  @override
  String get editStatTile => 'Edit stat tile';

  @override
  String get alertDuration => 'Alert duration';

  @override
  String get addAlertDuration => 'Add alert duration';

  @override
  String get editAlertDuration => 'Edit alert duration';

  @override
  String get totalAlertTime => 'Time in alert';

  @override
  String get noAlerts => 'No alerts';

  @override
  String alertCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerts',
      one: '1 alert',
    );
    return '$_temp0';
  }

  @override
  String openSince(String time) {
    return 'Open since $time';
  }

  @override
  String get sensorCount => 'Number of sensors';

  @override
  String get cellPrefix => 'Cell label prefix';

  @override
  String get cellPrefixHelper => 'e.g. IN > Door, Water';

  @override
  String get fillColor => 'Alert (fill) color';

  @override
  String get emptyColor => 'Empty / OK color';

  @override
  String get unit => 'Unit';

  @override
  String get backgroundColor => 'Background color';

  @override
  String get foregroundColor => 'Text color';

  @override
  String get setpointOne => 'Setpoint 1';

  @override
  String get setpointTwo => 'Setpoint 2';

  @override
  String get avgPerDay => 'Daily avg';

  @override
  String get minPerDay => 'Daily min';

  @override
  String get maxPerDay => 'Daily max';

  @override
  String get showDailyMin => 'Display min value received';

  @override
  String get showDailyMax => 'Display max value received';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get noInternetBody => 'Check your network and try again.';

  @override
  String get background => 'Background';

  @override
  String get bgKeepConnected => 'Keep brokers connected in background';

  @override
  String get bgKeepConnectedSubtitle =>
      'Keep receiving readings while the app is closed. Uses more battery.';

  @override
  String get bgNotificationTitle => 'TEKKIM Dash running';

  @override
  String bgNotificationBody(String broker) {
    return 'Keeping $broker connected';
  }

  @override
  String get navAlerts => 'Alerts';

  @override
  String get alertTabRules => 'Alerts';

  @override
  String get alertTabReceived => 'Received';

  @override
  String get alertTabNew => 'New';

  @override
  String get alertTabAcknowledged => 'Acknowledged';

  @override
  String get addAlert => 'Add alert';

  @override
  String get editAlert => 'Edit alert';

  @override
  String get alertName => 'Alert name';

  @override
  String get alertConditions => 'Alarm levels';

  @override
  String get addCondition => 'Add level';

  @override
  String get alertSetpoint => 'Setpoint';

  @override
  String get alertOffset => 'Offset';

  @override
  String get alertComparison => 'Trigger';

  @override
  String get comparisonAbove => 'At or above';

  @override
  String get comparisonBelow => 'At or below';

  @override
  String get comparisonEquals => 'Equal to';

  @override
  String get alertLevel => 'Alarm level';

  @override
  String get alertLevelInfo => 'Info';

  @override
  String get alertLevelWarning => 'Warning';

  @override
  String get alertLevelCritical => 'Critical';

  @override
  String alertTriggersWhen(String op, String threshold) {
    return 'Triggers when value $op $threshold';
  }

  @override
  String get alertEnabled => 'Alarm enabled';

  @override
  String get alertNeedsCondition => 'Add at least one alarm level';

  @override
  String get noAlertRules => 'No alerts yet. Tap Add alert to create one.';

  @override
  String get noAlertsReceived => 'No new alerts.';

  @override
  String get noAlertsAcknowledged => 'No acknowledged alerts yet.';

  @override
  String get acknowledge => 'Acknowledge';

  @override
  String get acknowledgeAll => 'Acknowledge all';

  @override
  String get alertAcknowledged => 'Alert acknowledged';

  @override
  String get alertAllAcknowledged => 'All alerts acknowledged';

  @override
  String get alertTapToAcknowledge => 'Tap to acknowledge';

  @override
  String alertValueVsThreshold(
    String metric,
    String value,
    String op,
    String threshold,
  ) {
    return '$metric = $value ($op $threshold)';
  }

  @override
  String alertRuleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms',
      one: '1 alarm',
    );
    return '$_temp0';
  }

  @override
  String alertLevelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count levels',
      one: '1 level',
    );
    return '$_temp0';
  }

  @override
  String get csvAlert => 'Alert';

  @override
  String get csvMetric => 'Metric';

  @override
  String get csvThreshold => 'Threshold';

  @override
  String get csvAcknowledgedAt => 'Acknowledged at';

  @override
  String get alertsExportTitle => 'Acknowledged alerts export';

  @override
  String get deleteAlertsRange => 'Delete alerts by interval';

  @override
  String get deleteAllAlerts => 'Delete all';

  @override
  String get deleteAllAlertsBody =>
      'Delete every acknowledged alert? This action cannot be undone.';

  @override
  String alertsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerts deleted',
      one: '1 alert deleted',
      zero: 'No alerts deleted',
    );
    return '$_temp0';
  }

  @override
  String get valueKind => 'Value type';

  @override
  String get valueKindNumeric => 'Measured value';

  @override
  String get valueKindBoolean => 'Yes / no';

  @override
  String get valueKindBooleanHint =>
      'Not a measurable quantity — the metric is simply yes or no. Any non-zero reading is Yes (e.g. IN1, IN2 active); OK or 0 is No.';

  @override
  String get alertState => 'Trigger when';

  @override
  String get stateYes => 'Yes';

  @override
  String get stateNo => 'No';

  @override
  String alertTriggersWhenState(String state) {
    return 'Triggers when the metric is $state';
  }

  @override
  String alertValueState(String metric, String state) {
    return '$metric = $state';
  }
}
