import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/LoginIslemleri/login_islemleri.dart';
import 'package:pointycastle/api.dart' as crypto;

class HizliGiris extends StatelessWidget {
  double en;
  double boy;
  LoginIslemleri loginIslemleri = new LoginIslemleri();
  SharedPreferences prefs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  

  Future<crypto.AsymmetricKeyPair> futureKeyPair;
  crypto.AsymmetricKeyPair keyPair;
  RsaKeyHelper helper;

  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;

    return  WillPopScope (
      // ignore: missing_return
      onWillPop: (){
        print("object");
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              width: en,
              height: boy / 2,
              child: Column(
                children: [
                  
                  Expanded(
                    child: Image.asset(
                              "assets/images/space-icon3.jpg",
                              
                            ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Connect with",
                        textScaleFactor: 2,
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: boy / 18,
            ),
            InkWell(
              onTap: () async {
                print("google");
                await loginIslemleri.signInWithGoogle(context);
                anahtarAl();
              },
              child: Stack(
                children: [
                  Container(
                    width: en / 1.3,
                    height: boy / 12,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 221, 75, 57),
                      borderRadius: BorderRadius.all(Radius.circular(
                              4.0) //                 <--- border radius here
                          ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: en / 25),
                        child: Container(
                          height: boy / 12,
                          child: Image.asset(
                            "assets/images/google-plus.png",
                            width: en / 15,
                            height: en / 15,
                          ),
                        ),
                      ),
                      Container(
                        width: en / 2.3,
                        height: boy / 12,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: en / 20),
                            child: Text(
                              "Google",
                              textScaleFactor: 1.3,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: boy / 100,
            ),
            InkWell(
              onTap: () async {
           //   await  loginIslemleri.signInWithFacebook(context);
                print("facebook");
                anahtarAl();

              },
              child: Stack(
                children: [
                  Container(
                    width: en / 1.3,
                    height: boy / 12,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 24, 119, 242),
                      borderRadius: BorderRadius.all(Radius.circular(
                              4.0) //                 <--- border radius here
                          ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: en / 25),
                        child: Container(
                          height: boy / 12,
                          child: Image.asset(
                            "assets/images/face.png",
                            width: en / 15,
                            height: en / 15,
                          ),
                        ),
                      ),
                      Container(
                        width: en / 2.3,
                        height: boy / 12,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: en / 20),
                            child: Text(
                              "Facebook",
                              textScaleFactor: 1.3,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    helper = RsaKeyHelper();

    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  anahtarAl() async {
    if(_auth.currentUser.uid!=null){
    prefs = await SharedPreferences.getInstance();
    String priv =  prefs.getString(_auth.currentUser.uid+"private");
    if (priv == null) {

    final _fbReal = FirebaseDatabase.instance;  
    final  _ref = _fbReal.reference();
    
    DatabaseEvent _sonuc = await _ref.child("public").child(_auth.currentUser.uid).once();
      if (_sonuc.snapshot.value == null) {
      
      
      print(_auth.currentUser.uid);
      futureKeyPair = getKeyPair();
      keyPair = await futureKeyPair;

      String _private = helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
      //  print("privat  : "+a);
      print("+++--------------------++");
      String _public = helper.encodePublicKeyToPemPKCS1(keyPair.publicKey);
     await prefs.setString(_auth.currentUser.uid+"private", _private);
     await prefs.setString(_auth.currentUser.uid+"public", _public);

      // TRANSECTİONNNNNNNN   YAPPPP  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      _ref.child("public").child(_auth.currentUser.uid).set(_public);
      _ref.child("private").child(_auth.currentUser.uid).set(_private);




      }else{

        print("lokalde yok vt de var");

        print(_sonuc.snapshot.value.toString()+"  ???");
        await prefs.setString(_auth.currentUser.uid+"public", _sonuc.snapshot.value.toString());
        _sonuc = await _ref.child("private").child(_auth.currentUser.uid).once();
        print(_sonuc.snapshot.value.toString()+"  444");
        await prefs.setString(_auth.currentUser.uid+"private", _sonuc.snapshot.value.toString());
        



      }





    } else {
      print("null değil");
    }
  }
  }
}
