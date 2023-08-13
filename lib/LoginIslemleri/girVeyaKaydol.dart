/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:space/Animations/FadeAnimation.dart';
import 'package:space/LoginIslemleri/Kayit/isim.dart';
import 'package:space/LoginIslemleri/login_islemleri.dart';

class GirVeyaKaydol extends StatefulWidget {
  const GirVeyaKaydol({Key key}) : super(key: key);

  @override
  _GirVeyaKaydolState createState() => _GirVeyaKaydolState();
}

class _GirVeyaKaydolState extends State<GirVeyaKaydol> {
  LoginIslemleri loginIslemleri = new LoginIslemleri();
  var _mailController;
  var _sifreController;
  double en;
  double boy;
  var _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _mailController = TextEditingController();
    _sifreController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black, //Color.fromRGBO(3, 9, 23, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(boy / 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: boy / 11),
                child: FadeAnimation(
                    1.2,
                    Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: boy / 28), //  20  px
                child: FadeAnimation(
                    1.5,
                    Container(
                      padding: EdgeInsets.all(boy / 57), //    10  px
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(boy / 57),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]))),
                            child: TextField(
                              controller: _mailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.8)),
                                  hintText: "Email or Phone number"),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: TextField(
                              obscureText: true,
                              controller: _sifreController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.8)),
                                  hintText: "Password"),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: boy / 28),
                child: FadeAnimation(
                    1.8,
                    Center(
                      child: InkWell(
                        onTap: () {
                          loginIslemleri.giris(_mailController.text,
                              _sifreController.text, context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(boy / 57)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: boy / 28, bottom: boy / 28),
                            child: Center(
                                child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    )),
              ),
              FadeAnimation(
                2.1,
                Padding(
                  padding: EdgeInsets.only(top: boy / 57),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white10,
                                Colors.white,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: (en / 32) * 10,
                        height: 1.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: en / 20, right: en / 20),
                        child: Text(
                          "Or",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white10,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: (en / 32) * 10,
                        height: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                2.4,
                Padding(
                  padding: EdgeInsets.only(top: boy / 57),
                  child: InkWell(
                    onTap: () {
                      print("lllllllll");
                      loginIslemleri.signInWithGoogle(context);
                    },
                    child: Image.asset(
                      "assets/images/google_login.png",
                      width: boy / 12,
                      height: boy / 12,
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                2.4,
                Padding(
                  padding: EdgeInsets.only(top: boy / 57),
                  child: InkWell(
                    onTap: ()  {
                      loginIslemleri.signInWithFacebook(context);
                    },
                    child: Image.asset(
                      "assets/images/rightt.png",
                      width: boy / 12,
                      height: boy / 12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: boy / 16), // 35  px
                child: FadeAnimation(
                  2.7,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) => Isim()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/