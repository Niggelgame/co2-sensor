

import 'package:co2sensor/api/api_wrapper.dart';
import 'package:co2sensor/models/entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final graphDataProvider = FutureProvider((ref) async {
  final api = ref.watch(apiProvider);
  if(api == null) {
    throw Exception('no connection url. please set config again');
  }
  final data = await api.getLastEntries(500);
  return data;
});

final refreshingGraphDataProvider = Provider((ref) {
  ref.listen(graphDataProvider, (AsyncValue<List<Entry>>? previous, AsyncValue<List<Entry>> next) async { 
    if(next.asData != null) {
      await Future.delayed(Duration(seconds: 10));
      // ref.refresh(graphDataProvider);
    }
  });

  return ref.watch(graphDataProvider);
});

const errorSpots = [
  FlSpot(2, 3),
  FlSpot(0, 3),
  FlSpot(0, 1.5),
  FlSpot(1, 1.5),
  FlSpot(0, 1.5),
  FlSpot(0, 0),
  FlSpot(2, 0)
];

const loadingSpots = [
  FlSpot(0, 1),
  FlSpot(1, 1),
  FlSpot(2, 1),
  FlSpot(3, 1),
  FlSpot(4, 1),
  FlSpot(5, 1),
  FlSpot(6, 1),
  FlSpot(7, 1),
  FlSpot(8, 1),
  FlSpot(9, 1),
  FlSpot(10, 1),
  FlSpot(11, 1),
  FlSpot(12, 1),
];

extension ToGraphSpots on List<Entry> {
  List<FlSpot> toGraphSpots() {
    return this.map((e) => FlSpot(e.timestamp.toDouble(), e.value.toDouble())).toList();
  }
}