import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travel_hour/models/blog.dart';
import 'package:travel_hour/models/place.dart';

class DashboardBlogBloc extends ChangeNotifier{
  
  List<Blog> _data = [];
  List<Blog> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getData() async {
    QuerySnapshot rawData;
      rawData = await firestore
          .collection('blogs')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      
      List<DocumentSnapshot> _snap = [];
      _snap.addAll(rawData.docs);
      _data = _snap.map((e) => Blog.fromFirestore(e)).toList();
      notifyListeners();
    
    
  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }





}