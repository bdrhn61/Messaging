import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/Hakkimda/hakkimdaVT.dart';
import 'package:space/Home/main_screen.dart';
import 'package:space/LoginIslemleri/kullaniciAdiAl.dart';
import 'package:space/LoginIslemleri/loginVeriTabani.dart';
import 'package:space/counterpro.dart';
import 'package:space/models/Ben.dart';
import 'package:space/models/googleKullanici.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/providerlar/placeMesajProvider.dart';
import 'package:space/toastSnackBar.dart';

class LoginIslemleri {
  GoogleKullanici _googleKullanici = new GoogleKullanici();
  FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  LoginVeriTabani _loginVeriTabani = LoginVeriTabani();
  HakkimdaVt _hakkimdaVt = HakkimdaVt();
  DocumentSnapshot<Map> snapShot;
  DocumentSnapshot<Map> hakkimdaVtSnapshot;

  List<String> _infoKey;
  Map<String, String> hakkimdaMap;

  final globalKey = GlobalKey<ScaffoldState>();
  var anah;

  LoginIslemleri() {
    _infoKey = [
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
    hakkimdaMap = {
      "hakkimda": "",
      "cinsiyet": "",
      "yas": "",
      "boy": "",
      "ilgi_Alanlari": "",
      "egitim": "",
      "is": "",
      "İnstagram": "",
      "twitter": "",
      "snapchat": "",
      "youtube": ""
    };
  }

  esKullaniciOlustur(String userNameTextBox, String emailTextBox,
      String sifreTextBox, String sifre2TextBox, BuildContext context) async {
    if (sifreTextBox == sifre2TextBox) {
      Ben sayfaProvideriBen = Provider.of<Ben>(context,
          listen: false); // HER YERDE TANIMLANMIŞ GLOBAL YAP
      String userName = userNameTextBox; //"bdrn";
      String email = emailTextBox; //"bdrn@gmail.com";
      String sifre = sifreTextBox; //"12358741";

      try {
        debugPrint("$userName  saasd  $email   ----- $sifre ");

        await _auth.createUserWithEmailAndPassword(
            email: email, password: sifre);

        final User kayituser = _auth.currentUser;
        final uid = kayituser.uid;
        String photoUrl = await photoUrlDondur(kayituser);

        var kullaniciMap = _googleKullanici.getKayitEmailPasswordKullaniciMap(
            userName, sifre, email, uid, photoUrl);

        await _firebaseAuth.collection('--users').doc(uid).set(kullaniciMap);
        //  await _db1.kullaniciBilgileriniEkleLokal(uid, kullaniciMap, null);
        // _db1.yerOkuHepsini();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("benimUserName", userName);
        await prefs.setString("benimUserId", uid);
        await prefs.setString("benimPhotoUrl", photoUrl);
        await prefs.setString("benimeMail", email);
        await prefs.setInt("benimeBegeniSayisi", 0);
         await prefs.getString("unicUserName");

        sayfaProvideriBen.benset(userName, uid, photoUrl, email, null, 0,"");

        homePageGit(context);

        //  Navigator.of(context).pushReplacement(MaterialPageRoute(
        //      builder: (context) => ChangeNotifierProvider<CounterPro>(
        //         create: (_) => CounterPro(1, false, 0), child: HomePage())));

        //kullanici.toMap(uid, userName,email,sifre)
        //Navigator.of(context).pushReplacement(
        //    MaterialPageRoute(builder: (context) => SecondScreen()));
        // User _newUser = _credential.user;
        //  _newUser.sendEmailVerification();
        //  if(_auth.currentUser!=null){
        //   debugPrint("COD GONDERİLDİ");
        //   await _auth.signOut();
        //   debugPrint("cikis apildi");
        //   }
      } catch (e) {
        debugPrint("Hataaaaa Kayit");
        debugPrint(e.toString() + "  -*-*-*-*-*-*--*");
      }
    } else {
      showInSnackBar("Passwords must be the same", context);
    }
  }

  giris(String userNameTextBox, String sifreeTextBox,   //Kullanılmıyor  !!!
      BuildContext context) async {
    var sayfaProvideriBen = Provider.of<Ben>(context,
        listen: false); // HER YERDE TANIMLANMIŞ GLOBAL YAP

    String _emaill = userNameTextBox; // "bdrn@gmail.com";
    String _sifree = sifreeTextBox; //"12358741";
    try {
      debugPrint("$_emaill  saasd  $_sifree");
      User user = (await _auth.signInWithEmailAndPassword(
              email: _emaill, password: _sifree))
          .user;

      if (user != null) {
        print(user.uid + "+-------user.uid");
       
        SharedPreferences prefs = await SharedPreferences.getInstance();
        snapShot = await _loginVeriTabani.ilkVeriTabaniOku(user);

        if (snapShot.data() != null) {
          prefs.setString("benimUserName", snapShot.data()["userName"]);
          prefs.setString("benimUserId", _auth.currentUser.uid);
          prefs.setString("benimPhotoUrl", snapShot.data()["photoUrl"]);
          prefs.setString("benimeMail", snapShot.data()["eMail"]);
          prefs.setInt("benimeBegeniSayisi", snapShot.data()["begeniSayisi"]);
          prefs.setString("unicUserName", snapShot.data()["unicUserName"]);

          // ignore: await_only_futures
          await sayfaProvideriBen.benset(
              snapShot.data()["userName"],
              _auth.currentUser.uid,
              snapShot.data()["photoUrl"],
              snapShot.data()["eMail"],
              null,
              snapShot.data()["begeniSayisi"],
              snapShot.data()["unicUserName"]
              );


          homePageGit(context);
        } else {
          showInSnackBar("There is no such user", context);
        }

        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //       builder: (context) => ChangeNotifierProvider<CounterPro>(
        //           create: (_) => CounterPro(1, false, 0), child: HomePage())));

      } else {
        print("!!!!!!!!!!!");
      }
    } catch (e) {
      print("hataaaaaaa");
      // FirebaseAuthException   PlatformException
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showInSnackBar("no user name.", context);

        // showInSnackBar("zzzzzzzzzzz",context);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showInSnackBar("the password is incorrect.", context);
      } else if (e.code == 'ınvalıd-emaıl') {
        showInSnackBar("no user name.", context);
      } else {
        print("e.code : " + e.code + "e.acıklama" + e.message);
      }

      //  debugPrint("HAsSAAAAAAAAAAAAA");
      //  debugPrint("*****" + e.toString());
    }
  }

