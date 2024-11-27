class HighChartsOptions {
  final String chartType;
  final HighChartsTitle title;
  final HighChartsSubtitle? subtitle;
  final HighChartsXAxis xAxis;
  final HighChartsYAxis yAxis;
  final List<HighChartsSeries> series;

  HighChartsOptions({
    required this.chartType,
    required this.title,
    this.subtitle,
    required this.xAxis,
    required this.yAxis,
    required this.series,
  });

  @override
  String toString() {
    final seriesString = series.map((s) => s.toString()).join(', ');

    return '''
    {
      title: ${title.toString()},
      ${subtitle != null ? 'subtitle: ${subtitle!.toString()},' : ''}
      xAxis: ${xAxis.toString()},
      yAxis: ${yAxis.toString()},
      series: [ $seriesString ]
    }
    ''';
  }
}

class HighChartsTitle {
  final String text;

  HighChartsTitle({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  @override
  String toString() {
    return '{ text: "$text" }';
  }
}

class HighChartsSubtitle {
  final String? text;

  HighChartsSubtitle({this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  @override
  String toString() {
    return '{ text: "$text" }';
  }
}

class HighChartsAxisTitle {
  final String text;

  HighChartsAxisTitle({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  @override
  String toString() {
    return '{ text: "$text" }';
  }
}

class HighChartsAxisLabels {
  final String? format;
  final Map<String, dynamic>? style;

  HighChartsAxisLabels({this.format, this.style});

  Map<String, dynamic> toJson() => {
        if (format != null) 'format': format,
        if (style != null) 'style': style,
      };

  @override
  String toString() {
    final styleString = style != null
        ? '{ ${style!.entries.map((e) => '${e.key}: "${e.value}"').join(', ')} }'
        : 'null';

    return '''
    {
      ${format != null ? 'format: "$format",' : ''}
      ${style != null ? 'style: $styleString' : ''}
    }
    ''';
  }
}

class HighChartsDataPoint {
  final double x; // Required
  final double y; // Required
  final String? name; // Optional
  final String? color; // Optional
  final Map<String, dynamic>? custom; // Optional custom data

  HighChartsDataPoint({
    required this.x,
    required this.y,
    this.name, // Optional
    this.color, // Optional
    this.custom, // Optional
  });

  // Convert to Map for JSON encoding
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        if (name != null) 'name': name,
        if (color != null) 'color': color,
        if (custom != null) 'custom': custom,
      };

  @override
  String toString() {
    final buffer = StringBuffer('{ x: $x, y: $y');

    // Add optional properties only if they are not null
    if (name != null) buffer.write(', name: "$name"');
    if (color != null) buffer.write(', color: "$color"');
    if (custom != null) {
      final customString = custom!.entries.map((e) {
        if (e.value is String) {
          return '${e.key}: "${e.value}"';
        }
        return '${e.key}: ${e.value}';
      }).join(', ');
      buffer.write(', custom: { $customString }');
    }

    buffer.write(' }');
    return buffer.toString();
  }
}

class HighChartsSeries {
  final String name;
  final String? type;
  final List<HighChartsDataPoint> data;

  HighChartsSeries({required this.name, this.type, required this.data});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'data': data.map((d) => d.toJson()).toList(),
      };

  @override
  String toString() {
    final dataString = data.map((d) => d.toString()).join(', ');

    return '''
    {
      name: "$name",
      ${type != null ? 'type: $type!,' : ''}
      data: [ $dataString ]
    }
    ''';
  }
}

class HighChartsXAxis {
  final HighChartsAxisTitle? title;
  final HighChartsAxisLabels? labels;
  final String? type;
  final Map<String, String>? dateTimeLabelFormats;
  final double? gridLineWidth;

  HighChartsXAxis({
    this.title,
    this.labels,
    this.type,
    this.dateTimeLabelFormats,
    this.gridLineWidth,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title!.toJson(),
        if (labels != null) 'labels': labels!.toJson(),
        if (type != null) 'type': type,
        if (dateTimeLabelFormats != null)
          'dateTimeLabelFormats': dateTimeLabelFormats,
        if (gridLineWidth != null) 'gridLineWidth': gridLineWidth,
      };

  @override
  String toString() {
    final dateTimeFormatsString = dateTimeLabelFormats != null
        ? '{ ${dateTimeLabelFormats!.entries.map((e) => '${e.key}: "${e.value}"').join(', ')} }'
        : 'null';

    return '''
    {
      ${title != null ? 'title: ${title!.toString()},' : ''}
      ${labels != null ? 'labels: ${labels!.toString()},' : ''}
      ${type != null ? 'type: "$type",' : ''}
      ${dateTimeLabelFormats != null ? 'dateTimeLabelFormats: $dateTimeFormatsString,' : ''}
      ${gridLineWidth != null ? 'gridLineWidth: $gridLineWidth' : ''}
    }
    ''';
  }
}

class HighChartsYAxis {
  final HighChartsAxisTitle? title;
  final HighChartsAxisLabels? labels;
  final double? min;
  final double? max;
  final double? gridLineWidth;

  HighChartsYAxis({
    this.title,
    this.labels,
    this.min,
    this.max,
    this.gridLineWidth,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title!.toJson(),
        if (labels != null) 'labels': labels!.toJson(),
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (gridLineWidth != null) 'gridLineWidth': gridLineWidth,
      };

  @override
  String toString() {
    return '''
    {
      ${title != null ? 'title: ${title!.toString()},' : ''}
      ${labels != null ? 'labels: ${labels!.toString()},' : ''}
      ${min != null ? 'min: $min,' : ''}
      ${max != null ? 'max: $max,' : ''}
      ${gridLineWidth != null ? 'gridLineWidth: $gridLineWidth' : ''}
    }
    ''';
  }
}
