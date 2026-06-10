import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // NOTE: Syncfusion charts render a small watermark unless a (free) community
  // license is registered here. Obtain a key at syncfusion.com and uncomment:
  //
  // SyncfusionLicense.registerLicense('YOUR_COMMUNITY_LICENSE_KEY');

  runApp(const ProviderScope(child: MqttDashApp()));
}
