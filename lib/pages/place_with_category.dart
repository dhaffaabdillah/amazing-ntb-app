import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/models/place.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';

class PlaceWithCategory extends StatefulWidget {
  final String title;
  final Color? color;
  final String category;
  PlaceWithCategory(
      {Key? key,
      required this.title,
      required this.color,
      required this.category})
      : super(key: key);

  @override
  _PlaceWithCategoryState createState() => _PlaceWithCategoryState();
}

class _PlaceWithCategoryState extends State<PlaceWithCategory> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'places';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Place> _data = [];
  late bool _descending;
  late String _orderBy;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    if (widget.title == 'popular') {
      _orderBy = 'loves';
      _descending = true;
    } else if (widget.title == 'recommended') {
      _orderBy = 'comments count';
      _descending = true;
    } else {
      _orderBy = 'timestamp';
      _descending = false;
    }
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
          // .orderBy(_orderBy, descending: _descending)
          .where('category', isEqualTo: '${widget.category}')
          .limit(5)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          // .orderBy(_orderBy, descending: _descending)
          .where('category', isEqualTo: '${widget.category}')
          .startAfter([_lastVisible![_orderBy]])
          .limit(5)
          .get();

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Place.fromFirestore(e)).toList();
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
                  '${widget.title} places',
                  style: TextStyle(color: Colors.white),
                ).tr(),
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
  final Place d;
  final tag;
  const _ListItem({Key? key, required this.d, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          child: CustomCacheImage(imageUrl: d.imageUrl1)),
                    )),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.name!,
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
                            Feather.map_pin,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Text(
                              d.location!,
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
                            d.date!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                          Spacer(),
                          Icon(
                            LineIcons.heart,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.loves.toString(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            LineIcons.comment,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.commentsCount.toString(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
      onTap: () => nextScreen(context, PlaceDetails(data: d, tag: tag)),
    );
  }
}
