// import 'dart:html';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/blocs/admin_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/constants/constants.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/dialog.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:travel_hour/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key, required this.productData}) : super(key: key);
  final Product productData;
  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool loading = false;
  String? productName;
  String? productDetail;
  String? phone;
  String? email;
  String? status;
  String? imageUrl1;
  String? imageUrl2 = Constants.defaultPath;
  String? imageUrl3 = Constants.defaultPath;

  // String? imageName1;
  // String? imageName2;
  // String? imageName3;

  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  Uint8List? thumbnail, img1, img2;

  var statusSelection;
  var usersSelection = TextEditingController();
  bool notifyUsers = true;
  bool uploadStarted = false;
  String? _timestamp;
  String? _date;
  var _productData;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var productNameCtrl = TextEditingController();
  var productDetailCtrl = TextEditingController();
  var productPrice = TextEditingController();
  var phoneCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var statusCtrl = TextEditingController();

  Future handlePost() async {
    Product p = widget.productData;
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      } else if (hasInternet == true && statusSelection == null) {
        openSnacbar(scaffoldKey, "Please select status first!");
      } else if (hasInternet == true && productNameCtrl == null) {
        openSnacbar(scaffoldKey, "Please fill product name");
      } else if (hasInternet == true && phoneCtrl == null) {
        openSnacbar(scaffoldKey, "Please fill your contact number");
      } else if (hasInternet == true && productDetailCtrl == null) {
        openSnacbar(scaffoldKey, "Please fill your product detail");
      } else {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() => loading = true);
          if (imageFile1 != p.image1 ||
              imageFile2 != p.image2 ||
              imageFile3 != p.image3) {
            await getDate().then((_) async {
              await uploadImage()
                  .then((value) => uploadImage2())
                  .then((value) => uploadImage3())
                  .then((value) => saveToDatabase());
              // setState(() => uploadStarted = false);
              openSnacbar(scaffoldKey, 'Update Successfully');
              clearTextFeilds();
            });
          } else {
            await saveToDatabase();
          }
        }
      }
    });
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagePicked1 =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    var imagePicked2 =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    var imagePicked3 =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imagePicked1 != null) {
      setState(() {
        imageFile1 = File(imagePicked1.path);
        imageFile2 = File(imagePicked2!.path);
        imageFile3 = File(imagePicked3!.path);

        imageUrl1 = (imageFile1!.path);
        imageUrl2 = (imageFile2!.path);
        imageUrl3 = (imageFile3!.path);
      });
    } else {
      openSnacbar(scaffoldKey, 'You must upload 1 image of your product!');
    }
  }

  Future pickImage1() async {
    final _imagePicker1 = ImagePicker();
    var imagePicked1 =
        await _imagePicker1.pickImage(source: ImageSource.gallery);
    if (imagePicked1 != null) {
      setState(() {
        imageFile1 = File(imagePicked1.path);
        imageUrl1 = (imageFile1!.path);
      });
    } else {
      openSnacbar(scaffoldKey, 'You must upload 1 image of your product!');
    }
  }

  Future pickImage2() async {
    final _imagePicker2 = ImagePicker();
    var imagePicked2 =
        await _imagePicker2.pickImage(source: ImageSource.gallery);
    if (imagePicked2 != null) {
      setState(() {
        imageFile2 = File(imagePicked2.path);
        imageUrl2 = (imageFile2!.path);
      });
    } else {
      imageFile2 = null;
      imageUrl2 = Constants.defaultPath;
    }
  }

  Future pickImage3() async {
    final _imagePicker3 = ImagePicker();
    var imagePicked3 =
        await _imagePicker3.pickImage(source: ImageSource.gallery);
    if (imagePicked3 != null) {
      setState(() {
        imageFile3 = File(imagePicked3.path);
        imageUrl3 = (imageFile3!.path);
      });
    } else {
      imageFile3 = null;
      imageUrl3 = Constants.defaultPath;
    }
  }

  clearTextFeilds() {
    productNameCtrl.clear();
    productDetailCtrl.clear();
    phoneCtrl.clear();
    priceCtrl.clear();
  }

  initBlogData() {
    Product d = widget.productData;
    productNameCtrl.text = d.productName!;
    productDetailCtrl.text = d.productDetail!;
    phoneCtrl.text = d.phone!;
    priceCtrl.text = d.price!;
    imageUrl1 = d.image1!;
    imageUrl2 = d.image2!;
    imageUrl3 = d.image3!;
    statusSelection = d.status!;
    // created_at = d.created_at!;
  }

  @override
  void initState() {
    super.initState();
    initBlogData();
  }

  Future uploadImage() async {
    // final SignInBloc sb = context.read<SignInBloc>();
    String time = _timestamp.toString();
    Reference storageRef1 =
        FirebaseStorage.instance.ref().child("files/${_timestamp}-thumbnail");

    if(imageFile1 != null){
      UploadTask uploadTask1 = storageRef1.putFile(imageFile1!);

      await uploadTask1.whenComplete(() async {
        var _url1 = await storageRef1.getDownloadURL();
        var _imageUrl1 = _url1.toString();
        if (_imageUrl1.length > 0) {
          setState(() {
            imageUrl1 = _imageUrl1;
          });
        } else {
          imageUrl1 = Constants.defaultPath;
        }
      });
    } 

  }

  Future uploadImage2() async {
    // final SignInBloc sb = context.read<SignInBloc>();
    String time = _timestamp.toString();
    Reference storageRef2 =
        FirebaseStorage.instance.ref().child("files/${_timestamp}-img1");

    if(imageFile2 != null){
      UploadTask uploadTask2 = storageRef2.putFile(imageFile2!);

      await uploadTask2.whenComplete(() async {
        var _url2 = await storageRef2.getDownloadURL();
        var _imageUrl2 = _url2.toString();
        if (_imageUrl2.length > 0) {
          setState(() {
            imageUrl2 = _imageUrl2;
          });
        } else {
          imageUrl2 = Constants.defaultPath;
        }
      });
    } 
  }

  Future uploadImage3() async {
    // final SignInBloc sb = context.read<SignInBloc>();
    String time = _timestamp.toString();
    Reference storageRef3 =
        FirebaseStorage.instance.ref().child("files/${_timestamp}-img2");

    if(imageFile3 != null){
      UploadTask uploadTask3 = storageRef3.putFile(imageFile3!);

      await uploadTask3.whenComplete(() async {
        var _url = await storageRef3.getDownloadURL();
        var _imageUrl3 = _url.toString();
        if (_imageUrl3.length > 0) {
          setState(() {
            imageUrl3 = _imageUrl3;
          });
        } else {
          imageUrl3 = Constants.defaultPath;
        }
      });
    } 

  }

  Future insertData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('product').doc(widget.productData.timestamp);

    sp.setString('productName', productNameCtrl.text);
    sp.setString('productDetail', productDetailCtrl.text);
    sp.setString('phone', phoneCtrl.text);
    sp.setString('email', currentUser!.email!);
    sp.setString('image-1', imageUrl1!);
    sp.setString('image-2', imageUrl2!);
    sp.setString('image-3', imageUrl3!);
    sp.setString('image-3', imageUrl3!);
    sp.setString('status', statusSelection!);
    sp.setString('image-3', imageUrl3!);
    sp.setString('image-3', imageUrl3!);

    // notifyListeners();
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection('product').doc(widget.productData.timestamp);
    String time = _timestamp.toString();
    
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
      'updated_at': _date,
    };

    await ref.update(_productData);
  }

  Future insertData1() async {
    final DocumentReference ref = firestore.collection('product').doc(_timestamp);
    String time = _timestamp.toString();
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection('users').doc(_timestamp);
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
    // notifyListeners();
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

  @override
  Widget build(BuildContext context) {
    Product p = widget.productData;
    double h = MediaQuery.of(context).size.height;
    getDate();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Update a Product")),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),

                Text(
                  'Edit your Product here',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ).tr(),

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
                  decoration:
                      inputDecoration('Enter Phone Number', 'Phone', phoneCtrl),
                  controller: phoneCtrl,
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
                  decoration:
                      inputDecoration('Enter Price', 'Price', priceCtrl),
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

                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter Product Description',
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
                  height: 20,
                ),

                Text(
                  "Pick your image products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),

                SizedBox(
                  height: 20,
                ),

                InkWell(
                  // child: CircleAvatar(
                  //   radius: 70,
                  //   backgroundColor: Colors.grey[300],
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Color.fromARGB(255, 239, 198, 198)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: (imageFile1 == null
                                    ? CachedNetworkImageProvider(imageUrl1!)
                                    : FileImage(imageFile1!))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover)),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                  // ),
                  onTap: () {
                    pickImage1();
                  },
                ),
                
                SizedBox(
                  height: 20,
                ),

                InkWell(
                  // child: CircleAvatar(
                  //   radius: 70,
                  //   backgroundColor: Colors.grey[300],

                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Color.fromARGB(255, 239, 198, 198)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: (imageFile2 == null
                                    ? CachedNetworkImageProvider(imageUrl2!)
                                    : FileImage(imageFile2!))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover)),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                  // ),
                  onTap: () {
                    pickImage2();
                  },
                ),
                
                SizedBox(
                  height: 20,
                ),

                InkWell(
                  // child: CircleAvatar(
                  //   radius: 20,
                  //   backgroundColor: Colors.grey[300],
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Color.fromARGB(255, 239, 198, 198)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: (imageFile3 == null
                                    ? CachedNetworkImageProvider(imageUrl3!)
                                    : FileImage(imageFile3!))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover)),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                  // ),
                  onTap: () {
                    pickImage3();
                  },
                ),

                SizedBox(
                  height: 20,
                ),

                // SizedBox(
                //   height: 100,
                // ),
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
                    child: loading == true
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
                              handlePost();
                            })),
                SizedBox(
                  height: 50,
                ),
              ],
            )
          ),
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
