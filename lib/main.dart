import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_hour/services/http_overrides.dart';
import 'app.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),  
      useOnlyLangCode: true,
      child: MyApp(),
    )
  );
}


// https://maps.googleapis.com/maps/api/js?key=AIzaSyC_8anj4JZAqqXy2c80oeDvV8OIhFDZIH4&libraries=places&callback=initMap&libraries=&v=weekly
