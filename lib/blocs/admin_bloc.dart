
// import 'package:admin/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/utils/toast.dart';

class AdminBloc extends ChangeNotifier {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _adminPass;
  String _userType = 'admin';
  bool _isSignedIn = false;
  bool _testing = false;

  List _states = [];
  List get states => _states;

  List _users = [];
  List get users => _users;
  

  AdminBloc() {
    checkSignIn();
    getAdminPass();
  }

  
  String? get adminPass => _adminPass;
  String get userType => _userType;
  bool get isSignedIn => _isSignedIn;
  bool get testing => _testing;


  bool? _adsEnabled = false;
  bool? get adsEnabled => _adsEnabled;
  


  Future getAdsData () async {
    await firestore.collection('admin').doc('ads').get()
    .then((value){
      if(value.exists){
        _adsEnabled = value['ads_enabled'];
      }else{
        firestore.collection('admin').doc('ads')
        .set({
          'ads_enabled' : false
        });
      }
    });
    print('ads : $_adsEnabled');
    notifyListeners();
  }



  Future controllAds (bool value, context) async {
    await firestore.collection('admin').doc('ads')
    .update({
      'ads_enabled' : value
    });
    _adsEnabled = value;
    if(value == true){
      openToast(context, "Ads enabled successfully");
    }else{
      openToast(context, "Ads disabled successfully");

    }
    notifyListeners();
  }


  

  Future getAdminPass() async{
    firestore
        .collection('admin')
        .doc('user type')
        .get()
        .then((DocumentSnapshot snap) {
      String? _aPass = snap['admin password'];
     _adminPass = _aPass;
      notifyListeners();
    });
  }



  Future<int> getTotalDocuments (String documentName) async {
    final String fieldName = 'count';
    final DocumentReference ref = firestore.collection('item_count').doc(documentName);
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        int itemCount = snap[fieldName] ?? 0;
        return itemCount;
      }
      else{
        await ref.set({
          fieldName : 0
        });
        return 0;
      }
  }


  Future increaseCount (String documentName) async {
    await getTotalDocuments(documentName)
    .then((int documentCount)async {
      await firestore.collection('item_count')
      .doc(documentName)
      .update({
        'count' : documentCount + 1
      });
    });
  }



  Future decreaseCount (String documentName) async {
    await getTotalDocuments(documentName)
    .then((int documentCount)async {
      await firestore.collection('item_count')
      .doc(documentName)
      .update({
        'count' : documentCount - 1
      });
    });
  }

  



  Future getStates ()async{
    QuerySnapshot snap = await firestore.collection('states').get();
    List d = snap.docs;
    _states.clear();
    d.forEach((element) {
      _states.add(element['name']);
    });
    notifyListeners();
    
  }

  Future getUsers ()async{
    QuerySnapshot snap = await firestore.collection('users').get();
    List d = snap.docs;
    _users.clear();
    d.forEach((element) {
      _users.add(element['email']);
    });


    notifyListeners();
    
  }


  


  Future<List> getFeaturedList ()async{
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        List featuredList = snap['places'] ?? [];
        if(featuredList.isNotEmpty){
          List<int> a = featuredList.map((e) => int.parse(e)).toList()..sort();
          List<String> b = a.take(10).toList().map((e) => e.toString()).toList();
          return b;
        }else{
          return featuredList;
        }
      }
      else{
        await ref.set({
          'places' : []
        });
        return [];
      }
  }

  


  Future addToFeaturedList (context, String? timestamp) async {
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
    await getFeaturedList().then((featuredList)async{

      if (featuredList.contains(timestamp)) {
        openToast(context, "This item is already available in the featured list");
      } else {
        featuredList.add(timestamp);
        await ref.update({'places': FieldValue.arrayUnion(featuredList)});
        openToast(context, 'Added Successfully');
      }
    });
  }

  Future removefromFeaturedList (context, String? timestamp) async {
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
    await getFeaturedList().then((featuredList)async{

      if (featuredList.contains(timestamp)) {
        await ref.update({'places' : FieldValue.arrayRemove([timestamp])});
        openToast(context, 'Removed Successfully');
      } 
    });
  }



  Future deleteContent(timestamp, String collectionName) async {
    await firestore.collection(collectionName).doc(timestamp).delete();
    notifyListeners();
  }


  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    _userType = 'admin';
    notifyListeners();
  }


  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }



  Future setSignInForTesting() async {
    
    _testing = true;
    _userType = 'tester';
    notifyListeners();
    
  }



  Future saveNewAdminPassword (String newPassword) async {
    await firestore.collection('admin')
    .doc('user type')
    .update({
      'admin password' : newPassword
    }).then((value) => getAdminPass());
    notifyListeners();  
  }






}
