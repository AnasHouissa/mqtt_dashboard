import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import 'chart_view.dart';
import 'time_filter.dart';

/// Fullscreen, landscape-locked chart for better visualization.
class ChartFullscreenScreen extends StatefulWidget {
  const ChartFullscreenScreen({
    super.key,
    required this.series,
    required this.initialBucket,
    required this.initialAnchor,
    this.title,
  });

  final List<ChartSeriesWithMetric> series;
  final TimeBucket initialBucket;
  final DateTime initialAnchor;
  final String? title;

  @override
  State<ChartFullscreenScreen> createState() => _ChartFullscreenScreenState();
}

class _ChartFullscreenScreenState extends State<ChartFullscreenScreen> {
  late TimeBucket _bucket = widget.initialBucket;
  late DateTime _anchor = widget.initialAnchor;

  bool get _isDefault => _anchor == defaultAnchor(_bucket);

  void _selectBucket(TimeBucket b) => setState(() {
    _bucket = b;
    _anchor = defaultAnchor(b);
  });

  Future<void> _pickPeriod() async {
    final picked = await pickPeriod(context, _bucket, _anchor);
    if (picked != null) setState(() => _anchor = picked);
  }

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
        : widget.series.map((s) => s.metric.name).join(', ');

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
                    onChanged: _selectBucket,
                    onPickPeriod: _pickPeriod,
                  ),
                  IconButton(
                    tooltip: l.cancel,
                    icon: const Icon(Icons.fullscreen_exit),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              if (!_isDefault)
                Align(
                  alignment: Alignment.centerLeft,
                  child: PeriodChip(
                    label: formatPeriod(context, _bucket, _anchor),
                    onReset: () =>
                        setState(() => _anchor = defaultAnchor(_bucket)),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: MetricChart(
                  series: widget.series,
                  bucket: _bucket,
                  anchor: _anchor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
