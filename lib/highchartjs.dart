library highchart;

export 'src/models/highcharts_options.dart';

export 'src/unsupported.dart'
    if (dart.library.html) 'src/web/highchartjs.dart'
    if (dart.library.io) 'src/mobile/highchartjs.dart';
