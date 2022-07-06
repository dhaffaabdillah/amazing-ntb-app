import 'package:travel_hour/config/config.dart';

class Constants {
  static final String fcmSubscriptionTopic = 'all';
  // path for cdn files and default path

  static final String logPath =
      "https://firebasestorage.googleapis.com/v0/b/dev-admin-amazing-ntb.appspot.com/o/files%2F";
  static final String defaultPath =
      "https://firebasestorage.googleapis.com/v0/b/amazingntb.appspot.com/o/Default%20Files%2Ficon-app-modified.png?alt=media&token=11ee47a6-d019-4746-b332-4d25bf6c1680";
  static final String weatherAPI =
      "https://cuaca.umkt.ac.id/api/cuaca/DigitalForecast-NusaTenggaraBarat.xml?format=json";
  static final String openWeatherApi = "https://api.openweathermap.org/data/2.5/weather?appid="+Config().weatherAPIKey;
  static final String bmkgPath =
      "https://www.bmkg.go.id/cuaca/prakiraan-cuaca.bmkg?kab=Mataram&Prov=Nusa_Tenggara_Barat&AreaID=501421&lang=ID";
}
