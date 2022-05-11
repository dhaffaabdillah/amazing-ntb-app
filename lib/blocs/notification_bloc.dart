import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/models/notification.dart';
import 'package:travel_hour/pages/notifications.dart';
import 'package:travel_hour/utils/next_screen.dart';




class NotificationBloc extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool? _hasData;
  bool? get hasData => _hasData;

  List<DocumentSnapshot> _snap = [];

  List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  bool? _subscribed;
  bool? get subscribed => _subscribed;

  final String subscriptionTopic = 'all';




  Future<Null> getData(mounted) async {
    _hasData = true;
    QuerySnapshot rawData;
    if (_lastVisible == null)
      rawData = await firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      rawData = await firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible!['timestamp']])
          .limit(10)
          .get();

    if (rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
      }
    } else {
      if(_lastVisible == null){

        _isLoading = false;
        _hasData = false;
        print('no items');

      }else{
        _isLoading = false;
        _hasData = true;
        print('no more items');
      }
    }

    notifyListeners();
    return null;
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }




  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  

  onReload(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }


  Future _handleIosNotificationPermissaion () async {
    NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
  }



  Future initFirebasePushNotification(context) async {
    if (Platform.isIOS) {
      _handleIosNotificationPermissaion();
    }
    handleFcmSubscribtion();
    String? _token = await _fcm.getToken();
    print('User FCM Token : $_token');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    print('inittal message : $initialMessage');
    if (initialMessage != null) {
      nextScreen(context, NotificationsPage());
    }
    

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      showinAppDialog(context, message.notification!.title, message.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      nextScreen(context, NotificationsPage());
    });
    notifyListeners();
  }






  Future handleFcmSubscribtion() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _getsubcription = sp.getBool('subscribe') ?? true;
    if(_getsubcription == true){
      await sp.setBool('subscribe', true);
      _fcm.subscribeToTopic(subscriptionTopic);
      _subscribed = true;
      print('subscribed');
    }else{
      await sp.setBool('subscribe', false);
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      _subscribed = false;
      print('unsubscribed');
    }
    
    notifyListeners();
  }








  Future fcmSubscribe(bool isSubscribed) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribe', isSubscribed);
    handleFcmSubscribtion();
  }



  showinAppDialog(context, title, body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title, style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700
          ),),
          subtitle: Text(
            HtmlUnescape().convert(parse(body).documentElement!.text),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: Text('Open'),
              onPressed: () {
                Navigator.of(context).pop();
                nextScreen(context, NotificationsPage());
              }),
        ],
      ),
    );
  }
}