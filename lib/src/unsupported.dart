import 'dart:io';

import 'package:flutter/material.dart';

import 'models/highcharts_options.dart';

///
///A Chart library based on [High Charts (.JS)](https://www.highcharts.com/)
///
class HighCharts extends StatefulWidget {
  const HighCharts({
    required this.options,
    required this.size,
    required this.onEventTriggered,
    this.loader = const CircularProgressIndicator(),
    this.scripts = const [],
    super.key,
  });

  final HighChartsOptions options;

  ///Custom `loader` widget, until script is loaded
  ///
  ///Has no effect on Web
  ///
  ///Defaults to `CircularProgressIndicator`
  final Widget loader;

  ///Chart size
  ///
  ///Height and width of the chart is required
  ///
  ///```dart
  ///Size size = Size(400, 400);
  ///```
  final Size size;

  ///Scripts to be loaded
  ///
  ///Url's of the hightchart js scripts.
  ///
  ///Reference: [Full Scripts list](https://code.highcharts.com/)
  ///
  ///or use any CDN hosted script
  ///
  ///### For `android` and `ios` platforms, the scripts must be provided
  ///
  ///```dart
  ///List<String> scripts = [
  ///  'https://code.highcharts.com/highcharts.js',
  ///  'https://code.highcharts.com/modules/exporting.js',
  ///  'https://code.highcharts.com/modules/export-data.js'
  /// ];
  /// ```
  ///
  ///### For `web` platform, the scripts must be provided in `web/index.html`
  ///
  ///```html
  ///<head>
  ///   <script src="https://code.highcharts.com/highcharts.js"></script>
  ///   <script src="https://code.highcharts.com/modules/exporting.js"></script>
  ///   <script src="https://code.highcharts.com/modules/export-data.js"></script>
  ///</head>
  ///```
  ///
  final List<String> scripts;

  final Function(String) onEventTriggered;

  @override
  HighChartsState createState() => HighChartsState();

  String? getPlatformVersion() {
    return Platform.operatingSystemVersion;
  }
}

class HighChartsState extends State<HighCharts> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("HighCharts: UnSupported Platform"));
  }
}
