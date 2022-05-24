import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';

class RegistAsSeller extends StatefulWidget {
  final int? statusSeller;
  // final String? imageUrl;

  RegistAsSeller({Key? key, required this.statusSeller}) : super(key: key);

  @override
  _RegistAsSellerState createState() => _RegistAsSellerState(this.statusSeller);
}

class _RegistAsSellerState extends State<RegistAsSeller> {
  _RegistAsSellerState(this.statusSeller);

  int? statusSeller;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var statusSellerCtrl = TextEditingController();

  Future handleUpdateData() async {
    final sb = context.read<SignInBloc>();
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      } else {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() => loading = true);

          await sb.updateToSeller(2).then((value) {
            openSnacbar(scaffoldKey, 'request as seller sent'.tr());
            setState(() => loading = false);
          });
          
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    statusSellerCtrl.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('regist as seller').tr(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'type yes'.tr(),
                  ),
                  controller: statusSellerCtrl,
                  validator: (value) {
                    if (value! != "Yes") return 'You must type "Yes" to be a seller!';
                    return null;
                  },
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).primaryColor),
                    textStyle: MaterialStateProperty.resolveWith(
                        (states) => TextStyle(color: Colors.white))),
                child: loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text(
                        'update status as seller',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ).tr(),
                onPressed: () {
                  handleUpdateData();
                },
              ),
            ),
          ],
        ));
  }
}
