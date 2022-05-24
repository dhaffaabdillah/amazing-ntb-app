import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? productName;
  String? productDetail;
  String? authorId;
  String? price;
  // String? sellerContact;
  String? image1;
  String? image2;
  String? image3;
  // String? image4;
  String? status;
  // String? date;
  String? timestamp;
  String? created_at;
  String? updated_at;
  String? phone;
  
  Product({
    this.productName,
    this.productDetail,
    this.authorId,
    this.price,
    // this.sellerContact,
    this.image1,
    this.image2,
    this.image3,
    // this.image4,
    this.status,
    // this.date,
    this.phone,
    this.timestamp,
    this.created_at,
    this.updated_at,
  });

  factory Product.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;
    return Product(
      productName: data['productName'],
      productDetail: data['productDetail'],
      authorId: data['authorId'],
      price: data['price'],
      phone: data['phone'],
      image1: data['image-1'],
      image2: data['image-2'],
      image3: data['image-3'],
      // image4: data['image4'],
      status: data['status'],
      created_at: data['created_at'],
      updated_at: data['updated_at'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson () {
    return{
      'productName': productName,
      'productDetail': productDetail,
      'price': price,
      'authorId' : authorId,
      'phone': phone,
      'image-1': image1,
      'image-2': image2,
      'image-3': image3,
      // 'image4': image4,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'timestamp': timestamp,
    };
  }
}