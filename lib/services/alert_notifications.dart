import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/database.dart';
import '../utils/number_format.dart';
import 'alert_engine.dart';

/// SharedPreferences keys used to hand localized notification text across the
/// isolate boundary. The background service isolate has no Riverpod or
/// BuildContext, so the UI writes what the notification builder needs whenever
/// the locale changes — the same prefs-as-transport pattern `kBgNotifTitle` in
/// `background_service.dart` relies on.
const kAlertNotifLocale = 'alert_notif_locale';
const kAlertNotifLevelInfo = 'alert_notif_level_info';
const kAlertNotifLevelWarning = 'alert_notif_level_warning';
const kAlertNotifLevelCritical = 'alert_notif_level_critical';

/// Body template with `{metric}`, `{value}`, `{op}` and `{threshold}`
/// placeholders (e.g. `Tank level = 24 (≥ 20)`).
const kAlertNotifBody = 'alert_notif_body';

/// Body template for on/off conditions, with `{metric}` and `{state}` (e.g.
/// `Door = Yes`). A raw reading of `3` — three active inputs — would tell the
/// user nothing, so boolean alerts report the state instead.
const kAlertNotifBodyState = 'alert_notif_body_state';
const kAlertNotifStateYes = 'alert_notif_state_active';
const kAlertNotifStateNo = 'alert_notif_state_inactive';

/// Payload used on every alert notification; the tap handler routes it to the
/// alerts tab.
const kAlertNotifPayload = 'alerts';

const _channelInfo = 'alerts_info';
const _channelWarning = 'alerts_warning';
const _channelCritical = 'alerts_critical';

/// Channel of the removed `error` level. Deleted on startup so it stops
/// appearing in the app's Android notification settings on upgraded installs.
const _channelRetiredError = 'alerts_error';

final _plugin = FlutterLocalNotificationsPlugin();

/// One channel per severity so Android applies the right importance, sound and
/// vibration per level — the user picks the level when writing the rule, and
/// Android (not the app) enforces the resulting behaviour, including while the
/// app is closed and only the background service is running.
///
/// Channel importance is fixed at creation time by Android: renaming or
/// re-tuning a channel later requires a new channel id.
Future<void> registerAlertChannels() async {
  const channels = [
    AndroidNotificationChannel(
      _channelCritical,
      'Critical alerts',
      description: 'Highest-severity threshold alerts.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    ),
    AndroidNotificationChannel(
      _channelWarning,
      'Warning alerts',
      description: 'Threshold alerts at warning level.',
      importance: Importance.defaultImportance,
      playSound: true,
    ),
    AndroidNotificationChannel(
      _channelInfo,
      'Info alerts',
      description: 'Informational threshold alerts (silent).',
      importance: Importance.low,
      playSound: false,
    ),
  ];

  final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  for (final channel in channels) {
    await android?.createNotificationChannel(channel);
  }
  await android?.deleteNotificationChannel(channelId: _channelRetiredError);
}

/// Initializes the plugin and wires the tap handler. Call once from `main()`
/// after [registerAlertChannels]. [onTapAlert] fires when the user taps an
/// alert notification (payload [kAlertNotifPayload]).
Future<void> initAlertNotifications({required void Function() onTapAlert}) {
  return _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: (response) {
      if (response.payload == kAlertNotifPayload) onTapAlert();
    },
  );
}

/// Asks for Android 13+ runtime notification permission. Safe to call on every
/// launch — Android only shows the dialog once.
Future<void> requestNotificationPermission() async {
  await _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

/// Posts a notification for a fired alert on the channel matching its level.
///
/// Works from either isolate: the background service has its own plugin
/// instance, and all localized text comes from SharedPreferences (written by
/// [writeAlertNotificationStrings]) rather than a BuildContext.
Future<void> showAlertNotification(AlertEvent event) async {
  final prefs = await SharedPreferences.getInstance();
  final locale = prefs.getString(kAlertNotifLocale) ?? 'en';

  final (String channelId, String channelName, Importance importance,
      Priority priority) = switch (event.level) {
    AlertLevel.critical => (
        _channelCritical,
        'Critical alerts',
        Importance.max,
        Priority.max
      ),
    AlertLevel.warning => (
        _channelWarning,
        'Warning alerts',
        Importance.defaultImportance,
        Priority.defaultPriority
      ),
    AlertLevel.info => (
        _channelInfo,
        'Info alerts',
        Importance.low,
        Priority.low
      ),
  };

  final levelKey = switch (event.level) {
    AlertLevel.info => kAlertNotifLevelInfo,
    AlertLevel.warning => kAlertNotifLevelWarning,
    AlertLevel.critical => kAlertNotifLevelCritical,
  };
  final levelLabel = prefs.getString(levelKey) ?? event.level.name;

  final String body;
  if (isBooleanComparison(event.comparison)) {
    final state = prefs.getString(event.comparison == AlertComparison.isTrue
            ? kAlertNotifStateYes
            : kAlertNotifStateNo) ??
        (event.comparison == AlertComparison.isTrue ? 'Yes' : 'No');
    body = (prefs.getString(kAlertNotifBodyState) ?? '{metric} = {state}')
        .replaceAll('{metric}', event.metricName)
        .replaceAll('{state}', state);
  } else {
    body = (prefs.getString(kAlertNotifBody) ??
            '{metric} = {value} ({op} {threshold})')
        .replaceAll('{metric}', event.metricName)
        .replaceAll('{value}', formatMetricValue(event.value, locale))
        .replaceAll('{op}', comparisonSymbol(event.comparison))
        .replaceAll('{threshold}', formatMetricValue(event.threshold, locale));
  }

  await _plugin.show(
    // The event id keeps concurrent alerts from replacing one another. Offset
    // to stay clear of the background service's fixed notification id (1971).
    id: 100000 + event.id,
    title: '$levelLabel · ${event.ruleName}',
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: importance,
        priority: priority,
        styleInformation: BigTextStyleInformation(body),
      ),
    ),
    payload: kAlertNotifPayload,
  );
}

/// Persists the localized strings the notification builder needs, so the
/// background isolate can produce correctly translated notifications.
Future<void> writeAlertNotificationStrings(
  SharedPreferences prefs, {
  required String locale,
  required String info,
  required String warning,
  required String critical,
  required String bodyTemplate,
  required String stateBodyTemplate,
  required String stateYes,
  required String stateNo,
}) async {
  await prefs.setString(kAlertNotifLocale, locale);
  await prefs.setString(kAlertNotifLevelInfo, info);
  await prefs.setString(kAlertNotifLevelWarning, warning);
  await prefs.setString(kAlertNotifLevelCritical, critical);
  await prefs.setString(kAlertNotifBody, bodyTemplate);
  await prefs.setString(kAlertNotifBodyState, stateBodyTemplate);
  await prefs.setString(kAlertNotifStateYes, stateYes);
  await prefs.setString(kAlertNotifStateNo, stateNo);
}
