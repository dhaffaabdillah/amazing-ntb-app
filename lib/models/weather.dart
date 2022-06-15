import 'dart:ffi';

class Weather {
  final bool Success;
  final Row row;

  Weather({required this.Success, required this.row});
  factory Weather.fromJson(Map<String, dynamic> json) {
    return new Weather(
        Success: json['Success'], row: Row.fromJson(json['row']));
  }
}

class Row {
  final Data data;

  Row({required this.data});
  factory Row.fromJson(Map<String, dynamic> json) {
    return new Row(data: Data.fromJson(json['data']));
  }
}

class Data {
  final String source;
  final String productionCenter;
  final Forecast forecast;
  Data(
      {required this.source,
      required this.productionCenter,
      required this.forecast});
  factory Data.fromJson(Map<String, dynamic> json) {
    return new Data(
      source: json['@source'],
      productionCenter: json['@productioncenter'],
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class Forecast {
  final String domain;
  final Issue issue;
  List<Area> area;
  Forecast(this.area, {required this.domain, required this.issue});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var areaObj = json['area'] as List;
    List<Area> _area = areaObj.map((e) => Area.fromJson(e)).toList();
    return new Forecast(_area,
        domain: json['@domain'], issue: Issue.fromJson(json['issue']));
  }
}

class Area {
  final String id,
      latitude,
      longitude,
      coordinate,
      type,
      region,
      level,
      description,
      domains;
  List<Name> name;

  Area(this.name,
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.coordinate,
      required this.type,
      required this.region,
      required this.level,
      required this.description,
      required this.domains});

  factory Area.fromJson(Map<String, dynamic> json) {
    var nameObj = json['name'] as List;
    List<Name> _name = nameObj.map((e) => Name.fromJson(e)).toList();
    return new Area(_name,
        id: json['@id'],
        latitude: json['@latitude'],
        longitude: json['@longitude'],
        coordinate: json['@coordinate'],
        type: json['@type'],
        region: json['@region'],
        level: json['@level'],
        description: json['@description'],
        domains: json['@domain']);
  }
}

class Name {
  final String xmlLang, text;
  Name({required this.xmlLang, required this.text});

  factory Name.fromJson(Map<String, dynamic> json) {
    return new Name(text: json['#text'], xmlLang: json['@xml:lang']);
  }
}

class Parameter {
  final String id, description, type;
  List<Timerange> timerange;
  Parameter(this.timerange,
      {required this.id, required this.description, required this.type});

  factory Parameter.fromJson(Map<String, dynamic> json) {
    var timerangeObj = json['timerange'] as List;
    List<Timerange> _timerange =
        timerangeObj.map((e) => Timerange.fromJson(e)).toList();
    return new Parameter(_timerange,
        id: json['@id'], description: json['@description'], type: json['@type']);
  }
}

class Timerange {
  final String type, hour, datetime;
  List<Value> val;
  Timerange(this.val,
      {required this.type, required this.hour, required this.datetime});
  factory Timerange.fromJson(Map<String, dynamic> json) {
    var valObj = json['value'] as List;
    List<Value> _val = valObj.map((e) => Value.fromJson(e)).toList();
    return new Timerange(_val,
        type: json['@type'], hour: json['@h'], datetime: json['@datetime']);
  }
}

class Value {
  final String unit, text;
  Value({required this.unit, required this.text});
  factory Value.fromJson(Map<String, dynamic> json) {
    return new Value(unit: json['@unit'], text: json['#text']);
  }
}

class Issue {
  final String timestamp, year, month, day, hour, minute, second;

  Issue(
      {required this.timestamp,
      required this.year,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute,
      required this.second});
  factory Issue.fromJson(Map<String, dynamic> json) {
    return new Issue(
      timestamp: json['timestamp'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
    );
  }
}
