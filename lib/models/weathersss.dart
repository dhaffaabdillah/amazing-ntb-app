import 'dart:convert';
import 'dart:ffi';

List<Weathers> weathersFromJson(String str) =>
    List<Weathers>.from(json.decode(str).map((x) => Weathers.fromMap(x)));

class Weathers {
  Bool Success;
  String forecast,
      issue,
      timestamp,
      year,
      month,
      day,
      hour,
      minute,
      area,
      area_id,
      latitude,
      longitude,
      coodinate,
      description_area,
      parameter,
      parameter_id,
      parameter_desc,
      parameter_type,
      parameter_timerange,
      parameter_timerange_datetime,
      parameter_timerange_value,
      parameter_timerange_value_unit,
      parameter_timerange_value_text;

  Weathers({
    required this.Success,
    required this.forecast,
    required this.issue,
    required this.timestamp,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.area,
    required this.area_id,
    required this.latitude,
    required this.longitude,
    required this.coodinate,
    required this.description_area,
    required this.parameter,
    required this.parameter_id,
    required this.parameter_desc,
    required this.parameter_type,
    required this.parameter_timerange,
    required this.parameter_timerange_datetime,
    required this.parameter_timerange_value,
    required this.parameter_timerange_value_unit,
    required this.parameter_timerange_value_text,
  });

  factory Weathers.fromMap(Map<String, dynamic> json) => Weathers(
        Success: json['Success'],
        forecast: json['forecast'],
        issue: json['issue'],
        timestamp: json['timestamp'],
        year: json['year'],
        month: json['month'],
        day: json['month'],
        hour: json['hour'],
        minute: json['minute'],
        area: json['area'],
        area_id: json['area']['@id'],
        latitude: json['area']['@latitude'],
        longitude: json['area']['@longitude'],
        coodinate: json['area']['@coordinate'],
        description_area: json['area']['@description'],
        parameter: json['parameter'],
        parameter_id: json['parameter']['@id'],
        parameter_desc: json['parameter']['@description'],
        parameter_type: json['parameter']['@type'],
        parameter_timerange: json['parameter']['timerange'],
        parameter_timerange_datetime: json['parameter']['timerange']
            ['@datetime'],
        parameter_timerange_value: json['parameter']['timerange']['value'],
        parameter_timerange_value_unit: json['parameter']['timerange']['value']
            ['@unit'],
        parameter_timerange_value_text: json['parameter']['timerange']['value']
            ['#text'],
      );
}
