import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/admin_bloc.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/blocs/product_bloc2.dart';
import 'package:travel_hour/blocs/report_bloc.dart';
import 'package:travel_hour/blocs/search_product_bloc.dart';
import 'package:travel_hour/blocs/search_report_bloc.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/pages/splash.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/blog_bloc.dart';
import 'blocs/bookmark_bloc.dart';
import 'blocs/comments_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/other_places_bloc.dart';
import 'blocs/popular_places_bloc.dart';
import 'blocs/recent_places_bloc.dart';
import 'blocs/recommanded_places_bloc.dart';
import 'blocs/product_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/sign_in_bloc.dart';
import 'blocs/sp_state_one.dart';
import 'blocs/sp_state_two.dart';
import 'blocs/state_bloc.dart';
import 'package:easy_localization/easy_localization.dart';


final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =  FirebaseAnalyticsObserver(analytics: firebaseAnalytics);



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogBloc>( create: (context) => BlogBloc(),),
        ChangeNotifierProvider<SignInBloc>(create: (context) => SignInBloc(),),
        ChangeNotifierProvider<CommentsBloc>(create: (context) => CommentsBloc(),),
        ChangeNotifierProvider<BookmarkBloc>(create: (context) => BookmarkBloc(),),
        ChangeNotifierProvider<PopularPlacesBloc>(create: (context) => PopularPlacesBloc(),),
        ChangeNotifierProvider<RecentPlacesBloc>(create: (context) => RecentPlacesBloc(),),
        ChangeNotifierProvider<RecommandedPlacesBloc>(create: (context) => RecommandedPlacesBloc(),),
        ChangeNotifierProvider<FeaturedBloc>(create: (context) => FeaturedBloc(),),
        ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
        ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        ChangeNotifierProvider<StateBloc>(create: (context) => StateBloc()),
        ChangeNotifierProvider<SpecialStateOneBloc>(create: (context) => SpecialStateOneBloc()),
        ChangeNotifierProvider<SpecialStateTwoBloc>(create: (context) => SpecialStateTwoBloc()),
        ChangeNotifierProvider<OtherPlacesBloc>(create: (context) => OtherPlacesBloc()),
        ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
        ChangeNotifierProvider<ProductBloc>(create: (context) => ProductBloc()),
        ChangeNotifierProvider<ProductBloc2>(create: (context) => ProductBloc2()),
        ChangeNotifierProvider<AdminBloc>(create: (context) => AdminBloc()),
        ChangeNotifierProvider<SearchProductBloc>(create: (context) => SearchProductBloc()),
        ChangeNotifierProvider<SearchReportBloc>(create: (context) => SearchReportBloc()),
        ChangeNotifierProvider<ReportBloc>(create: (context) => ReportBloc()),


      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          navigatorObservers: [firebaseObserver],
          theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Config.appThemeColor,
              iconTheme: IconThemeData(color: Colors.grey[900]),
              fontFamily: 'Manrope',
              scaffoldBackgroundColor: Colors.grey[100],
              appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.grey[800],
                ),
                titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                    color: Colors.grey[900]
                  )
              ),),
          home: SplashPage()),
    ); 
  }
}