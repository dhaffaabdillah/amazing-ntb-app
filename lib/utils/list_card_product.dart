import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/product_details.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';

class ListCardProduct extends StatelessWidget {
  final Product? d;
  final String tag;
  final Color? color;
  const ListCardProduct({Key? key, required this.d, required this.tag, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 15, bottom: 0),
            //color: Colors.grey[200],
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15, left: 25, right: 10, bottom: 10),
                    alignment: Alignment.topLeft,
                    height: 120,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 115, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            d!.productName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Feather.map_pin, size: 12, color: Colors.grey,),
                              SizedBox(width: 3,),
                              Expanded(
                                child: Text(
                                  d!.price!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8, bottom: 20),
                            height: 2,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ),
                    ),
                  ),
                
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              left: 5,
              child: Hero(
                tag: tag,
                child: Container(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(imageUrl: d!.image1))),
              ))
        ],
      ),
      onTap: ()=> nextScreen(context, ProductDetail(data: d, tag: tag)),
    );
  }
}


class ListCardProduct1 extends StatelessWidget {
  final Product d;
  final String? tag;
  const ListCardProduct1({Key? key, required this.d, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            //color: Colors.grey[200],
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5, left: 30, right: 10, bottom: 5),
                    alignment: Alignment.topLeft,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 110, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            d.productName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Feather.map_pin, size: 12, color: Colors.grey,),
                              SizedBox(width: 3,),
                              Expanded(
                                child: Text(
                                  d.price!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8, bottom: 20),
                            height: 2,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ),
                    ),
                  ),
                
              ],
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.031,
              left: 10,
              child: Hero(
                tag: tag!,
                child: Container(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(imageUrl: d.image1))),
              ))
        ],
      ),
      onTap: ()=> nextScreen(context, ProductDetail(data: d, tag: tag)),
    );
  }
}