import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'Amazing NTB';
  final String mapAPIKey = 'AIzaSyAVBeNtegNaOBRwO7Sm66_UIcsmFByn-D8';
  final String weatherAPIKey = 'dc4acf223ee7225d88d44cb1390ce222';
  final String countryName = 'Indonesia';
  final String splashIcon = 'assets/images/icon-app.png';
  final String supportEmail = 'info@redcorp.id';
  final String privacyPolicyUrl =
      'https://www.freeprivacypolicy.com/privacy/view/053321284ad71cfd5531cf60284de614';
  final String iOSAppId = '000000';

  final String yourWebsiteUrl = 'https://www.redcorp.id';
  final String facebookPageUrl = 'https://www.facebook.com/google';
  final String youtubeChannelUrl = 'https://www.youtube.com/channel/aaaaaaaaa';
  final String whatsappAPI = 'https://api.whatsapp.com/send?phone=62';

  // app theme color - primary color
  static final Color appThemeColor = Colors.blueAccent;

  //special two states name that has been already upload from the admin panel
  final String specialState1 = 'Sumbawa';
  final String specialState2 = 'Lombok';
  final String product = 'Products';

  //relplace by your country lattitude & longitude
  final CameraPosition initialCameraPosition = CameraPosition(
    // target: LatLng(-8.762601718360642, 116.27274120900596), //here
    target: LatLng(-6.200000, 106.816666),
    zoom: 10,
  );

  //google maps marker icons
  final String hotelIcon = 'assets/images/hotel.png';
  final String restaurantIcon = 'assets/images/restaurant.png';
  final String hotelPinIcon = 'assets/images/hotel_pin.png';
  final String restaurantPinIcon = 'assets/images/restaurant_pin.png';
  final String drivingMarkerIcon = 'assets/images/driving_pin.png';
  final String destinationMarkerIcon =
      'assets/images/destination_map_marker.png';

  //Intro images
  final String introImage1 = 'assets/images/introBG1.png';
  final String introImage2 = 'assets/images/introBG2.png';

  //Language Setup
  final List<String> languages = ['English', 'Spanish', 'Arabic', "Indonesia"];
}
