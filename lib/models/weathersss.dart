import 'dart:convert';
import 'dart:ffi';

List<Weather> modelWeatherFromJson(String str) => List<Weather>.from(json.decode(str).map((x) => Weather.fromJson(x)));
String modelUserToJson(List<Weather> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Weather {
  bool? success;
  Row? row;

  Weather({this.success, this.row});

  Weather.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    row = json['row'] != null ? new Row.fromJson(json['row']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    if (this.row != null) {
      data['row'] = this.row!.toJson();
    }
    return data;
  }
}

class Row {
  Data? data;

  Row({this.data});

  Row.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? source;
  String? productioncenter;
  Forecast? forecast;

  Data({this.source, this.productioncenter, this.forecast});

  Data.fromJson(Map<String, dynamic> json) {
    source = json['@source'];
    productioncenter = json['@productioncenter'];
    forecast = json['forecast'] != null
        ? new Forecast.fromJson(json['forecast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@source'] = this.source;
    data['@productioncenter'] = this.productioncenter;
    if (this.forecast != null) {
      data['forecast'] = this.forecast!.toJson();
    }
    return data;
  }
}

class Forecast {
  String? domain;
  Issue? issue;
  List<Area>? area;

  Forecast({this.domain, this.issue, this.area});

  Forecast.fromJson(Map<String, dynamic> json) {
    domain = json['@domain'];
    issue = json['issue'] != null ? new Issue.fromJson(json['issue']) : null;
    if (json['area'] != null) {
      area = <Area>[];
      json['area'].forEach((v) {
        area!.add(new Area.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@domain'] = this.domain;
    if (this.issue != null) {
      data['issue'] = this.issue!.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Issue {
  String? timestamp;
  String? year;
  String? month;
  String? day;
  String? hour;
  String? minute;
  String? second;

  Issue(
      {this.timestamp,
      this.year,
      this.month,
      this.day,
      this.hour,
      this.minute,
      this.second});

  Issue.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['second'] = this.second;
    return data;
  }
}

class Area {
  String? id;
  String? latitude;
  String? longitude;
  String? coordinate;
  String? type;
  String? region;
  String? level;
  String? description;
  String? domain;
  String? tags;
  List<Name>? name;
  List<Parameter>? parameter;

  Area(
      {this.id,
      this.latitude,
      this.longitude,
      this.coordinate,
      this.type,
      this.region,
      this.level,
      this.description,
      this.domain,
      this.tags,
      this.name,
      this.parameter});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
    latitude = json['@latitude'];
    longitude = json['@longitude'];
    coordinate = json['@coordinate'];
    type = json['@type'];
    region = json['@region'];
    level = json['@level'];
    description = json['@description'];
    domain = json['@domain'];
    tags = json['@tags'];
    if (json['name'] != null) {
      name = <Name>[];
      json['name'].forEach((v) {
        name!.add(new Name.fromJson(v));
      });
    }
    if (json['parameter'] != null) {
      parameter = <Parameter>[];
      json['parameter'].forEach((v) {
        parameter!.add(new Parameter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@id'] = this.id;
    data['@latitude'] = this.latitude;
    data['@longitude'] = this.longitude;
    data['@coordinate'] = this.coordinate;
    data['@type'] = this.type;
    data['@region'] = this.region;
    data['@level'] = this.level;
    data['@description'] = this.description;
    data['@domain'] = this.domain;
    data['@tags'] = this.tags;
    if (this.name != null) {
      data['name'] = this.name!.map((v) => v.toJson()).toList();
    }
    if (this.parameter != null) {
      data['parameter'] = this.parameter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String? xmlLang;
  String? text;

  Name({this.xmlLang, this.text});

  Name.fromJson(Map<String, dynamic> json) {
    xmlLang = json['@xml:lang'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@xml:lang'] = this.xmlLang;
    data['#text'] = this.text;
    return data;
  }
}

class Parameter {
  String? id;
  String? description;
  String? type;
  List<Timerange>? timerange;

  Parameter({this.id, this.description, this.type, this.timerange});

  Parameter.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
    description = json['@description'];
    type = json['@type'];
    if (json['timerange'] != null) {
      timerange = <Timerange>[];
      json['timerange'].forEach((v) {
        timerange!.add(new Timerange.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@id'] = this.id;
    data['@description'] = this.description;
    data['@type'] = this.type;
    if (this.timerange != null) {
      data['timerange'] = this.timerange!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timerange {
  String? type;
  String? h;
  String? datetime;
  Value? value;
  String? day;

  Timerange({this.type, this.h, this.datetime, this.value, this.day});

  Timerange.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    h = json['@h'];
    datetime = json['@datetime'];
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
    day = json['@day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@type'] = this.type;
    data['@h'] = this.h;
    data['@datetime'] = this.datetime;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['@day'] = this.day;
    return data;
  }
}

class Value {
  String? unit;
  String? text;

  Value({this.unit, this.text});

  Value.fromJson(Map<String, dynamic> json) {
    unit = json['@unit'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@unit'] = this.unit;
    data['#text'] = this.text;
    return data;
  }
}
