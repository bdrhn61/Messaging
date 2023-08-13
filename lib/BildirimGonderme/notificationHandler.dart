import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/Messenger/messengerMesaj.dart';
import 'package:space/Profil/privateProvider.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print("arka planda gelen daaa" + message['data'].toString());

    NotificationHandler.showNotification(message);
  }
/*
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
*/
  return Future<void>.value();
}

class NotificationHandler with ChangeNotifier {
  bool mesajGeldimi = false;
  Color renk = Colors.red;
  static final NotificationHandler _singleton = NotificationHandler._internal();
  final fbReal = FirebaseDatabase.instance;

  FirebaseMessaging fcm ;
  FirebaseAuth _auth = FirebaseAuth.instance;
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();
  BuildContext _myContext;

  initializeFCMNotification(BuildContext context) async {
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    _myContext = context;

    final ref = fbReal.reference();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('me'); //icon burdan aarlanio
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    //_fcm.subscribeToTopic("all");

    // String token = await fcm.getToken();
    // print("Token  :  "+token);
    //  print("Token  lengt  :  "+token.length.toString());

    fcm.onTokenRefresh.listen((newToken) async {
      print("Token  : " + newToken);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String lokalToken = await prefs.getString("token");

      if (lokalToken == null && newToken != null) {
        User _currentUser = await FirebaseAuth.instance.currentUser;
        ref.child("token").child(_currentUser.uid).set(newToken);
        prefs.setString("token", newToken);
        print("Lolal null");
      } else if (lokalToken != newToken && newToken != null) {
        User _currentUser = await FirebaseAuth.instance.currentUser;
        ref.child("token").child(_currentUser.uid).set(newToken);
        prefs.setString("token", newToken);
        print("Lolalden geldi");
      } else {
        print("vt SABİT");
      }

      /* 
      await FirebaseFirestore.instance
          .doc("--usersInfo/" + _currentUser.uid)
          .set({"token": newToken},SetOptions(merge: true));
          */
    });
/*
    fcm .configure(
      onMessage: (Map<String, dynamic> message) async {
        //  print("onMessage: $message");
        //+message['data']['title'].toString()+"  "+message['data']['body'].toString());
        print("onMessage:  $message");
        print(message["data"]["id"]);
        //_notificationHandlerProvider.mesajGeldimiTrueYap();
        //   if(message["data"]["id"]!=_auth.currentUser.uid&&message["data"]["title"]==sayfaProvideriBen.capaRengiDegissinmi){
        //   mesajGeldimiTrueYap();
        //    }
        if (message["data"]["id"] != _auth.currentUser.uid) {
          showNotification(message);
        }
        //mesajGeldimiTrueYap();
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    */
  }

  static void showNotification(Map<String, dynamic> message) {
    print("show nott çalistiiiii !!!!!!!!!!!!!!!!!!!!!!!!!!!");

    // if( message["data"]["id"]!=_auth.currentUser.uid){
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('12345', 'yeni mesaj',
            'your channel description', // 296. ders 5.dakka
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    //  var  IOSplatformChannelSpecifics = IOSNotificationDetails()    ;
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      0,
      message['data']['title'], /////// awai  silindi bi bak
      message['data']['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );

    //}

    // else{
    //   print("mesaj benimmmmmm");
    // }
  }

  Future selectNotification(String payload) async {
    print("object  wwww");
    if (payload != null) {
      debugPrint('notification payload: $payload');
      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);
      print("111  " + gelenBildirim['data']['title'].toString());
      print("222  " + gelenBildirim['data']['adress'].toString());
      print("333  " + gelenBildirim['data']['mekan'].toString());
      print("444  " + gelenBildirim['data']['id'].toString());
      print("555  " + gelenBildirim['data']['body'].toString());
      print("666  " + gelenBildirim['data']['onunPhotoUrl'].toString());

      print("global Adressss" + payload);

      if (gelenBildirim['data']['mekan'].toString() == "1")
        adreseMesajaGit(gelenBildirim);
      else if (gelenBildirim['data']['mekan'].toString() == "2")
        mesajSayfasinaGit(gelenBildirim);
    }
  }

  mesajSayfasinaGit(Map<String, dynamic> gelenBildirim) {
    Navigator.push(
        _myContext,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<PrivateProvider>(
                  create: (_) => PrivateProvider(),
                  child: MessengerMesaj(
                      gelenBildirim['data']['id'].toString(),
                      _auth.currentUser.uid,
                      gelenBildirim['data']['onunPhotoUrl'].toString(),
                      gelenBildirim['data']['adress'].toString(),
                      1,
                      gelenBildirim['data']['title'].toString()),
                )));
  }

  adreseMesajaGit(Map<String, dynamic> gelenBildirim) {
    Navigator.of(_myContext, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AdreseMesajProvider>(
            create: (_) => AdreseMesajProvider(
                false,
                "adres",
                "adres",
                ["", "", "", "", ""],
                ["", "", "", "", ""],
                [
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.black
                ],
                false,
                Colors.red,
                Colors.white,
                "assets/images/ringing.png",
                false,
                "",
                "",
                1,
                1,
                "",
                "",
                null,
                Colors.red),
          ),
          ChangeNotifierProvider<NotificationHandler>.value(
            value: NotificationHandler(),
          ),
        ],
        child: AdreseMesaj(
            gelenBildirim['data']['adress'].toString(),
            gelenBildirim['data']['title'].toString(),
            1), //_sayfaProviderChip.aderseMesajvalue),
      ),
    ));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  mesajGeldimiTrueYap() {
    mesajGeldimi = true;
    print(mesajGeldimi.toString() + "   -------------");
    notifyListeners();
  }

  mesajGeldimiTrueYap2() {
    mesajGeldimi = true;
    print(mesajGeldimi.toString() + "   -------------");
  }

  mesajGeldimiFalseYap() {
    mesajGeldimi = false;
    print(mesajGeldimi.toString() + "   -------------");
    //notifyListeners();
  }

  defaultRenkAta() {
    renk = Colors.red;
  }
}