  signInWithGoogle(BuildContext context) async {
    print("signInWithGoogle-----------");
    var sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    GoogleSignIn googleSignIn = GoogleSignIn();
    print("2");
    GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } on PlatformException catch (e) {
      print("hataaaaaaaaaaaa");
      print(e.toString());
    } catch (e) {
      print("hataaaaaaaaaaaa2");
    }

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        await _auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
        final User kayituser = _auth.currentUser;

        if (googleUser.id != null) {
          snapShot = await _loginVeriTabani.ilkVeriTabaniOku(kayituser);

          if (snapShot.data() == null) {
            File file;
            print("resim yükleniyor...");
            file = await fileDondur();
            Reference ref = await FirebaseStorage.instance
                .ref("users")
                .child(kayituser.uid);

            await ref.putFile(file);
            String photoDownloadurl = await ref.getDownloadURL();
            print("resim yüklendi Ok !");
            var kullaniciMapGoogleKayit =
                _googleKullanici.getGoogleKullaniciMapGoogleKayit(
                    googleUser.email,
                    googleUser.displayName,
                    googleUser.id,
                    photoDownloadurl);
            await _loginVeriTabani.kullaniciBilgileriniGirFirebase(
                kayituser, kullaniciMapGoogleKayit);

            await prefs.setString("benimUserName", googleUser.displayName);
            await prefs.setString("benimUserId", kayituser.uid);
            await prefs.setString("benimPhotoUrl", photoDownloadurl);
            await prefs.setString("benimeMail", googleUser.email);

            await prefs.setInt("benimeBegeniSayisi", 0);
            print("iki veri tabanınada yazıldı");

            sayfaProvideriBen.benset(googleUser.displayName, kayituser.uid,
                photoDownloadurl, googleUser.email, null, 0,"");
                
            kullaniciAdiAlSayfasinaGit(context);  
            //_db1.yerOkuHepsini();
          } else {
            String unicUserName =   snapShot.data()["unicUserName"];
            await prefs.setString("benimUserName", snapShot.data()["userName"]);
            await prefs.setString("benimUserId", _auth.currentUser.uid);
            await prefs.setString("benimPhotoUrl", snapShot.data()["photoUrl"]);
            await prefs.setString("benimeMail", snapShot.data()["eMail"]);
            if(unicUserName!=null)
              await prefs.setString("unicUserName", snapShot.data()["unicUserName"]);
              else
              await prefs.setString("unicUserName", "");
            await prefs.setInt(
                "benimeBegeniSayisi", snapShot.data()["begeniSayisi"]);

            sayfaProvideriBen.benset(
                snapShot.data()["userName"],
                _auth.currentUser.uid,
                snapShot.data()["photoUrl"],
                snapShot.data()["eMail"],
                null,
                snapShot.data()["begeniSayisi"],
                unicUserName!=null?unicUserName:"",

                );

               

            if(unicUserName!=null||unicUserName=="")
              homePageGit(context);
              else
              kullaniciAdiAlSayfasinaGit(context);
          }
          hakkimdaVtIslemleri(prefs, sayfaProvideriBen);
        }
      }
    }
  }

  hakkimdaVtIslemleri(SharedPreferences prefs, var sayfaProvideriBen) async {
    hakkimdaVtSnapshot = await _hakkimdaVt.vTokuIlk();
    if (hakkimdaVtSnapshot.data() == null) {
      print("Hakkımda VT  null döndü---------------");
      _hakkimdaVt.vTYazIlk();
      for (int i = 0; i < _infoKey.length; i++) {
        await prefs.setString(_infoKey[i], "");
        sayfaProvideriBen.benHakkimdaSet(hakkimdaMap);
      }
    } else {
      print("Hakkımda VT  doluuuuu döndü---------------");

      sayfaProvideriBen.benHakkimdaSet(hakkimdaVtSnapshot.data());
      for (int i = 0; i < _infoKey.length; i++) {
        await prefs.setString(
            _infoKey[i], hakkimdaVtSnapshot.data()[_infoKey[i]]);
      }
    }
  }
