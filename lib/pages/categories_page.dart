import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/notification_bloc.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/blocs/product_bloc2.dart';
import 'package:travel_hour/blocs/search_product_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/edit_profile.dart';
import 'package:travel_hour/pages/explore.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/more_products.dart';
import 'package:travel_hour/pages/my_report.dart';
import 'package:travel_hour/pages/notifications.dart';
import 'package:travel_hour/pages/regist_as_seller.dart';
import 'package:travel_hour/pages/report.dart';
import 'package:travel_hour/pages/search_product.dart';
import 'package:travel_hour/pages/sign_in.dart';
import 'package:travel_hour/pages/my_product.dart';
import 'package:travel_hour/pages/upload_product.dart';
// import 'package:travel_hour/pages/upload_products.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/language.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    final mpb = context.read<ProductBloc2>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationName: Config().appName,
            applicationIcon: Image(
              image: AssetImage(Config().splashIcon),
              height: 30,
              width: 30,
            ),
            applicationVersion: sb.appVersion,
          );
        });
  }

  TextStyle _textStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[900]);
  TextStyle _subtitle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    final p = context.watch<ProductBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories').tr(),
          centerTitle: false,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ).tr(),

            SizedBox(
              height: 15,
            ),

            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Beach', style: _textStyle).tr(),
                subtitle: Text("7 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(LineIcons.hotel, size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Landmark', style: _textStyle).tr(),
                subtitle: Text("5 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(LineIcons.landmark, size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Food', style: _textStyle).tr(),
                subtitle: Text("2 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                // selected: Colors.blue[250],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(FlutterIcons.food_fork_drink_mco,
                    size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Health', style: _textStyle).tr(),
                subtitle: Text("1 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                      child: Icon(Icons.local_hospital_rounded,
                    size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Business', style: _textStyle).tr(),
                subtitle: Text("8 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                      child: Icon(Feather.dollar_sign, size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Tourism', style: _textStyle).tr(),
                subtitle: Text("14 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                      child: Icon(Feather.compass, size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 7, right: 7, bottom: 18),
              child: ListTile(
                title: Text('Transportation', style: _textStyle).tr(),
                subtitle: Text("3 Destinations", style: _subtitle),
                tileColor: Colors.grey[50],
                selectedColor: Colors.blue[250],
                selectedTileColor: Colors.blue[250],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                      child: Icon(LineIcons.car, size: 40, color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(context, MorePlacesPage(title: "Place", color: Colors.blue[700],)),
              ),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
