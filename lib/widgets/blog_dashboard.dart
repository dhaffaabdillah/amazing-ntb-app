import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:travel_hour/blocs/dashboard_blog_bloc.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/models/blog.dart';
import 'package:travel_hour/models/place.dart';
import 'package:travel_hour/pages/blog_details.dart';
import 'package:travel_hour/pages/blogs.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:easy_localization/easy_localization.dart';

class BlogDashboards extends StatelessWidget {
  BlogDashboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardBlogBloc pb = Provider.of<DashboardBlogBloc>(context);

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 30,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'list blogs',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800], 
                    wordSpacing: 1, 
                    letterSpacing: -0.6
                  ),
              ).tr(),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: pb.data.isEmpty ? 3 : pb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if(pb.data.isEmpty) return LoadingPopularPlacesCard();
              return _BlogList(data: pb.data[index],);
           },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30, left: 15, right: 15, top: 10),
          height: 35,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
              textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
                color: Colors.white
              ))
            ),
            child: Text('show more blogs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)).tr(),
            onPressed: (){
              nextScreen(context, BlogPage());
            },

            
          ),
        ),
      ],
    );
  }
}





class _BlogList extends StatelessWidget {
  final Blog? data;
  const _BlogList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
          width: MediaQuery.of(context).size.width * 0.50,
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
              tag: 'blog${data!.timestamp}',
                child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomCacheImage(imageUrl: data!.thumbnailImagelUrl)),
              ),
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    data!.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 5,),
                    Text(
                          HtmlUnescape().convert(parse(data!.description).documentElement!.text),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[700]
                      )
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.time, size: 16, color: Colors.grey,),
                        SizedBox(width: 3,),
                        Text(data!.date!, style: TextStyle(
                          fontSize: 12, color: Colors.grey
                        ),),
                        Spacer(),
                        Icon(Icons.favorite, size: 16, color: Colors.grey,),
                        SizedBox(width: 3,),
                        Text(data!.loves.toString(), style: TextStyle(
                          fontSize: 12, color: Colors.grey
                        ),)
                      ],
                    )
                    
                    
                  ],
                ),
              ),
          
          ],
        ),
      ),

      onTap: () => nextScreen(context, BlogDetails(blogData: data, tag: 'blog${data!.timestamp}'))
    );
  }
}
