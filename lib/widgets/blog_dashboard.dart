import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/dashboard_blog_bloc.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/models/blog.dart';
import 'package:travel_hour/models/place.dart';
import 'package:travel_hour/pages/blog_details.dart';
import 'package:travel_hour/pages/blogs.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/custom_cache_image.dart';
import 'package:easy_localization/easy_localization.dart';

class BlogDashboards extends StatelessWidget {
  BlogDashboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardBlogBloc rpb = Provider.of<DashboardBlogBloc>(context);

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
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 10, bottom: 30, left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemBuilder: (BuildContext context, int index) {
              if (rpb.data.isEmpty) return Container();
              return _BlogList(data: rpb.data[index]);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
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
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(3)
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Hero(
                  tag: 'bookmark${data!.timestamp}',
                  child: Container(
                    width: 140,
                    child: CustomCacheImage(imageUrl: data!.thumbnailImagelUrl),
                  )),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 15, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data!.title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.time,
                                size: 16, color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text(data!.date!,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite, size: 16, color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text(data!.loves.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        nextScreen(context, BlogDetails(blogData: data, tag: 'blogs${data!.timestamp}'));
      },
    );
  }
}
