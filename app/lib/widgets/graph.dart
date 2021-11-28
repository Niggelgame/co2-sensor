import 'dart:math';

import 'package:co2sensor/provider/data/graph_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimeScale { second, minute, hour, day, week, month, year }

class GraphDataConfiguration {
  static FlGridData gridData(BuildContext context) => FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.secondaryVariant,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.secondaryVariant,
            strokeWidth: 1,
          );
        },
      );

  static FlBorderData borderData(BuildContext context) => FlBorderData(
        show: true,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryVariant,
          width: 1,
        ),
      );

  static final clipData = FlClipData.all();

  static final lineColors = [
    Colors.green,
    Colors.yellow,
  ];

  static final lineGradientFrom = Offset(0.2, 0.5);

  static final swapAnimationDuration = Duration(milliseconds: 150);

  static final swapAnimationCurve = Curves.linear;

  static String getTitle(double value, int currentMin, int currentMax) {
    switch (timeScaleForRange(currentMin, currentMax)) {
      case TimeScale.second:
        return '${value.toInt().inSeconds}s';
      case TimeScale.minute:
        return '${value.toInt().inMinutes}m';
      case TimeScale.hour:
        return '${value.toInt().inHours}h';
      case TimeScale.day:
        return '${value.toInt().inDays}d';
      case TimeScale.week:
        return '${value.toInt().inWeeks}w';
      case TimeScale.month:
        return '${value.toInt().inMonths}m';
      case TimeScale.year:
        return '${value.toInt().inYears}y';
    }
  }

  static TimeScale timeScaleForRange(int currentMin, int currentMax) {
    final deltaTime = (currentMax - currentMin);
    if (deltaTime.inSeconds < 60) {
      return TimeScale.second;
    } else if (deltaTime.inMinutes < 60) {
      return TimeScale.minute;
    } else if (deltaTime.inHours < 24) {
      return TimeScale.hour;
    } else if (deltaTime.inDays < 7) {
      return TimeScale.day;
    } else if (deltaTime.inDays < 30) {
      return TimeScale.week;
    } else if (deltaTime.inDays < 365) {
      return TimeScale.month;
    } else {
      return TimeScale.year;
    }
  }
}

extension InScale on int {
  int get inSeconds => (this / 1000000000).round();
  int get inMinutes => (this / 60000000000).round();
  int get inHours => (this / 3600000000000).round();
  int get inDays => (this / 86400000000000).round();
  int get inWeeks => (this / 604800000000000).round();
  int get inMonths => (this / 2628000000000).round();
  int get inYears => (this / 31536000000000).round();
}

class Graph extends ConsumerWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(graphDataProvider);
    return data.when(
      data: (values) => LineChart(
        LineChartData(
          gridData: GraphDataConfiguration.gridData(context),
          borderData: GraphDataConfiguration.borderData(context),
          titlesData: FlTitlesData(
            topTitles: SideTitles(
              showTitles: false,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) => GraphDataConfiguration.getTitle(
                value,
                values.length > 0 ? values.first.timestamp : 0,
                values.length > 0 ? values.last.timestamp : 1,
              ),
            ),
          ),
          clipData: GraphDataConfiguration.clipData,
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.2,
              dotData: FlDotData(show: false),
              barWidth: 5,
              spots: values
                  .map(
                      (e) => FlSpot(e.timestamp.toDouble(), e.value.toDouble()))
                  .toList(),
              colors: GraphDataConfiguration.lineColors,
              gradientFrom: GraphDataConfiguration.lineGradientFrom,
            ),
          ],
        ),
        swapAnimationDuration: GraphDataConfiguration.swapAnimationDuration,
        swapAnimationCurve: GraphDataConfiguration.swapAnimationCurve,
      ),
      error: (e, s) => Text(e.toString()),
      loading: () => _LoadingGraph(),
    );
  }
}

class _LoadingGraph extends StatefulWidget {
  const _LoadingGraph({Key? key}) : super(key: key);

  @override
  __LoadingGraphState createState() => __LoadingGraphState();
}

class __LoadingGraphState extends State<_LoadingGraph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(period: Duration(seconds: 1), reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> loadingSpots(List<double> positions) {
    final spots = <FlSpot>[];
    positions.forEach((element) {
      spots.add(FlSpot(element, (sin(element) * _animation.value) + 5));
    });
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: AnimatedBuilder(
        builder: (context, child) {
          return LineChart(
            LineChartData(
              gridData: GraphDataConfiguration.gridData(context),
              clipData: GraphDataConfiguration.clipData,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  curveSmoothness: 0.4,
                  dotData: FlDotData(show: false),
                  barWidth: 5,
                  spots: loadingSpots([
                    0,
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7,
                    8,
                    9,
                    10,
                    11,
                    12,
                    13,
                    14,
                    15,
                    16,
                    17,
                    18,
                    19,
                    20
                  ]),
                  colors: GraphDataConfiguration.lineColors,
                  gradientFrom: GraphDataConfiguration.lineGradientFrom,
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: SideTitles(
                  showTitles: false,
                ),
                rightTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              borderData: GraphDataConfiguration.borderData(context),
            ),
            swapAnimationDuration: Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          );
        },
        animation: _animation,
      ),
    );
  }
}
