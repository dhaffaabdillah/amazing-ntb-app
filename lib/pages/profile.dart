import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/notification_bloc.dart';
import 'package:travel_hour/blocs/product_bloc.dart';
import 'package:travel_hour/blocs/product_bloc2.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/models/product.dart';
import 'package:travel_hour/pages/edit_profile.dart';
import 'package:travel_hour/pages/more_products.dart';
import 'package:travel_hour/pages/notifications.dart';
import 'package:travel_hour/pages/regist_as_seller.dart';
import 'package:travel_hour/pages/sign_in.dart';
import 'package:travel_hour/pages/my_product.dart';
import 'package:travel_hour/pages/upload_product.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/language.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    final mpb = context.read<ProductBloc2>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationName: Config().appName,
            applicationIcon: Image(
              image: AssetImage(Config().splashIcon),
              height: 30,
              width: 30,
            ),
            applicationVersion: sb.appVersion,
          );
        });
  }

  TextStyle _textStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    final p = context.watch<ProductBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('profile').tr(),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(LineIcons.bell, size: 25),
                onPressed: () => nextScreen(context, NotificationsPage()))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            sb.isSignedIn == false
                ? GuestUserUI()
                : sb.statusSeller == 2 && sb.isSignedIn == true
                    ? UserUI()
                    : sb.statusSeller == 0 && sb.isSignedIn == true
                        ? UserUI()
                        : SellerUI(),

            Text(
              "general setting",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ).tr(),

            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text('get notifications', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.bell, size: 20, color: Colors.white),
              ),
              trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: context.watch<NotificationBloc>().subscribed!,
                  onChanged: (bool) {
                    context.read<NotificationBloc>().fcmSubscribe(bool);
                  }),
            ),
            Divider(
              height: 5,
            ),

            ListTile(
              title: Text('language', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.globe, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(context, LanguagePopup()),
            ),
            Divider(
              height: 5,
            ),

            ListTile(
              title: Text('contact us', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.mail, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => await AppService().openEmailSupport(context),
            ),
            Divider(
              height: 5,
            ),

            ListTile(
              title: Text('rate this app', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.star, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => AppService().launchAppReview(context),
            ),

            Divider(
              height: 5,
            ),

            ListTile(
              title: Text('privacy policy', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.lock, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => AppService()
                  .openLinkWithCustomTab(context, Config().privacyPolicyUrl),
            ),
            Divider(
              height: 5,
            ),

            ListTile(
              title: Text('about us', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.info, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => AppService()
                  .openLinkWithCustomTab(context, Config().yourWebsiteUrl),
            ),

            Divider(
              height: 10,
            ),

            ListTile(
              title: Text('facebook', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.facebook, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () =>
                  AppService().openLink(context, Config().facebookPageUrl),
            ),

            Divider(
              height: 10,
            ),

            ListTile(
              title: Text('youtube', style: _textStyle).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.youtube, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () =>
                  AppService().openLink(context, Config().youtubeChannelUrl),
            ),

            // Divider(height: 10,),

            // ListTile(
            //   title: Text('buy now', style: _textStyle,).tr(),
            //   subtitle: Text('buy now subtitle').tr(),
            //   leading: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //       color: Colors.blueGrey,
            //       borderRadius: BorderRadius.circular(5)
            //     ),
            //     child: Icon(Feather.shopping_cart, size: 20, color: Colors.white),
            //   ),
            //   trailing: Icon(Feather.chevron_right, size: 20,),
            //   onTap: ()async{
            //     String _url = 'https://codecanyon.net/item/flutter-travel-app-ui-kit-template-travel-hour/24958845';
            //     AppService().openLinkWithCustomTab(context, _url);
            //   },
            // ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);

    return Column(
      children: [
        ListTile(
          title: Text(
            'login',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.user, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => nextScreenPopup(
              context,
              SignInPage(
                tag: 'popup',
              )),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class SellerUI extends StatelessWidget {
  // final Product p;
  const SellerUI({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    // final p = context.watch<ProductBloc>();
    TextStyle _textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
              SizedBox(
                height: 10,
              ),
              Text(
                sb.name!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                    wordSpacing: 2),
              )
            ],
          ),
        ),
        ListTile(
          title: Text(
            sb.email!,
            style: _textStyle,
          ),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.mail, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            sb.joiningDate!,
            style: _textStyle,
          ),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(5)),
            child: Icon(LineIcons.timesCircle, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'my products',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.inbox, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          // onTap: () => nextScreen(context, MyProduct(data: p.authorId,)),
          onTap: () => nextScreen(
              context,
              MyProductPages(
                  title: 'my products', email: sb.email, color: Colors.amber)),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'add a product',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.inbox, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          // onTap: () => nextScreen(context, MyProduct(data: p.authorId,)),
          // onTap: () => nextScreen(
          //     context,
          //     UploadProduct()),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'regist as seller',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.inbox, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => openRegistSellerDialog(context),
          // onTap: () => nextScreen(
          //     context,
          //     UploadProduct()),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
            title: Text(
              'edit profile',
              style: _textStyle,
            ).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.edit_3, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              Feather.chevron_right,
              size: 20,
            ),
            onTap: () => nextScreen(
                context, EditProfile(name: sb.name, imageUrl: sb.imageUrl))),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'logout',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.log_out, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => openLogoutDialog(context),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('logout title').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context
                      .read<SignInBloc>()
                      .userSignout()
                      .then((value) =>
                          context.read<SignInBloc>().afterUserSignOut())
                      .then((value) =>
                          nextScreenCloseOthers(context, SignInPage()));
                },
              )
            ],
          );
        });
  }
  void openRegistSellerDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('regist as seller').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context
                      .read<SignInBloc>()
                      .userSignout()
                      .then((value) =>
                          context.read<SignInBloc>().afterUserSignOut())
                      .then((value) =>
                          nextScreenCloseOthers(context, SignInPage()));
                },
              )
            ],
          );
        });
  }
}

class UserUI extends StatelessWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final p = context.watch<ProductBloc>();
    TextStyle _textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
              SizedBox(
                height: 10,
              ),
              Text(
                sb.name!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                    wordSpacing: 2),
              )
            ],
          ),
        ),
        ListTile(
          title: Text(
            sb.email!,
            style: _textStyle,
          ),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.mail, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            sb.joiningDate!,
            style: _textStyle,
          ),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(5)),
            child: Icon(LineIcons.timesCircle, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
            title: Text(
              'regist as seller',
              style: _textStyle,
            ).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.inbox, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              Feather.chevron_right,
              size: 20,
            ),
            onTap: () => nextScreen(
                context,
                RegistAsSeller(
                  statusSeller: sb.statusSeller,
                ))),
        Divider(
          height: 5,
        ),
        ListTile(
            title: Text(
              'edit profile',
              style: _textStyle,
            ).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.edit_3, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              Feather.chevron_right,
              size: 20,
            ),
            onTap: () => nextScreen(
                context, EditProfile(name: sb.name, imageUrl: sb.imageUrl))),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'logout',
            style: _textStyle,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.log_out, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => openLogoutDialog(context),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('logout title').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context
                      .read<SignInBloc>()
                      .userSignout()
                      .then((value) =>
                          context.read<SignInBloc>().afterUserSignOut())
                      .then((value) =>
                          nextScreenCloseOthers(context, SignInPage()));
                },
              )
            ],
          );
        });
  }
}
