import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:space/Messenger/messengerMesaj.dart';
import 'package:space/Profil/privateProvider.dart';
import 'package:space/Profil/tekFoto.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';

class ProfilSyfasi extends StatefulWidget {
  String isim;
  String _mesajGonderilecekUid;
  String _benimUid;
  String _photoUrl;
  String _unicUserName;

  ProfilSyfasi(
      this.isim, this._mesajGonderilecekUid, this._benimUid, this._photoUrl,this._unicUserName);
  @override
  _ProfilSyfasiState createState() => _ProfilSyfasiState();
}

class _ProfilSyfasiState extends State<ProfilSyfasi> {
  String begeni;
  Map<String, dynamic> _hakkimda;
  AdreseMesajProvider sayfaProvideriAdres;
  int infovarMi;
  FirebaseAuth  _auth=FirebaseAuth.instance;

  @override
  void initState() {
    infovarMi = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;
    Ben sayfaProvideri = Provider.of<Ben>(context, listen: false);
    sayfaProvideri.buildEtmeAta(false);
    print(widget._benimUid.toString()+"+++++++");
    print(widget._mesajGonderilecekUid.toString()+"---------");

    return Container(
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(en / 21),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: boy / 14,
                automaticallyImplyLeading: false,

                

                leading: IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                //backgroundColor: Colors.white,
                
              ),
          body:  SingleChildScrollView(
              child: Column(
                children: [
                  (widget._mesajGonderilecekUid !=_auth.currentUser.uid)?
                  Padding(
                    padding: EdgeInsets.only(top: boy / 20),
                    child: Container(
                      width: en,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                             if(widget._mesajGonderilecekUid !=_auth.currentUser.uid)
                            _mesajYazmaSayfasinaGit(widget._mesajGonderilecekUid,
                                widget._photoUrl, widget.isim);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: en / 35),
                            child: Image.asset(
                              "assets/images/mail-inbox-app.png",
                              width: boy / 20,
                              height: boy / 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):SizedBox(
                    width: boy / 20,
                    height: boy / 13,
                  ),




                 

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(boy / 15)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeftWithFade,
                                    child: TekFoto(widget._photoUrl)));
                          },
                          child: Image.network(
                            widget._photoUrl,
                            width: boy / 6,
                            height: boy / 6,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace stackTrace) {
                              return Center(
                                child: Container(
                                  width: boy / 6,
                                  height: boy / 6,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(boy / 15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: Container(
                                    width: boy / 6,
                                    height: boy / 6,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(boy / 15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Text(widget.gelenIsim),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: boy / 25,
                      ),
                      child: Text(
                        widget.isim,
                        textScaleFactor: en / (en / 1.1),
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(
                              
                            ),
                            child: Text(
                            (widget._unicUserName==null||widget._unicUserName == "")?"":"@"+widget._unicUserName  ,
                              textScaleFactor: 0.9,
                              style: GoogleFonts.montserrat(
                                   color: Color.fromARGB(255, 174, 153, 90),
                                   fontWeight: FontWeight.normal),
                            )),
                      ),

                  SizedBox(
                    height: boy / 30,
                  ),

                  Center(
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: _begeniGetir(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return _hakkimda == null
                                ? Expanded(
                                    child: Center(
                                        child: Padding(
                                      padding: EdgeInsets.only(top: boy / 40),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.black),
                                      ),
                                    )),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(boy / 15)),
                                        ),
                                        child: Center(
                                          child: Wrap(
                                            alignment: WrapAlignment.spaceAround,
                                            spacing: 5.0,
                                            runSpacing: 5.0,
                                            children: [
                                              if (_hakkimda["hakkimda"] != "" && _hakkimda["hakkimda"] != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 8.0),
                                                  child: Container(
                                                    width: en,
                                                    child: Center(
                                                        child: Text(
                                                            _hakkimda["hakkimda"])),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: boy / 50,
                                                width: en,
                                              ),
                                              if (_hakkimda["cinsiyet"] != "" &&_hakkimda["cinsiyet"] != null)
                                                birChip(_hakkimda["cinsiyet"], boy,
                                                    "assets/images/hakkimda/gender-symbols.png"),
                                              if (_hakkimda["yas"] != "" && _hakkimda["yas"] != null)
                                                birChip(_hakkimda["yas"], boy,
                                                    "assets/images/hakkimda/back-in-time.png"),
                                              if (_hakkimda["boy"] != "" && _hakkimda["boy"] != null)
                                                birChip(_hakkimda["boy"], boy,
                                                    "assets/images/hakkimda/length.png"),
                                              if (_hakkimda["egitim"] != "" && _hakkimda["egitim"] != null)
                                                birChip(_hakkimda["egitim"], boy,
                                                    "assets/images/hakkimda/mortarboard.png"),
                                              if (_hakkimda["is"] != "" && _hakkimda["is"] != null)
                                                birChip(_hakkimda["is"], boy,
                                                    "assets/images/hakkimda/suitcase.png"),
                                          //    if (_hakkimda["ilgi_Alanlari"] != "")
                                           //     birChip(
                                          //          _hakkimda["ilgi_Alanlari"],
                                          //          boy,
                                          //          "assets/images/flutter1.png"),
                                              if (_hakkimda["twitter"] != "" && _hakkimda["twitter"] != null)
                                                birChip(_hakkimda["twitter"], boy,
                                                    "assets/images/hakkimda/twitter.png"),
                                              if (_hakkimda["youtube"] != "" && _hakkimda["youtube"] != null)
                                                birChip(_hakkimda["youtube"], boy,
                                                    "assets/images/hakkimda/youtube.png"),
                                              if (_hakkimda["snapchat"] != "" && _hakkimda["snapchat"] != null)
                                                birChip(_hakkimda["snapchat"], boy,
                                                    "assets/images/hakkimda/snapchat.png"),
                                              if (_hakkimda["İnstagram"] != "" && _hakkimda["İnstagram"] != null)
                                                birChip(_hakkimda["İnstagram"], boy,
                                                    "assets/images/hakkimda/instagram.png"),
                                              bossaDondur(boy, en),
                                              SizedBox(
                                                height: boy / 50,
                                                width: en,
                                              ),
                                              if (infovarMi > 0 && infovarMi <= 3)
                                                SizedBox(
                                                  height: boy / 10,
                                                  width: en,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
        ),
      ),
    );
  }

  Future<void> _mesajYazmaSayfasinaGit(
    String mesajGonderilecekUid,
    String onunPhotoUrl,
    String isim,
  ) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<PrivateProvider>(
                  create: (_) => PrivateProvider(),
                  child: MessengerMesaj(widget._mesajGonderilecekUid,
                      widget._benimUid, onunPhotoUrl, null, 2, isim),
                )));

    //widget._mesajGonderilecekUid
    //widget._benimUid
    //onunPhotoUrl
    //
    //
    //     widget.isim,

    /*
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                StreamDeneme(widget.isim,widget._benimUid, widget._mesajGonderilecekUid,_sayfaProvideri)));
   */
  }

  _begeniGetir() async {
    print(widget._mesajGonderilecekUid.toString() + "begeni sayisi");
    await FirebaseFirestore.instance
        .collection('--usersInfo')
        .doc(widget._mesajGonderilecekUid)
        .get()
        .then((value) {
      _hakkimda = value.data();
      print(value.data().toString() + "----------****------");
    });
  }

  birChip(hakkimda, double boy, String connectionString) {
    infovarMi++;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(boy / 15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(boy / 55),
        child: Wrap(
          children: [
            Image.asset(
              connectionString,
              width: boy / 25,
              height: boy / 25,
            ),
            Container(
              height: boy / 25,
              child: Padding(
                padding: EdgeInsets.only(top: boy / 60, left: boy / 40),
                child: Text(
                  hakkimda,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bossaDondur(boy, en) {
    if (infovarMi == 0) {
      print(infovarMi.toString() +
          "  infovar mi------------------------------------------------------------");

      return Center(
        child: Container(
          height: boy / 4,
          child: Center(
            child: Text(
              "info yok",
              textScaleFactor: en / (en / 1.1),
              style: GoogleFonts.montserrat(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      print(infovarMi.toString() +
          "  infovar mişşşş------------------------------------------------------------");
      return SizedBox();
    }
  }

  
}
