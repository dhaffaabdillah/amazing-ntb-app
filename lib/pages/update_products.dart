import 'dart:typed_data';

import 'package:travel_hour/blocs/admin_bloc.dart';
import 'package:travel_hour/models/blog.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/dialog.dart';
import 'package:travel_hour/utils/styles.dart';
// import 'package:travel_hour/widgets/product_preview.dart';
import 'package:travel_hour/widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateProductOld extends StatefulWidget {
  final Product productData;
  UpdateProductOld({Key? key, required this.productData}) : super(key: key);

  @override
  _UpdateProductOldState createState() => _UpdateProductOldState();
}

class _UpdateProductOldState extends State<UpdateProductOld> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();

  var productNameCtrl = TextEditingController();
  var productDetailCtrl = TextEditingController();
  var sellerContact = TextEditingController();
  var priceCtrl = TextEditingController();

  Uint8List? thumbnail, img1, img2;
  String thumbnailName = "", img1Name = "", img2Name = "";
  String oldThumbnailName = "", oldImg1Name = "", oldImg2Name = "";

  var statusSelection;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  //bool notifyUsers = true;
  bool uploadStarted = false;
  String created_at= "";

  String? _date;
  String? _timestamp;

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _date = _d;
      _timestamp = _t;
    });
  }

  void handleSubmit() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (ab.userType == 'tester') {
        openDialog(context, 'You are a Tester',
            'Only Admin can upload, delete & modify contents');
      } else {
        // setState(() => uploadStarted = true);
        await updateDatabase();
        // setState(() => uploadStarted = false);
        openDialog(context, 'Updated Successfully', '');
      }
    }
  }

  String setImg(String newImgFile, String oldImgFile, Uint8List? fileBytes){
      if(newImgFile.length > 0){
          String waktu = _timestamp.toString();

          // FirebaseStorage.instance.refFromURL(oldImgFile).delete();
          FirebaseStorage.instance
                  .ref()
                  .child("files/$waktu-thumbnail-$newImgFile")
                  .putData(fileBytes!);

          newImgFile = "https://firebasestorage.googleapis.com/v0/b/dev-admin-amazing-ntb.appspot.com/o/files%2F$waktu-thumbnail-$newImgFile?alt=media";
          return newImgFile;
      } else {
        return oldImgFile;
      }
  }

  Future updateDatabase() async {
    final DocumentReference ref = firestore.collection('product').doc(widget.productData.timestamp);

    String thumb = setImg(thumbnailName, oldThumbnailName, thumbnail);
    String im1 = setImg(img1Name, oldImg1Name, img1);
    String im2 = setImg(img2Name, oldImg2Name, img2);

    var _productData = {
      'productName': productNameCtrl.text,
      'productDetail': productDetailCtrl.text,
      'phone': sellerContact.text,
      'price': priceCtrl.text,
      'image-1': thumb,
      'image-2': im1,
      'image-3': im2,
      'status': statusSelection,
      'updated_at': _date,
    };
    await ref.update(_productData);
  }

  clearTextFeilds() {
    productNameCtrl.clear();
    productDetailCtrl.clear();
    sellerContact.clear();
    priceCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  // handlePreview() async {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     await showProductPreview(
  //         context,
  //         productNameCtrl.text,
  //         productDetailCtrl.text,
  //         oldThumbnailName,
  //         sellerContact.text,
  //         statusSelection,
  //         created_at,
  //         priceCtrl.text);
  //   }
  // }

  initBlogData() {
    Product d = widget.productData;
    productNameCtrl.text = d.productName!;
    productDetailCtrl.text = d.productDetail!;
    sellerContact.text = d.phone!;
    priceCtrl.text = d.price!;
    oldThumbnailName = d.image1!;
    oldImg1Name = d.image2!;
    oldImg2Name = d.image3!;
    statusSelection = d.status!;
    created_at = d.created_at!;
  }

  @override
  void initState() {
    super.initState();
    initBlogData();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: Text("Edit your Product"),),
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CoverWidget(
          widget: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.10,
                  ),
                  SizedBox(
                    height: 20,
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
                    decoration: inputDecoration(
                        'Enter Price', 'Price', priceCtrl),
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
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImage(
                        imageUrl: oldThumbnailName, radius: 0.0)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: buttonStyleIMG(Colors.grey[200]),
                    onPressed: () async {
                      FilePickerResult? thumbnailResult = await FilePicker.platform.pickFiles();

                      if (thumbnailResult != null) {
                        if(thumbnailResult.files.first.size > 1200000){
                          openDialog(context, "Image Too Large", "");
                        } else {
                          thumbnail = thumbnailResult.files.first.bytes;
                          thumbnailName = thumbnailResult.files.first.name;
                        }
                      }

                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Upload Thumnail (Image 1)", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImage(
                        imageUrl: oldImg1Name, radius: 0.0)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: buttonStyleIMG(Colors.grey[200]),
                    onPressed: () async {
                      FilePickerResult? thumbnailResult = await FilePicker.platform.pickFiles();

                      if (thumbnailResult != null) {
                        if(thumbnailResult.files.first.size > 1200000){
                          openDialog(context, "Image Too Large", "");
                        } else {
                          img1 = thumbnailResult.files.first.bytes;
                          img1Name = thumbnailResult.files.first.name;
                        }
                      }

                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Upload Image 2", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImage(
                        imageUrl: oldImg2Name, radius: 0.0)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: buttonStyleIMG(Colors.grey[200]),
                    onPressed: () async {
                      FilePickerResult? thumbnailResult = await FilePicker.platform.pickFiles();

                      if (thumbnailResult != null) {
                        if(thumbnailResult.files.first.size > 1200000){
                          openDialog(context, "Image Too Large", "");
                        } else {
                          img2 = thumbnailResult.files.first.bytes;
                          img2Name = thumbnailResult.files.first.name;
                        }
                      }

                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Upload Image 3", style: TextStyle(color: Colors.black)),
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
                        contentPadding: EdgeInsets.only(
                            right: 0, left: 10, top: 15, bottom: 5),
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
                    height: 100,
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
                  //               fontWeight: FontWeight.w400,
                  //               color: Colors.black),
                  //         ),
                  //         onPressed: () {
                  //           handlePreview();
                  //         })
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
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
                                'Update Product',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                handleSubmit();
                              })),
                  SizedBox(
                    height: 200,
                  ),
                ],
              )),
        ));
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
