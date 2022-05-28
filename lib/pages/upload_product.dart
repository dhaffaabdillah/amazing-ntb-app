// // import 'dart:html';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:typed_data';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:travel_hour/blocs/admin_bloc.dart';
// import 'package:travel_hour/blocs/sign_in_bloc.dart';
// import 'package:travel_hour/utils/cached_image.dart';
// import 'package:travel_hour/utils/dialog.dart';
// import 'package:travel_hour/utils/snacbar.dart';
// import 'package:travel_hour/utils/styles.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class UploadProduct extends StatefulWidget {
//   const UploadProduct({Key? key}) : super(key: key);

//   @override
//   State<UploadProduct> createState() => _UploadProductState();
// }

// class _UploadProductState extends State<UploadProduct> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final User? currentUser = FirebaseAuth.instance.currentUser;
//   bool loading = false;
//   String? productName;
//   String? productDetail;
//   String? phone;
//   String? email;
//   String? status;
//   String? imageUrl1;
//   String? imageUrl2;
//   String? imageUrl3;

//   // String? imageName1;
//   // String? imageName2;
//   // String? imageName3;

//   File? imageFile1;
//   File? imageFile2;
//   File? imageFile3;
//   Uint8List? thumbnail, img1, img2;
//   String imageName1 = "", imageName2 = "", imageName3 = "";

//   var statusSelection;
//   var usersSelection = TextEditingController();
//   bool notifyUsers = true;
//   bool uploadStarted = false;
//   String? _timestamp;
//   String? _date;
//   var _productData;

//   var formKey = GlobalKey<FormState>();
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   var productNameCtrl = TextEditingController();
//   var productDetailCtrl = TextEditingController();
//   var productPrice = TextEditingController();
//   var phoneCtrl = TextEditingController();
//   var priceCtrl = TextEditingController();
//   var emailCtrl = TextEditingController();
//   var statusCtrl = TextEditingController();

//   Future pickImage() async {
//     final _imagePicker = ImagePicker();
//     // List<XFile>? imagePicked = await _imagePicker.pickMultiImage(imageQuality: 800);
//     var imagePicked1 =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     var imagePicked2 =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     var imagePicked3 =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (imagePicked1 != null) {
//       setState(() {
//         imageFile1 = File(imagePicked1.path);
//         imageFile2 = File(imagePicked2!.path);
//         imageFile3 = File(imagePicked3!.path);

//         imageName1 = (imageFile1!.path);
//         imageName2 = (imageFile2!.path);
//         imageName3 = (imageFile3!.path);
//       });
//     } else {
//       openSnacbar(scaffoldKey, 'You must upload 1 image of your product!');
//     }
//   }

//   Future uploadImage() async {
//     // final SignInBloc sb = context.read<SignInBloc>();
//     String time = _timestamp.toString();
//     Reference storageRef = FirebaseStorage.instance.ref().child("files/");
//     UploadTask uploadTask1 = storageRef.putFile(imageFile1!);
//     UploadTask uploadTask2 = storageRef.putFile(imageFile2!);
//     UploadTask uploadTask3 = storageRef.putFile(imageFile3!);

//     await uploadTask1.whenComplete(() async {
//       var _url = await storageRef.getDownloadURL();
//       var _imageUrl1 = _url.toString();
//       setState(() {
//         imageUrl1 = _imageUrl1;
//       });
//     });
//     await uploadTask2.whenComplete(() async {
//       var _url = await storageRef.getDownloadURL();
//       var _imageUrl2 = _url.toString();
//       setState(() {
//         imageUrl1 = _imageUrl2;
//       });
//     });
//     await uploadTask3.whenComplete(() async {
//       var _url = await storageRef.getDownloadURL();
//       var _imageUrl3 = _url.toString();
//       setState(() {
//         imageUrl3 = _imageUrl3;
//       });
//     });
//   }

//   Future insertData() async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();

//     FirebaseFirestore.instance.collection('product').doc(_timestamp);

//     sp.setString('productName', productNameCtrl.text);
//     sp.setString('productDetail', productDetailCtrl.text);
//     sp.setString('phone', phoneCtrl.text);
//     sp.setString('email', currentUser!.email!);
//     sp.setString('image-1', imageUrl1!);
//     sp.setString('image-2', imageUrl2!);
//     sp.setString('image-3', imageUrl3!);
//     sp.setString('image-3', imageUrl3!);
//     sp.setString('status', statusSelection!);
//     sp.setString('image-3', imageUrl3!);
//     sp.setString('image-3', imageUrl3!);

//     _name = newName;
//     _imageUrl = newImageUrl;

//     notifyListeners();
//   }

//   Future insertData() async {
//     final DocumentReference ref =
//         firestore.collection('product').doc(_timestamp);
//     String time = _timestamp.toString();
//     final SharedPreferences sp = await SharedPreferences.getInstance();

//     FirebaseFirestore.instance.collection('users').doc(_timestamp);
//     _productData = {
//       'productName': productNameCtrl.text,
//       'productDetail': productDetailCtrl.text,
//       'email': currentUser!.email,
//       'phone': phoneCtrl.text,
//       'price': priceCtrl.text,
//       'image-1': imageUrl1,
//       'image-2': path2,
//       'image-3': path3,
//       'status': statusSelection,
//       'created_at': _date,
//       'updated_at': _date,
//       'timestamp': _timestamp
//     };
//     await ref.set(_productData);
//     // notifyListeners();
//   }

//   Future getDate() async {
//     DateTime now = DateTime.now();
//     String _d = DateFormat('dd MMMM yy').format(now);
//     String _t = DateFormat('yyyyMMddHHmmss').format(now);
//     setState(() {
//       _timestamp = _t;
//       _date = _d;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {}
// }
