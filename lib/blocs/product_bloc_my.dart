// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:travel_hour/blocs/sign_in_bloc.dart';
// import 'package:travel_hour/models/product.dart';

// class MyProductBloc extends ChangeNotifier {

//   DocumentSnapshot? _lastVisible;
//   DocumentSnapshot? get lastVisible => _lastVisible;

//   bool _isLoading = true;
//   bool get isLoading => _isLoading;

//   List<Product> _data = [];
//   List<Product> get data => _data;

//   String _popSelection = 'popular';
//   String get popupSelection => _popSelection;


//   List<DocumentSnapshot> _snap = [];
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;


//   bool? _hasData;
//   bool? get hasData => _hasData;




//   Future<Null> getData(mounted, String orderBy) async {
//     _hasData = true;
//     QuerySnapshot rawData;
//   final sb = context.watch<SignInBloc>();
//     if (_lastVisible == null)
//       rawData = await firestore
//           .collection('product')
//           .orderBy(orderBy, descending: true)
//           .where('userId', isEqualTo: true)
//           .get();
//     else
//       rawData = await firestore
//           .collection('product')
//           .orderBy(orderBy, descending: true)
//           .startAfter([_lastVisible![orderBy]])
//           .limit(5)
//           .get();





//     if (rawData.docs.length > 0) {
//       _lastVisible = rawData.docs[rawData.docs.length - 1];
//       if (mounted) {
//         _isLoading = false;
//         _snap.addAll(rawData.docs);
//         _data = _snap.map((e) => Product.fromFirestore(e)).toList();
//       }
//     } else {

//       if(_lastVisible == null){

//         _isLoading = false;
//         _hasData = false;
//         print('no items');

//       }else{
//         _isLoading = false;
//         _hasData = true;
//         print('no more items');
//       }
      
//     }

//     notifyListeners();
//     return null;
//   }


//   afterPopSelection (value, mounted, orderBy){
//     _popSelection = value;
//     onRefresh(mounted, orderBy);
//     notifyListeners();
//   }



//   setLoading(bool isloading) {
//     _isLoading = isloading;
//     notifyListeners();
//   }




//   onRefresh(mounted, orderBy) {
//     _isLoading = true;
//     _snap.clear();
//     _data.clear();
//     _lastVisible = null;
//     getData(mounted, orderBy);
//     notifyListeners();
//   }


// }
