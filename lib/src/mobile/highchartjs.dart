import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/highcharts_options.dart';

// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

///
///A Chart library based on [High Charts (.JS)](https://www.highcharts.com/)
///
class HighCharts extends StatefulWidget {
  const HighCharts({
    required this.options,
    required this.size,
    required this.onEventTriggered,
    this.loader = const Center(child: CircularProgressIndicator()),
    this.scripts = const [
      "https://code.highcharts.com/highcharts.js",
      'https://code.highcharts.com/modules/networkgraph.js',
      'https://code.highcharts.com/modules/exporting.js',
    ],
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
  bool _isLoaded = false;

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          widget.onEventTriggered(message.message);
        },
      )
      ..enableZoom(false)
      ..loadHtmlString(_buildHtmlString(widget.options.toString()))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (err) {
            debugPrint(err.toString());
          },
          onPageFinished: ((url) {
            if (mounted) {
              setState(() => _isLoaded = true);
            }
          }),
          onNavigationRequest: ((request) async {
            if (await canLaunchUrlString(request.url)) {
              try {
                launchUrlString(request.url,
                    mode: LaunchMode.externalApplication);
              } catch (e) {
                debugPrint('High Charts Error ->$e');
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          }),
        ),
      );

    if (!Platform.isMacOS) {
      _controller.setBackgroundColor(Colors.transparent);
    }
  }

  @override
  void didUpdateWidget(covariant HighCharts oldWidget) {
    if (oldWidget.options != widget.options ||
        oldWidget.size != widget.size ||
        oldWidget.scripts != widget.scripts) {
      _controller.loadHtmlString(_buildHtmlString(widget.options.toString()));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          !_isLoaded ? widget.loader : const SizedBox.shrink(),
          WebViewWidget(controller: _controller)
        ],
      ),
    );
  }

  String _buildHtmlString(String chartOptionsString) {
    // Construct HTML content with script loading and dynamic chart data
    String html = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0"/>
        ${_loadScripts(widget.scripts)}
        <script>
          window.sendEventToFlutter = function(eventName, eventData) {
            Flutter.postMessage(eventData);
          };

          document.addEventListener('DOMContentLoaded', function () {
            const chartOptions = $chartOptionsString;
            const chart = Highcharts.chart('container', chartOptions, function(chart) {
              chart.series.forEach(function (series) {
                series.data.forEach(function (point) {
                  point.update({
                    events: {
                      click: function () {
                        const payload = {
                          x: point.x,
                          y: point.y,
                          seriesName: series.name,
                          pointIndex: point.index,
                          custom: point.custom || {}
                        };
                        sendEventToFlutter('pointClicked', JSON.stringify(payload));
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
            }
          });
        </script>
      </head>
      <body>
        <div id="container" height="${widget.size.height}px"></div>
      </body>
      </html>
    ''';

    return html;
  }

  String _loadScripts(List<String> scripts) {
    String scriptTags = '';
    for (String src in scripts) {
      scriptTags += '<script src="$src"></script>';
    }
    return scriptTags;
  }

  // Method to call JavaScript to trigger the tooltip
  void triggerTooltip(int seriesIndex, int pointIndex) {
    _controller.runJavaScript('triggerTooltip($seriesIndex, $pointIndex);');
  }
}
