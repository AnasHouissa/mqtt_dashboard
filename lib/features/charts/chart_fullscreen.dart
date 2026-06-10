import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import 'chart_view.dart';
import 'time_filter.dart';

/// Fullscreen, landscape-locked chart for better visualization.
class ChartFullscreenScreen extends StatefulWidget {
  const ChartFullscreenScreen({
    super.key,
    required this.metric,
    required this.type,
    required this.initialBucket,
    this.title,
  });

  final Metric metric;
  final ChartType type;
  final TimeBucket initialBucket;
  final String? title;

  @override
  State<ChartFullscreenScreen> createState() => _ChartFullscreenScreenState();
}

class _ChartFullscreenScreenState extends State<ChartFullscreenScreen> {
  late TimeBucket _bucket = widget.initialBucket;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore portrait + system UI on exit.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = widget.title?.isNotEmpty == true
        ? widget.title!
        : widget.metric.name;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TimeFilter(
                    value: _bucket,
                    onChanged: (b) => setState(() => _bucket = b),
                  ),
                  IconButton(
                    tooltip: l.cancel,
                    icon: const Icon(Icons.fullscreen_exit),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: MetricChart(
                  metric: widget.metric,
                  type: widget.type,
                  bucket: _bucket,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
