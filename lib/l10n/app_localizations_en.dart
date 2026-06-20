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
  String get curve => 'Line';

  @override
  String get histogram => 'Histogram';

  @override
  String get spline => 'Spline';

  @override
  String get area => 'Area';

  @override
  String get scatter => 'Scatter';

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
  String get language => 'Language';

  @override
  String get systemDefault => 'System';

  @override
  String get settings => 'Settings';

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

  @override
  String get messageSent => 'Message published';
}
