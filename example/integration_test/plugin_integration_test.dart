// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highchartjs/highchartjs.dart';
import 'package:integration_test/integration_test.dart';

// import 'package:highchartjs/highchartjs.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final chartOptions = HighChartsOptions(
      chartType: 'line',
      title: HighChartsTitle(text: 'Blood Glucose vs Blood Lectate Over Time'),
      yAxis: HighChartsYAxis(
        title: HighChartsAxisTitle(text: 'Blood Glucose (mg/dL)'),
      ),
      xAxis: HighChartsXAxis(
        type: 'datetime',
        title: HighChartsAxisTitle(text: 'Date'),
        labels: HighChartsAxisLabels(
          format: '{value:%Y-%m-%d}',
        ),
      ),
      series: [],
    );
    HighCharts plugin = HighCharts(
      options: chartOptions,
      onEventTriggered: (eventData) {},
      size: Size(0, 0),
      scripts: [],
    );
    final String? version = plugin.getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });
}
