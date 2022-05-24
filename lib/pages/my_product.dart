import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/Product_details.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';

class MyProductPages extends StatefulWidget {
  final String title;
  final Color? color;
  final String? email;
  MyProductPages(
      {Key? key, required this.title, required this.color, required this.email})
      : super(key: key);

  @override
  _MyProductPagesState createState() => _MyProductPagesState();
}

class _MyProductPagesState extends State<MyProductPages> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final sb = context.watch<SignInBloc>();
  // Firebase user = await FirebaseAuth.instance.currentUser();
  //     print(user.uid);
  // final sb = context.watch<SignInBloc>();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final User? user = auth.currentUser;
  final String collectionName = 'product';
  final sb = SignInBloc;
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Product> _data = [];
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
          // .where("email", isEqualTo: currentUser?.email.toString())
          .where("email", isEqualTo: currentUser!.email.toString())
          // .orderBy(_orderBy, descending: _descending)
          .limit(5)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          // .orderBy(_orderBy, descending: _descending)
          // .where("email", isEqualTo: currentUser?.email.toString())
          .where("email", isEqualTo: currentUser!.email.toString())
          // .startAfter([_lastVisible![_orderBy]])
          .limit(5)
          .get();

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Product.fromFirestore(e)).toList();
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
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              backgroundColor: widget.color,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Container(
                  color: widget.color,
                  height: 140,
                  width: double.infinity,
                ),
                title: Text(
                  '${widget.title}',
                  style: TextStyle(color: Colors.white),
                ).tr(),
                // title: Text(sb.email.toString()),
                // title: Text(currentUser!.email.toString()),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 15),
              ),
            ),
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
  final Product d;
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
                        d.productName!,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Feather.phone_call,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Text(
                              d.phone!,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                          ),
                        ],
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
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
      onTap: () => nextScreen(context, ProductDetails(data: d, tag: tag)),
    );
  }
}
