import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:travel_hour/constants/constants.dart';
// import 'package:travel_hour/models/weather.dart';
import 'package:travel_hour/models/weathersss.dart';  

Future<Weather> fetchWeather() async {
  final res = await http.get(Uri.parse(Constants.weatherAPI));
  if (res.statusCode == 200) {
    return Weather.fromJson(jsonDecode(res.body));
    // return parsed.map<Weather>((json) => Weather.fromMap(json)).toList();
  } else {
    throw Exception('Failed to fetch data');
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Weather> futureWeather;

  List<Weather> _list = [];
  var loading = false;
  Future<Null> _fetchWeather() async {
    setState(() {
      loading = true;
    });

    final res = await http.get(Uri.parse(Constants.weatherAPI));
    // print(res.body);
    if (res.statusCode == 200) {
      final datax = jsonDecode(res.body);
      // as Map<String, dynamic>;
      setState(() {
        for (Map<String, dynamic> i in datax) {
          _list.add(Weather.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // futureWeather = fetchWeather();
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Report is Jojo Reference'),
      ),
      body: Container(
        // child: FutureBuilder<Weather>(
        //     future: futureWeather,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Text(snapshot.data!.row!.data!.forecast!.area!.elementAt(0).description.toString());
        //       } else if (snapshot.hasError) {
        //         return Text('${snapshot.error}');
        //       }

        //       // By default, show a loading spinner.
        //       return const CircularProgressIndicator();
        //     },
        //   ),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, i) {
                  final x = _list[i];
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          x.row!.data!.forecast!.area!
                              .elementAt(i)
                              .description
                              .toString(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
