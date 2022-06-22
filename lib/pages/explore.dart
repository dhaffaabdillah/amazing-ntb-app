import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/dashboard_blog_bloc.dart';
import 'package:travel_hour/blocs/featured_bloc.dart';
import 'package:travel_hour/blocs/popular_places_bloc.dart';
import 'package:travel_hour/blocs/recent_places_bloc.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/blocs/sp_state_one.dart';
import 'package:travel_hour/blocs/sp_state_two.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/constants/constants.dart';
import 'package:travel_hour/pages/bmkg.dart';
import 'package:travel_hour/widgets/blog_dashboard.dart';
import 'package:travel_hour/pages/profile.dart';
import 'package:travel_hour/pages/search.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/featured_places.dart';
import 'package:travel_hour/widgets/popular_places.dart';
import 'package:travel_hour/widgets/recent_places.dart';
import 'package:travel_hour/widgets/recommended_places.dart';
// import 'package:travel_hour/pages/products.dart';
import 'package:travel_hour/widgets/special_state1.dart';
import 'package:travel_hour/widgets/special_state2.dart';
import 'package:travel_hour/widgets/product.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:travel_hour/widgets/sub_menu_widget.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    reloadData();
  }

  Future reloadData() async {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await context
              .read<FeaturedBloc>()
              .getData()
              .then((value) => context.read<PopularPlacesBloc>().getData())
              .then((value) => context.read<RecentPlacesBloc>().getData())
              .then((value) => context.read<SpecialStateOneBloc>().getData())
              .then((value) => context.read<SpecialStateTwoBloc>().getData())
              .then((value) => context.read<RecommandedPlacesBloc>().getData())
              .then((value) => context.read<ProductBloc>().getData())
              .then((value) => context.read<DashboardBlogBloc>().getData())
          // .then((value) => context.read<Report>())
          ;
    });
  }

  Future _onRefresh() async {
    context.read<FeaturedBloc>().onRefresh();
    context.read<PopularPlacesBloc>().onRefresh(mounted);
    context.read<RecentPlacesBloc>().onRefresh(mounted);
    context.read<SpecialStateOneBloc>().onRefresh(mounted);
    context.read<SpecialStateTwoBloc>().onRefresh(mounted);
    context.read<RecommandedPlacesBloc>().onRefresh(mounted);
    context.read<ProductBloc>().onRefresh(mounted);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _onRefresh(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Header(),
                  Featured(),
                  SubMenu(),
                  PopularPlaces(),
                  RecentPlaces(),
                  SpecialStateOne(),
                  SpecialStateTwo(),
                  RecommendedPlaces(),
                  Products(),
                  BlogDashboards()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String location = "Null, press reload button.";
  String Address = "Location not found";

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location permission are not enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanenently denied, we cannot handle your permission.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[1];
    // Address =
    //     '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    Address = '${place.subAdministrativeArea}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    // Position position = await _getGeoLocationPosition();
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Config().appName,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800]),
                    ),
                    Row(
                      children: [
                        InkWell(
                          
                          child: Address.isNotEmpty
                              ? Text(
                                  '${Address}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]),
                                ).tr()
                              : Text(
                                  'Sumbawa',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]),
                                ).tr(),
                          onTap: () {
                            nextScreen(context, BMKGPage(Constants.bmkgPath));
                          },
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: IconButton(
                          tooltip: "Refresh",
                          splashRadius: 10,
                          onPressed: () async {
                          Position position =
                                    await _getGeoLocationPosition();
                                location =
                                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                                GetAddressFromLatLong(position);
                                print(location);
                                print(position);

                        } , icon: Icon(Icons.restart_alt_rounded, color: Colors.blue, size: 15,), iconSize: 15,),
                        // child: ElevatedButton.icon(
                        //       style: ElevatedButton.styleFrom(
                        //         primary: Colors.blue[500],
                        //         onPrimary: Colors.grey[10],
                        //         shadowColor: Colors.transparent,
                        //         padding: EdgeInsets.only(left: 7),
                        //         fixedSize: Size(5, 5),
                        //         shape: CircleBorder(),
                        //         side: BorderSide(
                        //           style: BorderStyle.none
                        //         ),
                        //       ),
                        //       onPressed: () async {
                        //         Position position =
                        //             await _getGeoLocationPosition();
                        //         location =
                        //             'Lat: ${position.latitude} , Long: ${position.longitude}';
                        //         GetAddressFromLatLong(position);
                        //         print(location);
                        //         print(position);
                        //       },
                        //       icon: Icon(Feather.refresh_cw),
                        //       label: Text("")
                        //   )
                        ),
                      ],
                    ),
                    Row(children: [
                      Text("Cerah Berawan",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 2,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Text("27° C",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ]),
                  ],
                ),
                Spacer(),
                InkWell(
                  child: sb.imageUrl == null || sb.isSignedIn == false
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: 28),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(sb.imageUrl!),
                                  fit: BoxFit.cover)),
                        ),
                  onTap: () {
                    nextScreen(context, ProfilePage());
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Feather.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'search places',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.w500),
                    ).tr(),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          )
        ],
      ),
    );
  }
}

class SubMenu extends StatelessWidget {
  const SubMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SubmenuWidget(),
    );
  }
}
