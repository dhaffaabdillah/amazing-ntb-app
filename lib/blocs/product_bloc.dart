import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/models/product.dart';

class ProductBloc extends ChangeNotifier {
  List<Product> _data = [];
  List<Product> get data => _data;
  String? _timestamp;
  String? _date;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getData() async {
    QuerySnapshot rawData;
    rawData = await firestore
        .collection('product')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs);
    _data = _snap.map((e) => Product.fromFirestore(e)).toList();
    notifyListeners();
  }

  // Future updateUserProfile(String newName, String newImageUrl) async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();

  //   FirebaseFirestore.instance.collection('product').doc(_timestamp);

  //   sp.setString('name', newName);
  //   sp.setString('image_url', newImageUrl);
  //   _name = newName;
  //   _imageUrl = newImageUrl;

  //   notifyListeners();
  // }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }
}
