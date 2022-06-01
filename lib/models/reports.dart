import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModels {
  String? report_id;
  String? author_id;
  String? institution;
  String? report_title;
  String? report_desc;
  String? image1;
  String? image2;
  String? image3;
  String? status;
  String? created_at;
  String? updated_at;
  String? timestamp;
  
  ReportModels({
    this.report_id,
    this.author_id,
    this.institution,
    this.report_title,
    this.report_desc,
    this.image1,
    this.image2,
    this.image3,
    this.status,
    this.created_at,
    this.updated_at,
    this.timestamp,
  });

  factory ReportModels.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;
    return ReportModels(
      report_id: data['report_id'],
      author_id: data['author_id'],
      institution: data['institution'],
      report_title: data['report_title'],
      report_desc: data['report_desc'],
      image1: data['image-1'],
      image2: data['image-2'],
      image3: data['image-3'],
      status: data['status'],
      created_at: data['created_at'],
      updated_at: data['updated_at'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_id': report_id,
      'author_id': author_id,
      'institution': institution,
      'report_title': report_title,
      'report_desc': report_desc,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'timestamp': timestamp,
    };
  }
}