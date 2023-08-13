import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:space/Hakkimda/hakkimdaVT.dart';
import 'package:space/LoginIslemleri/hizliGiris.dart';
import 'package:space/models/Ben.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';
import 'package:space/toastSnackBar.dart';

class Hakkimda extends StatefulWidget {
  bool hangiCins;
  Hakkimda(this.hangiCins);
  @override
  _HakkimdaState createState() => _HakkimdaState();
}

class _HakkimdaState extends State<Hakkimda> {
  double en;
  double boy;
  HakkimdaVt _hakkimdaVt;
  TextInputType klavyeTipi;
  List<TextEditingController> textCont;
  List<String> _infoKey;
  Map<String, String> _info = {};
  Ben sayfaProvideriBen;
  bool _chosSelect;
  Map<String, String> onaylanacakVeri;
  TextEditingController userNameTextcontroller;
  @override
  void initState() {
    super.initState();

    _chosSelect = widget.hangiCins;
    onaylanacakVeri = {};
    _hakkimdaVt = HakkimdaVt();
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

    textCont = List.generate(11, (i) => TextEditingController());
    userNameTextcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);

    return Container(
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(boy / 38)),
        child: Scaffold(
          floatingActionButton: InkWell(
            onTap: () async {
              for (int i = 0; i < _infoKey.length; i++) {
                if (textCont[i].text != "") {
                  onaylanacakVeri[_infoKey[i]] = textCont[i].text;
                }
              }
              print(onaylanacakVeri.toString());

              if (onaylanacakVeri.length > 0) {
                List<String> anahtar = onaylanacakVeri.keys.toList();
                List<String> deger = onaylanacakVeri.values.toList();
                await _hakkimdaVt.degisiklikYap(
                    onaylanacakVeri, anahtar, deger);
                sayfaProvideriBen.benHakkimdaDegisiklikSet(anahtar, deger);
                showInSnackBar("Change approved.", context);
              }
            },
            child: Image.asset(
              "assets/images/check.png",
              width: boy / 15,
              height: boy / 15,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: boy / 24,
                  color: Colors.grey.withOpacity(0.3),
                ),
                kullaniciAdi("user name"),
                rituel("about me", TextInputType.text, textCont[0],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[0]]),

                rituel("gender", TextInputType.text, textCont[1],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[1]]),
                rituel("age", TextInputType.number, textCont[2],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[2]]),
                rituel("height", TextInputType.number, textCont[3],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[3]]),
                // rituel("İlgi Alanları", TextInputType.text, textCont[4],
                //     sayfaProvideriBen.hakkimdaMap[_infoKey[4]]),
                rituel("education", TextInputType.text, textCont[5],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[5]]),
                rituel("job", TextInputType.text, textCont[6],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[6]]),
                rituel("instagram", TextInputType.text, textCont[7],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[7]]),
                rituel("twitter", TextInputType.text, textCont[8],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[8]]),
                rituel("snapchat", TextInputType.text, textCont[9],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[9]]),
                rituel("youtube", TextInputType.text, textCont[10],
                    sayfaProvideriBen.hakkimdaMap[_infoKey[10]]),
                InkWell(
                  onTap: () {
                    cikisAlert(context);
                  },
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                    width: en,
                    height: boy / 12,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "sign out",
                        textScaleFactor: 1,
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cikisAlert(BuildContext cntx) {
    var en = MediaQuery.of(context).size.width;
    print(en / 20);
    showGeneralDialog(
        context: cntx,
        pageBuilder: (cntx, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: 'aaaaa',
        transitionBuilder: (cntx, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: anim1.value,
              child: AlertDialog(
                  backgroundColor: Colors.black,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(en / 20)),
                  content: Builder(
                    builder: (cntx) {
                      double height = MediaQuery.of(context).size.height;
                      double width = MediaQuery.of(context).size.width;
                      return Container(
                        height: height / 4,
                        width: width / 4,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Are you sure you want to log out ?",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: height / 20),
                              InkWell(
                                onTap: _cikis,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(width / 64)),
                                  child: Padding(
                                      padding: EdgeInsets.all(width / 64),
                                      child: Text("YES",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 450));
  }

  void _cikis() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final _googleSignIn = GoogleSignIn();
      //if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
      await _auth.signOut();
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();
      
     // Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => HizliGiris()));
    } catch (e) {
      print("cıkıs yaparken hata olustu  :" + e.toString());
    }
  }

  Widget rituel(String baslik, TextInputType klavyeTipi,
      TextEditingController textController, String hintText) {
    if (baslik == "gender") {
      print(hintText.toString() + "     hint text --------------");

      return Column(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.1),
            width: en,
            height: boy / 12,
            child: Padding(
              padding: EdgeInsets.only(bottom: boy / 64, left: en / 30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  baslik,
                  textScaleFactor: en / (en / 1.1),
                  style: GoogleFonts.montserrat(
                      letterSpacing: 1, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ChoiceChip(
                  shadowColor: Colors.black,
                  disabledColor: Colors.black,
                  backgroundColor: Colors.black,
                  selectedColor: Color.fromARGB(255, 174, 153, 90),
                  label: Text(
                    "Male",
                    textScaleFactor: 1,
                    style: GoogleFonts.montserrat(
                        letterSpacing: 1, color: Colors.white),
                  ),
                  selected: _chosSelect == null ? false : _chosSelect,
                  onSelected: (selected) {
                    setState(() {
                      if (_chosSelect == null)
                        _chosSelect = true;
                      else if (_chosSelect)
                        _chosSelect = false;
                      else
                        _chosSelect = true;
                    });
                    onaylanacakVeri["cinsiyet"] = "erkek";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ChoiceChip(
                  shadowColor: Colors.black,
                  disabledColor: Colors.black,
                  backgroundColor: Colors.black,
                  selectedColor: Color.fromARGB(255, 174, 153, 90),
                  label: Text(
                    "woman",
                    textScaleFactor: 1,
                    style: GoogleFonts.montserrat(
                        letterSpacing: 1, color: Colors.white),
                  ),
                  selected: _chosSelect == null ? false : !_chosSelect,
                  onSelected: (selected) {
                    setState(() {
                      if (_chosSelect == null)
                        _chosSelect = false;
                      else if (_chosSelect)
                        _chosSelect = false;
                      else
                        _chosSelect = true;
                    });
                    onaylanacakVeri["cinsiyet"] = "kadın";
                  },
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return Column(children: [
        Container(
          color: Colors.grey.withOpacity(0.1),
          width: en,
          height: boy / 12,
          child: Padding(
            padding: EdgeInsets.only(bottom: boy / 64, left: en / 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                baslik,
                textScaleFactor: en / (en / 1.1),
                style: GoogleFonts.montserrat(
                    letterSpacing: 1, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: en / 30, right: en / 30),
          child: TextField(
              controller: textController,
              cursorColor: Colors.black,
              keyboardType: klavyeTipi,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: hintText)),
        )
      ]);
    }
  }

  Widget kullaniciAdi(String baslik) {
    return Column(
      children: [
        Container(
          color: Colors.grey.withOpacity(0.1),
          width: en,
          height: boy / 12,
          child: Padding(
            padding: EdgeInsets.only(bottom: boy / 64, left: en / 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                baslik,
                textScaleFactor: en / (en / 1.1),
                style: GoogleFonts.montserrat(
                    letterSpacing: 1, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: en / 30, right: en / 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: en / 2,
                child: TextField(
                    controller: userNameTextcontroller,
                    cursorColor: Colors.black,
                    keyboardType: klavyeTipi,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: sayfaProvideriBen.unicUserName == null ||
                                sayfaProvideriBen.unicUserName == ""
                            ? "user name"
                            : sayfaProvideriBen.unicUserName)),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
                child: InkWell(
                  onTap: () {
                    if (userNameTextcontroller.text.trim().length > 4)
                      _hakkimdaVt.kullaniciAdiniVTyeYaz(
                          userNameTextcontroller.text, context);
                    else {
                      showInSnackBar(
                          "The number of characters used must be at least 5.",
                          context);
                    }
                    //   kullaniciAdiniVTyeYaz(userNameTextcontroller.text);
                    //  print(userNameTextcontroller.text);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(en / 40),
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
