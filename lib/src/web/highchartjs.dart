import 'package:web/web.dart' as html;
import 'dart:math';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

import '../models/highcharts_options.dart';
import '../utils/js_object_mapper.dart';

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
  ///Size size = Size(400, 300);
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
}

class HighChartsState extends State<HighCharts> {
  final String _highChartsId =
      "HighChartsId${Random().nextInt(900000) + 100000}";
  bool _isLoaded = false;

  @override
  void didUpdateWidget(covariant HighCharts oldWidget) {
    if (oldWidget.options != widget.options ||
        oldWidget.size != widget.size ||
        oldWidget.scripts != widget.scripts ||
        oldWidget.loader != widget.loader) {
      _load();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _load();

    html.window.onMessage.listen((event) {
      final data = jsToMap(event.data);
      if (data['type'] == 'pointClicked') {
        widget.onEventTriggered(data['payload']);
      }
      if (data['type'] == 'chartLoaded') {
        setState(() {
          _isLoaded = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_highChartsId, (int viewId) {
      final html.Element htmlElement = html.HTMLDivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..setAttribute("id", _highChartsId);
      return htmlElement;
    });

    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: HtmlElementView(viewType: _highChartsId),
    );
  }

  void _initializeChart() {
    final chartOptionsString = widget.options.toString();

    final String script = '''
    (function() {
      var chartOptions = $chartOptionsString;
      var chart = Highcharts.chart('$_highChartsId', chartOptions, function(chart) {
        // Add click event listener to all series points
        chart.series.forEach(function (series) {
          series.data.forEach(function (point) {
            point.update({
              events: {
                click: function () {
                  var payload = {
                    x: point.x,
                    y: point.y,
                    seriesName: series.name,
                    pointIndex: point.index,
                    custom: point.custom || {}
                  };
                  // Send event to Flutter
                  window.parent.postMessage({type: 'pointClicked', payload: JSON.stringify(payload)});
                },
              },
            });
          });
        });
      });

      window.triggerTooltip = function(seriesIndex, pointIndex) {
        if (chart.series[seriesIndex] && chart.series[seriesIndex].points[pointIndex]) {
          chart.series[seriesIndex].points[pointIndex].setState('hover');
          chart.tooltip.refresh(chart.series[seriesIndex].points[pointIndex]);
        }
      };

      // Notify Flutter that the chart is loaded
      window.parent.postMessage({type: 'chartLoaded', payload: 'loaded'});
    })();
    ''';

    _runJavaScript(script);
  }

  // Inject the JavaScript to run in the HTML page
  void _runJavaScript(String script) {
    html.HTMLScriptElement scriptElement = html.HTMLScriptElement();
    scriptElement.text = script;
    html.document.head!.append(scriptElement);
  }

  void _load() {
    Future.delayed(const Duration(milliseconds: 250), () {
      // eval("Highcharts.chart('$_highChartsId',${widget.data});");
      _initializeChart();
    });
  }
}
