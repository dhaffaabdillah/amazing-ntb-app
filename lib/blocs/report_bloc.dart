import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/models/product.dart';

class ProductBloc extends ChangeNotifier {
  List<Product> _data = [];
  List<Product> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  var formKey = GlobalKey<FormState>();
  bool loading = false;
  String? productName;
  String? productDetail;
  String? phone;
  String? email;
  String? status;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;

  // String? imageName1;
  // String? imageName2;
  // String? imageName3;

  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  Uint8List? thumbnail, img1, img2;
  String imageName1 = "", imageName2 = "", imageName3 = "";

  var statusSelection;
  var usersSelection = TextEditingController();
  bool notifyUsers = true;
  bool uploadStarted = false;
  String? _timestamp;
  String? _date;
  var _productData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var productNameCtrl = TextEditingController();
  var productDetailCtrl = TextEditingController();
  var productPrice = TextEditingController();
  var phoneCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var statusCtrl = TextEditingController();

  // var statusSelection;

  Future getData() async {
    QuerySnapshot rawData;
    rawData = await firestore
        .collection('reports')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs);
    _data = _snap.map((e) => Product.fromFirestore(e)).toList();
    notifyListeners();
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection('product').doc(_timestamp);
    _productData = {
      'productName': productNameCtrl.text,
      'productDetail': productDetailCtrl.text,
      'email': currentUser!.email,
      'phone': phoneCtrl.text,
      'price': priceCtrl.text,
      'image-1': imageUrl1,
      'image-2': imageUrl2,
      'image-3': imageUrl3,
      'status': statusSelection,
      'created_at': _date,
      'updated_at': _date,
      'timestamp': _timestamp
    };
    await ref.set(_productData);
    notifyListeners();
  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }
}
