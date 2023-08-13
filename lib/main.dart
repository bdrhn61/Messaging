// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/Home/main_screen.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';

import 'LoginIslemleri/hizliGiris.dart';
import 'LoginIslemleri/kullaniciAdiAl.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Ben()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        theme: ThemeData(
            primaryColor: Colors.black,
            hintColor: Colors.grey,
            fontFamily: GoogleFonts.montserrat(letterSpacing: 10).fontFamily,
            textTheme: GoogleFonts.montserratTextTheme()),
        home: App(),
        debugShowCheckedModeBanner: false);
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late bool unicUsernameVarMi;
  @override
  void initState() {
    unicUsernameVarMi = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //  Initialize FlutterFire:
      future: _baslangicFonk(),

      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Upss Errr  " + snapshot.error.toString(),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          User? user = FirebaseAuth.instance.currentUser;
          print(unicUsernameVarMi.toString()+"&&");

          if (user != null && unicUsernameVarMi) {
            print("otomatik geç ");

            return MultiProvider(
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
                // ChangeNotifierProvider<NotificationHandler>.value(
                //    value: NotificationHandler(),
                //   ),
                //  ChangeNotifierProvider<PlaceMesajProvider>(
                //    create: (_) => PlaceMesajProvider(0, false, null, null),
                //    ),
                //    ChangeNotifierProvider<CounterPro>(
                //        create: (_) => CounterPro(1, false, 0), child: HomePage())
              ],
              child: MainScreen(),
            );
          } else if (user != null&&unicUsernameVarMi==false) {
            return KullaniciAdiAl();
          } else {
            // log in
            print("Giriş yapmalısın ");
            return HizliGiris();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        );
      },
    );
  }

  _baslangicFonk() async {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp _initialization = await Firebase.initializeApp();

    await onbellek(context);
  }

  Future<void> onbellek(context) async {
    List<String> _infoKeyList = [
      "hakkimda",
      "cinsiyet",
      "yas",
      "boy",
      "ilgi_Alanlari",
      "egitim",
      "is",
      "İnstagram",
      "twitter",
      "snapchat",
      "youtube"
    ];
    Map<String, String> vTGelendeger = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: false);

    // ignore: await_only_futures
    await sayfaProvideriBen.benset(
        prefs.getString("benimUserName").toString(),
        prefs.getString("benimUserId").toString(),
        prefs.getString("benimPhotoUrl").toString(),
        prefs.getString("benimeMail").toString(),
        null,
        prefs.getInt("benimeBegeniSayisi"),
        prefs.getString("unicUserName").toString());
    String temp = prefs.getString("unicUserName").toString();
    print(temp.toString()+  "  yyyyyy");
    if (temp == null||temp =="") unicUsernameVarMi = false;
    //   String unicUserName = await prefs.getString("unicUserName");
    //   sayfaProvideriBen.unicUserNameSet(unicUserName);

    for (int i = 0; i < _infoKeyList.length; i++) {
      vTGelendeger[_infoKeyList[i]] = await prefs.getString(_infoKeyList[i]).toString();
    }

    sayfaProvideriBen.benHakkimdaSet(vTGelendeger);
  }
}
