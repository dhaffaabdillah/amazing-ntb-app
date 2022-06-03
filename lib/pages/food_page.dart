import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
// import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/blocs/product_bloc2.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/product_details.dart';
import 'package:travel_hour/utils/empty.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';


class FoodPage extends StatefulWidget {
  FoodPage({Key? key}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with AutomaticKeepAliveClientMixin {


  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'loves';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    // .then((value){
    //   controller = new ScrollController()..addListener(_scrollListener);
    //   context.read<ProductBloc2>().getData(mounted, _orderBy);
    // })
    ;

  }


  @override
  void dispose() {
    // controller!.removeListener(_scrollListener);
    super.dispose();
  }




  // void _scrollListener() {
  //   final db = context.read<ProductBloc2>();
    
  //   if (!db.isLoading) {
  //     if (controller!.position.pixels == controller!.position.maxScrollExtent) {
  //       context.read<ProductBloc2>().setLoading(true);
  //       context.read<ProductBloc2>().getData(mounted, _orderBy);

  //     }
  //   }
  // }

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bb = context.watch<ProductBloc2>();

    return Scaffold(
        appBar: AppBar(
          // centerTitle: false,
          // automaticallyImplyLeading: false,
          title: Text(
            'Foods'
          ).tr(),
          
        ),

    body: ListView.separated(
          padding: EdgeInsets.all(15),
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
          itemBuilder: (_, int index) {

            if (index <= 1) {
              return _ItemList();
            }
            return Opacity(
                opacity: 0.0,
                child: Center(
                  child: SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: new CupertinoActivityIndicator()),
                ),
              
            );
          },
        
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


class _ItemList extends StatelessWidget {
  // var Product d;
  const _ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow> [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10,
              offset: Offset(0, 3)
            )
          ]
        ),
        child: Wrap(
          children: [
            Hero(
              tag: 'food{_timestamp}',
                child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CustomCacheImage(imageUrl:  "https://cdn0-production-images-kly.akamaized.net/xU3rQw2wph5bD_WgcQ-81z-1bPk=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/1062309/original/052878100_1448077393-nasbal1.jpg")),
              ),
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "Nasi Balap Puyung",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 5,),
                    Text(
                          "Nasi balapn puyung gk bisa balapan",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[700]
                      )
                    ),
                    SizedBox(height: 10,),
                    
                  ],
                ),
              ),
          
          ],
        ),
      ),

      // onTap: () => nextScreen(context, ProductDetail(data: d, tag: 'product${d.timestamp}')),
    );
  }
}



