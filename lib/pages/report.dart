import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_hour/blocs/admin_bloc.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/dialog.dart';
import 'package:travel_hour/utils/styles.dart';
// import 'package:travel_hour/widgets/product_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:searchfield/searchfield.dart';
// import 'package:universal_html/html.dart';

class Report extends StatefulWidget {
  Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  var formKey = GlobalKey<FormState>();

  var productNameCtrl = TextEditingController();
  var productDetailCtrl = TextEditingController();
  var sellerContact = TextEditingController();
  var priceCtrl = TextEditingController();

  Uint8List? thumbnail, img1, img2;
  String thumbnailName = "", img1Name = "", img2Name = "";

  var statusSelection;
  var usersSelection = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool notifyUsers = true;
  bool uploadStarted = false;
  String? _timestamp;
  String? _date;
  var _productData;

  void handleSubmit() async {
    // final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

    if (statusSelection == null) {
      openDialog(context, 'Select Status Please', '');
    } else if (thumbnailName.length == 0) {
      openDialog(context, 'Please Input your thumbnail First', '');
    } else {
      // if (formKey.currentState!.validate()) {
      //   formKey.currentState!.save();
      // if (ab.userType == 'tester') {
      //   openDialog(context, 'You are a Tester',
      //       'Only Admin can upload, delete & modify contents');
      // } else {
      setState(() => uploadStarted = true);
      await getDate().then((_) async {
        await saveToDatabase();
        // .then((value) => context.read<AdminBloc>().increaseCount('products_count'));
        setState(() => uploadStarted = false);
        openDialog(context, 'Upload Successfully', '');
        clearTextFeilds();
      });
      // }
      // }
    }
  }

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _timestamp = _t;
      _date = _d;
    });
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection('product').doc(_timestamp);
    String waktu = _timestamp.toString();
    FirebaseStorage.instance
        .ref()
        .child("files/$waktu-thumbnail-$thumbnailName")
        .putData(thumbnail!);

    String path1 =
        "https://firebasestorage.googleapis.com/v0/b/dev-admin-amazing-ntb.appspot.com/o/files%2F$waktu-thumbnail-$thumbnailName?alt=media";
    String path2 = img1Name.length == 0
        ? ""
        : "https://firebasestorage.googleapis.com/v0/b/dev-admin-amazing-ntb.appspot.com/o/files%2F$waktu-img1-$img1Name?alt=media";
    String path3 = img2Name.length == 0
        ? ""
        : "https://firebasestorage.googleapis.com/v0/b/dev-admin-amazing-ntb.appspot.com/o/files%2F$waktu-img2-$img2Name?alt=media";

    if (path2.length > 0) {
      FirebaseStorage.instance
          .ref()
          .child("files/$waktu-img1-$img1Name")
          .putData(img1!);
    }

    if (path3.length > 0) {
      FirebaseStorage.instance
          .ref()
          .child("files/$waktu-img2-$img2Name")
          .putData(img2!);
    }

    _productData = {
      'productName': productNameCtrl.text,
      'productDetail': productDetailCtrl.text,
      'email': currentUser!.email,
      'phone': sellerContact.text,
      'price': priceCtrl.text,
      'image-1': path1,
      'image-2': path2,
      'image-3': path3,
      'status': statusSelection,
      'created_at': _date,
      'updated_at': _date,
      'timestamp': _timestamp
    };
    await ref.set(_productData);
  }

  clearTextFeilds() {
    productNameCtrl.clear();
    productDetailCtrl.clear();
    sellerContact.clear();
    usersSelection.clear();
    priceCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  // handlePreview() async {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     await getDate().then((_) async {
  //       await showProductPreview(
  //           context,
  //           productNameCtrl.text,
  //           productDetailCtrl.text,
  //           "",
  //           sellerContact.text,
  //           statusSelection,
  //           'Now',
  //           priceCtrl.text,);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Report Nearby Area")),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                statusDropdown(),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'Enter Product Name', 'Product Name', productNameCtrl),
                  controller: productNameCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'Value is empty';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'Enter Phone Number', 'Phone', sellerContact),
                  controller: sellerContact,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Value is empty';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration('Enter Price', 'Price', priceCtrl),
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Value is empty';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   height: 150,
                //   width: MediaQuery.of(context).size.width,
                //   child: CustomCacheImage(
                //       imageUrl: "", radius: 0.0)
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                TextButton(
                  style: buttonStyleIMG(Colors.grey[200]),
                  onPressed: () async {
                    FilePickerResult? thumbnailResult =
                        await FilePicker.platform.pickFiles();

                    if (thumbnailResult != null) {
                      if (thumbnailResult.files.first.size > 1200000) {
                        openDialog(context, "Image Too Large", "");
                      } else {
                        thumbnail = thumbnailResult.files.first.bytes;
                        thumbnailName = thumbnailResult.files.first.name;
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Upload Thumnail (Image 1)",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   height: 150,
                //   width: MediaQuery.of(context).size.width,
                //   child: CustomCacheImage(
                //       imageUrl: "", radius: 0.0)
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                TextButton(
                  style: buttonStyleIMG(Colors.grey[200]),
                  onPressed: () async {
                    FilePickerResult? thumbnailResult =
                        await FilePicker.platform.pickFiles();

                    if (thumbnailResult != null) {
                      if (thumbnailResult.files.first.size > 1200000) {
                        openDialog(context, "Image Too Large", "");
                      } else {
                        img1 = thumbnailResult.files.first.bytes;
                        img1Name = thumbnailResult.files.first.name;
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Upload Image 2",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   height: 150,
                //   width: MediaQuery.of(context).size.width,
                //   child: CustomCacheImage(
                //       imageUrl: "", radius: 0.0)
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                TextButton(
                  style: buttonStyleIMG(Colors.grey[200]),
                  onPressed: () async {
                    FilePickerResult? thumbnailResult =
                        await FilePicker.platform.pickFiles();

                    if (thumbnailResult != null) {
                      if (thumbnailResult.files.first.size > 1200000) {
                        openDialog(context, "Image Too Large", "");
                      } else {
                        img2 = thumbnailResult.files.first.bytes;
                        img2Name = thumbnailResult.files.first.name;
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Upload Image 3",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter Description (Html or Normal Text)',
                      border: OutlineInputBorder(),
                      labelText: 'Product Description',
                      contentPadding:
                          EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                              icon: Icon(Icons.close, size: 15),
                              onPressed: () {
                                productDetailCtrl.clear();
                              }),
                        ),
                      )),
                  textAlignVertical: TextAlignVertical.top,
                  minLines: 5,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: productDetailCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'Value is empty';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     TextButton.icon(
                //         icon: Icon(
                //           Icons.remove_red_eye,
                //           size: 25,
                //           color: Colors.blueAccent,
                //         ),
                //         label: Text(
                //           'Preview',
                //           style: TextStyle(
                //               fontWeight: FontWeight.w400, color: Colors.black),
                //         ),
                //         onPressed: () {
                //           handlePreview();
                //         })
                //   ],
                // ),
                Container(
                    color: Colors.deepPurpleAccent,
                    height: 45,
                    child: uploadStarted == true
                        ? Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                          )
                        : TextButton(
                            child: Text(
                              'Upload Report',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              handleSubmit();
                            }
                          )
                        ),
                SizedBox(
                  height: 50,
                ),
              ],
            )
          )
        ),
    );
  }

  Widget statusDropdown() {
    // final AdminBloc ab = Provider.of(context, listen: false);

    List<String> ab = ["Terjual", "Belum Terjual"];

    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (dynamic value) {
              setState(() {
                statusSelection = value;
              });
            },
            onSaved: (dynamic value) {
              setState(() {
                statusSelection = value;
              });
            },
            value: statusSelection,
            hint: Text('Select Status'),
            items: ab.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }
}
