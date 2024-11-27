import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:highchartjs/highchartjs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExampleChart());
  }
}

class ExampleChart extends StatefulWidget {
  const ExampleChart({super.key});

  @override
  ExampleChartState createState() => ExampleChartState();
}

class ExampleChartState extends State<ExampleChart> {
  final datapoints = [
    HighChartsSeries(
      name: 'Blood Glucose',
      data: [
        HighChartsDataPoint(
          x: 1728447676000,
          y: 60,
        ),
        HighChartsDataPoint(
          x: 1728447676000,
          y: 105,
        ),
        HighChartsDataPoint(
          x: 1728620476000,
          y: 110,
        ),
        HighChartsDataPoint(
          x: 1728706876000,
          y: 128,
        ),
        HighChartsDataPoint(
          x: 1728793276000,
          y: 128,
        ),
      ],
    ),
    HighChartsSeries(
      name: 'Blood Lectate',
      data: [
        HighChartsDataPoint(
          x: 1728447676000,
          y: 20,
        ),
        HighChartsDataPoint(
          x: 1728620476000,
          y: 80,
        ),
        HighChartsDataPoint(
          x: 1728706876000,
          y: 90,
        ),
        HighChartsDataPoint(
          x: 1728793276000,
          y: 70,
        ),
        HighChartsDataPoint(
          x: 1728793276000,
          y: 100,
        ),
      ],
    ),
    HighChartsSeries(
      name: 'Comment Series',
      data: [
        HighChartsDataPoint(
          x: 1728447676000,
          y: 0,
        ),
        HighChartsDataPoint(
          x: 1728620476000,
          y: 0,
        ),
        HighChartsDataPoint(
          x: 1728706876000,
          y: 0,
        ),
        HighChartsDataPoint(
          x: 1728793276000,
          y: 0,
        ),
        HighChartsDataPoint(
          x: 1728793276000,
          y: 0,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    HighChartsOptions chartOptions = HighChartsOptions(
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
      series: datapoints,
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('High Charts Example App'),
      ),
      body: Row(
        children: [
          Expanded(
            child: HighCharts(
              options: chartOptions,
              loader: const SizedBox(
                width: 200,
                child: LinearProgressIndicator(),
              ),
              size: const Size(700, 700),
              onEventTriggered: (eventData) {
                // final decoded = jsonDecode(eventData) as Map<String, dynamic>;
                // final commentId = decoded['custom']['id'] as int;
                print(eventData);
              },
            ),
          ),
        ],
      ),
    );
  }
}
