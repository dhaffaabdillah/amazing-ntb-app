import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/blocs/popular_places_bloc.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/models/place.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/more_products.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/pages/product_details.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';



class Products extends StatelessWidget {
  Products({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final pb = context.watch<ProductBloc>();
    
    

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 10),
          child: Row(children: <Widget>[
            Text('products', style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.grey[900],
              wordSpacing: 1,
              letterSpacing: -0.6
              ),
            ).tr(),
            Spacer(),
            IconButton(icon: Icon(Icons.arrow_forward),
              onPressed: () => nextScreen(context, MoreProductPages(title: 'products', color: Colors.grey[800],)),            
            )
          ],),
        ),
        

        Container(
          height: 245,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: pb.data.isEmpty ? 3 : pb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if(pb.data.isEmpty) return LoadingPopularPlacesCard();
              return _ItemList(d: pb.data[index],);
           },
          ),
        )
        
        
      ],
    );
  }
}


class _ItemList extends StatelessWidget {
  final Product d;
  const _ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
          child: Container(
                margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                  
                ),
                child: Stack(
                   children: [
                     Hero(
                       tag: 'product${d.timestamp}',
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomCacheImage(imageUrl: d.image1)
                       ),
                     ),

                    Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey[900]!.withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)
                            )
                                ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              d.productName!,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child:  Icon(Feather.phone_call,
                                    size: 15, color: Colors.grey[400],)
                                ),
                                Expanded(
                                  child: Text(
                                    d.phone!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                    ),
                  )],
                ),
                
              ),

              onTap: () => nextScreen(context, ProductDetail(data: d, tag: 'product${d.timestamp}')),
    );
  }
}


