import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/config/config.dart';
class MyProduct extends StatefulWidget {

  final String? productName;
  final String? productDetails;
  final String? authorId;
  final int? price;
  final String? sellerContact;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? status;
  final String? date;
  final String? timestamp;

  MyProduct({Key? key,  this.productName,  this.image1, this.productDetails, this.authorId, this.price, this.sellerContact, this.image2, this.image3, this.image4, this.status, this.date, this.timestamp}) : super(key: key);

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('select language').tr(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: Config().languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config().languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(LineIcons.language),
          title: Text(d,),
          onTap: () async {
            if (d == 'English') {
              context.setLocale(Locale('en'));
            } else if (d == 'Spanish') {
              context.setLocale(Locale('es'));
            } else if (d == 'Arabic') {
              context.setLocale(Locale('ar'));
            }
            // else if(d == 'your_language_name'){
            //   context.setLocale(Locale('your_language_code'));
            // }
            Navigator.pop(context);
          },
        ),
        Divider(height: 5, color: Colors.grey[400],)
      ],
    );
  }
}
