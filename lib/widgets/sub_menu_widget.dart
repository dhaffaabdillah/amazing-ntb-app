import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/models/place.dart';
import 'package:travel_hour/pages/categories_page.dart';
import 'package:travel_hour/pages/comments.dart';
import 'package:travel_hour/pages/food_page.dart';
import 'package:travel_hour/pages/guide.dart';
import 'package:travel_hour/pages/hotel.dart';
import 'package:travel_hour/pages/hotel_page.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/place_with_category.dart';
import 'package:travel_hour/pages/restaurant.dart';
import 'package:travel_hour/pages/search_product.dart';
import 'package:travel_hour/pages/states.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:travel_hour/widgets/popular_places.dart';

class SubmenuWidget extends StatelessWidget {
  // final Place? placeData;
  const SubmenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            // shape: BoxShape.rectangle
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[400]!,
                                offset: Offset(3, 3),
                                blurRadius: 0.6)
                          ]),
                      child: IconButton(icon: Icon(LineIcons.hotel,), tooltip: "Hotel" , color: Color.fromARGB(255, 132, 159, 234) ,iconSize: 40,
                      onPressed: () =>  nextScreen(context, PlaceWithCategory(title: 'Hotel', color: Color.fromARGB(255, 163, 174, 243), category: 'hotel',))
                      ),
                    ),

                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[400]!,
                                offset: Offset(3, 3),
                                blurRadius: 0.6)
                          ]),
                      child: IconButton(icon: Icon(Icons.fastfood_outlined), tooltip: "Food" , color: Color.fromARGB(255, 132, 159, 234) ,iconSize: 40,
                      onPressed: () =>  nextScreen(context, PlaceWithCategory(title: 'Food', color: Color.fromARGB(255, 163, 174, 243), category: 'food',))
                      ),
                    ),

                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[400]!,
                                offset: Offset(2, 3),
                                blurRadius: 0.2)
                          ]),
                      child:
                      IconButton(
                        icon: Icon(LineIcons.umbrellaBeach), tooltip: "Beach" , color: Color.fromARGB(255, 132, 159, 234) ,iconSize: 40,
                        onPressed: () =>  nextScreen(context, PlaceWithCategory(title: 'Beach', color: Color.fromARGB(255, 163, 174, 243), category: 'beach',))
                      ),
                      
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[400]!,
                                offset: Offset(2, 3),
                                blurRadius: 0.2)
                          ]),
                      child:
                      IconButton(icon: Icon(Icons.move_down_rounded), tooltip: "Category" , color: Color.fromARGB(255, 132, 159, 234) ,iconSize: 40,onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoriesPage()))),

                    ),
                  ]
            ),
          
        )
      ],
    );
  }
}
