import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/models/reports.dart';
import 'package:travel_hour/pages/Product_details.dart';
import 'package:travel_hour/pages/search.dart';
import 'package:travel_hour/pages/search_product.dart';
import 'package:travel_hour/pages/search_report_page.dart';
import 'package:travel_hour/pages/update_product.dart';
import 'package:travel_hour/pages/update_products.dart';
import 'package:travel_hour/pages/upload_report.dart';
import 'package:travel_hour/utils/currency_format.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';

class MyReport extends StatefulWidget {
  final String title;
  // final Color? color;
  final String? email;
  MyReport(
      {Key? key, required this.title, required this.email})
      : super(key: key);

  @override
  _MyReportState createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String collectionName = 'reports';
  final sb = SignInBloc;
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<ReportModels> _data = [];
  late bool _descending;
  late String _orderBy;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _orderBy = 'timestamp';
    _descending = false;
    _getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
    });
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .where("author", isEqualTo: currentUser!.email.toString())
          // .orderBy(_orderBy, descending: _descending)
          // .limit(5)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          // .orderBy(_orderBy, descending: _descending)
          .where("author", isEqualTo: currentUser!.email.toString())
          // .startAfter([_lastVisible![_orderBy]])
          // .limit(5)
          .get();

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => ReportModels.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
    return null;
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final sb = context.watch<SignInBloc>();
    // print(currentUser?.displayName);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reports"),
        actions: [
          IconButton(onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchReportPage())), 
          icon: Icon(Icons.search)),
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UploadReport())),
          icon: Icon(Icons.add_a_photo)),
        ],
      ),
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _data.length) {
                      return _ListItem(
                        d: _data[index],
                        tag: '${widget.title}$index',
                      );
                    }
                    return Opacity(
                      opacity: _isLoading ? 1.0 : 0.0,
                      child: _lastVisible == null
                          ? Column(
                              children: [
                                LoadingCard(
                                  height: 180,
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            )
                          : Center(
                              child: SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: new CupertinoActivityIndicator()),
                            ),
                    );
                  },
                  childCount: _data.length == 0 ? 5 : _data.length + 1,
                ),
              ),
            )
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final ReportModels d;
  final tag;
  const _ListItem({Key? key, required this.d, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  final sb = context.watch<SignInBloc>();

    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 10),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[200]!,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: tag,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: CustomCacheImage(imageUrl: d.image1)),
                    )),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.report_title!,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.created_at!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                          Spacer(),
                        ],
                      ), 

                      SizedBox(width: 10),
                      InkWell(
                        child: Container(
                            height: 35,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.edit,
                                size: 16, color: Colors.grey[800])),
                        // onTap: () {
                        //   nextScreen(context, UpdateProduct(productData: d));
                        // },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
      // onTap: () => nextScreen(context, ReportDetail(data: d, tag: tag)),
    );
  }
}
