// import 'package:admin/blocs/admin_bloc.dart';
// import 'package:admin/models/blog.dart';
// import 'package:admin/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/utils/dialog.dart';
// import 'package:travel_hour/utils/styles.dart';
// import 'package:travel_hour/widgets/product_preview.dart';
// import 'package:travel_hour/widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/utils/styles.dart';
import 'package:travel_hour/widgets/cover_widget.dart';

class UpdateProduct extends StatefulWidget {
  final Product productData;
  UpdateProduct({Key? key, required this.productData}) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  var formKey = GlobalKey<FormState>();

  var productNameCtrl = TextEditingController();
  var productDetailCtrl = TextEditingController();
  var sellerContact = TextEditingController();
  var priceCtrl = TextEditingController();
  var image1Ctrl = TextEditingController();
  var image2Ctrl = TextEditingController();
  var image3Ctrl = TextEditingController();

  var statusSelection;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  //bool notifyUsers = true;
  bool uploadStarted = false;
  String created_at= "";

  String? _date;

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    setState(() {
      _date = _d;
    });
  }

  void handleSubmit() async {
    // final SignInBloc sb = context.watch<SignInBloc>();
    setState(() => uploadStarted = true);
    await updateDatabase();
    setState(() => uploadStarted = false);
    openDialog(context, 'Updated Successfully', '');
    
  }

  Future updateDatabase() async {
    final DocumentReference ref =
        firestore.collection('product').doc(widget.productData.timestamp);
    var _productData = {
      'productName': productNameCtrl.text,
      'productDetail': productDetailCtrl.text,
      'phone': sellerContact.text,
      'price': priceCtrl.text,
      'image-1': image1Ctrl.text,
      'image-2': image2Ctrl.text,
      'image-3': image3Ctrl.text,
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
    image1Ctrl.clear();
    image2Ctrl.clear();
    image3Ctrl.clear();
    FocusScope.of(context).unfocus();
  }

  // handlePreview() async {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     await showProductPreview(
  //         context,
  //         productNameCtrl.text,
  //         productDetailCtrl.text,
  //         image1Ctrl.text,
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
    priceCtrl.text = d.price!.toString();
    image1Ctrl.text = d.image1!;
    image2Ctrl.text = d.image2!;
    image3Ctrl.text = d.image3!;
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
        appBar: AppBar(),
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
                  Text(
                    'Update Product Details',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
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
                  TextFormField(
                    decoration: inputDecoration('Enter image url (thumbnail)',
                        'Image1(Thumbnail)', image1Ctrl),
                    controller: image1Ctrl,
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
                        'Enter image url', 'Image2', image2Ctrl),
                    controller: image2Ctrl,
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
                        'Enter image url', 'Image3', image3Ctrl),
                    controller: image3Ctrl,
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