/*
  signInWithFacebook(BuildContext context) async {
    print("signInWithFacebook----------------");
    var sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final facebookLogin = FacebookLogin();

    FacebookLoginResult faceResult =
        await facebookLogin.logIn('public_profile', 'email');
    switch (faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (faceResult.accessToken != null) {
          UserCredential firebaseCredential = await _auth.signInWithCredential(
              FacebookAuthProvider.credential(faceResult.accessToken.token));
          User _user = firebaseCredential.user;
          final User kayituser = _auth.currentUser;
          print("burasiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii  :");
          // print(kayituser.email +"  :  kayıt user");

          if (_user.uid != null) {
            snapShot = await _loginVeriTabani.ilkVeriTabaniOku(kayituser);
            if (snapShot.data() == null) {
              File file;
              print("resim yükleniyor...");
              file = await fileDondur();
              Reference ref = await FirebaseStorage.instance
                  .ref("users")
                  .child(kayituser.uid);

              await ref.putFile(file);
              String photoDownloadurl = await ref.getDownloadURL();
              print("resim yüklendi Ok !");
              var kullaniciMapGoogleKayit =
                  _googleKullanici.getGoogleKullaniciMapGoogleKayit(
                      _user.providerData[0].email,
                      _user.displayName,
                      _user.uid,
                      photoDownloadurl);
              await _loginVeriTabani.kullaniciBilgileriniGirFirebase(
                  kayituser, kullaniciMapGoogleKayit);

              await prefs.setString("benimUserName", _user.displayName);
              await prefs.setString("benimUserId", kayituser.uid);
              await prefs.setString("benimPhotoUrl", photoDownloadurl);
              await prefs.setString("benimeMail", _user.providerData[0].email);
              await prefs.setInt("benimeBegeniSayisi", 0);
              print("iki veri tabanınada yazıldı");

              sayfaProvideriBen.benset(_user.displayName, kayituser.uid,
                  photoDownloadurl, _user.providerData[0].email, null, 0,"");

                  
              kullaniciAdiAlSayfasinaGit(context);
              //_db1.yerOkuHepsini();
            } else {
           String unicUserName =   snapShot.data()["unicUserName"];
              await prefs.setString(
                  "benimUserName", snapShot.data()["userName"]);
              await prefs.setString("benimUserId", _auth.currentUser.uid);
              await prefs.setString(
                  "benimPhotoUrl", snapShot.data()["photoUrl"]);
              await prefs.setString("benimeMail", snapShot.data()["eMail"]);
              if(unicUserName!=null)
              await prefs.setString("unicUserName", snapShot.data()["unicUserName"]);
              else
              await prefs.setString("unicUserName", "");

              await prefs.setInt(
                  "benimeBegeniSayisi", snapShot.data()["begeniSayisi"]);
              sayfaProvideriBen.benset(
                  snapShot.data()["userName"],
                  _auth.currentUser.uid,
                  snapShot.data()["photoUrl"],
                  snapShot.data()["eMail"],
                  null,
                  snapShot.data()["begeniSayisi"],
                  unicUserName!=null?unicUserName:"",
                  );

                  
              if(unicUserName!=null||unicUserName=="")
              homePageGit(context);
              else
              kullaniciAdiAlSayfasinaGit(context);

            }
          }
          hakkimdaVtIslemleri(prefs, sayfaProvideriBen);

/////////////////////////////////////////
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Giriş iptal");
        break;
      case FacebookLoginStatus.error:
        print("hataaaaaa!!!!  :  " + faceResult.errorMessage);
        break;
    }
  }

*/
  void homePageGit(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
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
              // ChangeNotifierProvider<NotificationHandler>.value(
              //    value: NotificationHandler(),
              //   ),
              ChangeNotifierProvider<PlaceMesajProvider>(
                create: (_) => PlaceMesajProvider(0, false, null, null),
              ),
              ChangeNotifierProvider<CounterPro>(
                  create: (_) => CounterPro(1, false, 0), child: MainScreen())
            ],
            child: MainScreen(),
          ),
        ));
  }

  kullaniciAdiAlSayfasinaGit(BuildContext context){

     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                return KullaniciAdiAl();
              }));
   
  }

  /*

  Future<User> signInWithFacebook(BuildContext context) async {
    final facebookLogin = FacebookLogin();

    FacebookLoginResult faceResult = await facebookLogin.logIn(['email']);

    switch (faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (faceResult.accessToken != null) {
          var firebaseResult = await _auth.signInWithCredential(
              FacebookAuthProvider.credential(faceResult.accessToken.token));

          return null;
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Kullanici girisi iptal etti");
        break;
      case FacebookLoginStatus.error:
        print("Hata ciktisi : " + faceResult.errorMessage);
        break;
    }

    return null;
  }
*/
  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.png'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  fileDondur() async {
    File file;
    var data = await rootBundle.load("assets/images/userprofil2.png");

    try {
      file = await writeToFile(data); // <= returns File
    } catch (e) {
      // catch errors here
    }
    return file;
  }

  Future<String> photoUrlDondur(User kayituser) async {
    File file;
    print("resim yükleniyor...");
    file = await fileDondur();
    Reference ref =
        await FirebaseStorage.instance.ref("users").child(kayituser.uid);

    await ref.putFile(file);
    String photoDownloadurl = await ref.getDownloadURL();
    print("resim yüklendi Ok !");
    return photoDownloadurl;
  }
}
