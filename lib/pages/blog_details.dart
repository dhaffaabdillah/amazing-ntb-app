import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:travel_hour/blocs/ads_bloc.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/models/blog.dart';
import 'package:travel_hour/pages/comments.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/utils/sign_in_dialog.dart';
import 'package:travel_hour/widgets/bookmark_icon.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/widgets/html_body.dart';
import 'package:travel_hour/widgets/love_count.dart';
import 'package:travel_hour/widgets/love_icon.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BlogDetails extends StatefulWidget {
  final Blog? blogData;
  final String tag;

  BlogDetails({Key? key, required this.blogData, required this.tag})
      : super(key: key);

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {

  
  final String collectionName = 'blogs';

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onLoveIconClick(collectionName, widget.blogData!.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onBookmarkIconClick(collectionName, widget.blogData!.timestamp);
    }
  }

  handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid = '${widget.blogData!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS = '${widget.blogData!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    if (Platform.isAndroid) {
      Share.share(_shareTextAndroid);
    } else{
      Share.share(_shareTextiOS);
    }
  }
  

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.watch<SignInBloc>();
    final Blog d = widget.blogData!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                    children: [
                      Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Spacer(),
                        Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.share,
                                size: 22,
                              ),
                              onPressed: () {
                                handleShare();
                              },
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.time,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              d.date!,
                              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          d.title!,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey[800],
                              letterSpacing: -0.7,
                              wordSpacing: 1),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          height: 3,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.grey[200]),
                                padding: MaterialStateProperty.resolveWith(
                                    (states) => EdgeInsets.all(10)),
                              ),
                              onPressed: () => AppService()
                                  .openLinkWithCustomTab(context, d.sourceUrl!),
                              icon: Icon(Feather.external_link,
                                  size: 20, color: Theme.of(context).primaryColor),
                              label: _getSourceName(d),
                            ),
                            Spacer(),
                            IconButton(
                                icon: BuildLoveIcon(
                                    collectionName: collectionName,
                                    uid: sb.uid,
                                    timestamp: d.timestamp),
                                onPressed: () {
                                  handleLoveClick();
                                }),
                            IconButton(
                                icon: BuildBookmarkIcon(
                                    collectionName: collectionName,
                                    uid: sb.uid,
                                    timestamp: d.timestamp),
                                onPressed: () {
                                  handleBookmarkClick();
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Hero(
                  tag: widget.tag,
                  child: Container(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: CustomCacheImage(imageUrl: d.thumbnailImagelUrl))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      LoveCount(
                          collectionName: collectionName, timestamp: d.timestamp),
                      SizedBox(
                        width: 15,
                      ),
                      TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) => Theme.of(context).primaryColor)),
                          onPressed: () {
                            nextScreen(
                                context,
                                CommentsPage(
                                    collectionName: collectionName,
                                    timestamp: d.timestamp));
                          },
                          icon: Icon(
                            Feather.message_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            'comments',
                            style: TextStyle(color: Colors.white),
                          ).tr())
                    ],
                  ),
                ),
                HtmlBodyWidget(
                  content: d.description!,
                  isIframeVideoEnabled: true,
                  isVideoEnabled: true,
                  isimageEnabled: true,
                  fontSize: 17,
                ),
                SizedBox(
                  height: 30,
                )
              ]),
          ),
      ),
    );
  }

  Text _getSourceName(Blog d) {
    return Text(
      d.sourceUrl!.contains('www')
          ? d.sourceUrl!.replaceAll('https://www.', '').split('.').first
          : d.sourceUrl!.replaceAll('https://', '').split('.').first,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.grey[900], fontSize: 13, fontWeight: FontWeight.w500),
    );
  }
}
