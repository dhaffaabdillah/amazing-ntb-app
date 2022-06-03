import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/pages/home.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: h,
            child: Carousel(
              dotVerticalPadding: h * 0.45,
              dotColor: Colors.grey,
              dotIncreasedColor: Colors.blueAccent,
              autoplay: false,
              dotBgColor: Colors.transparent,
              dotSize: 6,
              dotSpacing: 15,
              images: [
                IntroView(smallIntro: 'small-intro', BigIntro: 'big-intro', boldIntro: 'intro-bold1', description: 'intro-description1', image: Config().splashIcon, bgImage: Config().introImage1), 
                IntroView(smallIntro: 'small-intro', BigIntro: 'big-intro', boldIntro: 'intro-bold2', description: 'intro-description2', image: Config().splashIcon, bgImage: Config().introImage2),
                IntroView(smallIntro: 'small-intro', BigIntro: 'big-intro', boldIntro: 'intro-bold3', description: 'intro-description3', image: Config().splashIcon, bgImage: Config().introImage2),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
          width: w * 0.30,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
            ),
            child: IconButton(
              iconSize: 40,
              color: Colors.black,
              icon: Icon(Icons.arrow_right_alt_rounded),
              onPressed: () {
                nextScreenReplace(context, HomePage());
              },
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
}


class IntroView extends StatelessWidget {
  final String smallIntro, BigIntro, boldIntro;
  final String description;
  final String image, bgImage;
  const IntroView({Key? key, required this.smallIntro, required this.BigIntro, required this.boldIntro, required this.description, required this.image, required this.bgImage}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            child: Image(
              image: AssetImage(image),
              fit: BoxFit.contain,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
       
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  smallIntro,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black,
                    letterSpacing: - 0.7,
                    wordSpacing: 1
                  ),
                ).tr(),

                Text(
                  BigIntro,
                  style: TextStyle(
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black,
                    letterSpacing: - 0.7,
                    wordSpacing: 1
                  ),
                ).tr()
              ]
            ),
          ),
  
          SizedBox(
            height: 50,
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                   TextSpan(
                      text: description.tr(),
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]),
                    ),
                    TextSpan(
                      text: boldIntro.tr(), style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 132, 159, 234)
                      )
                    )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
