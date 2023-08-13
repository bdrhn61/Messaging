import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:space/BildirimGonderme/bidirimGondermeServis.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/LocalVeriTabani/database_helper.dart';
import 'package:space/Profil/profilSayfasi.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/arazlar/mesajCubuguNotification.dart';
import 'package:space/publicMesaj/yorumSayfasi.dart';
import 'package:space/publicMesaj/arazlar/capa.dart';

import '../models/publicMesajModel.dart';

AdreseMesajProvider? sayfaProvideri;
String? globalMesajAdres;
String? globaltopBarAdres;
List<String> bildirimIcinSonMesaj = ["0", "0", "0", "0", "0"];
int tumMesajSayisi = 0;

/*
class Adr extends StatelessWidget {
 String mesajAdres;

  Adr(this.mesajAdres);

  @override
  Widget build(BuildContext context) {
    
    return AdreseMesaj(mesajAdres);
  }
}
*/

class AdreseMesaj extends StatefulWidget {
  String mesajAdres;
  String topBarAdres;

  int hangiChip;

  AdreseMesaj(this.mesajAdres, this.topBarAdres, this.hangiChip);
  @override
  AdreseMesajState createState() => AdreseMesajState();
}

ScrollController? _scrollController;

class AdreseMesajState extends State<AdreseMesaj>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var veritabani = FirebaseFirestore.instance;
  var pageCon = PageController(initialPage: 1);
  late String benimUid;
  late bool buildKontrol;

  var sayfaProvideri2;
  Ben? sayfaProvideriBen;
  String? mesajSayisi;
  double? en;
  double? boy;
  @override
  void initState() {
    benimUid = _auth.currentUser!.uid;
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    sayfaProvideriBen?.capaRengiDegissinmiAta(widget.topBarAdres);
    globalMesajAdres = widget.mesajAdres;
    globaltopBarAdres = widget.topBarAdres;
    print("adrese mesaj init -*********************-**-*-*");
    //getMesaj(10);
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    //_scrollListener
    ilkAltaVurmayiEngelle = false;
    NotificationHandler sayfaProvideri2 =
        Provider.of<NotificationHandler>(context, listen: false);

    sayfaProvideri2.defaultRenkAta();
    mesajSayisi = "-2";

    buildKontrol = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.removeListener(_scrollListener);
  }

  late Widget _form;
  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    print(buildKontrol.toString() + "  Build kontrolllll");
    if (_form == null || buildKontrol) {
      print("if in içi-----");
      // Create the form if it does not exist
      _form = _createForm(context); // Build the form
      buildKontrol = false;
    }
    print("return------");
    return _form; // Show the form in the application
  }

  Widget _createForm(BuildContext context) {
    //boy=MediaQuery.of(context).size.height;
    //en=MediaQuery.of(context).size.width;
    sayfaProvideri = Provider.of<AdreseMesajProvider>(context, listen: false);

    print("adrese mesaj build");
    print(
        "1. build mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    return Container(
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(en! / 21)),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: boy! / 14,
            automaticallyImplyLeading: false,

            title: 
            
            Text(
              widget.topBarAdres,
              style: TextStyle(color: Colors.black),
              // style: GoogleFonts.itim(fontSize: 24, letterSpacing: 2.5),
            ),

            leading: IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            //backgroundColor: Colors.white,
            actions: <Widget>[
              IkonButon(en!, boy!),
            ],
          ),
          floatingActionButton: sayfaProvideri?.elemanlarYukleniyor(),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          backgroundColor: Colors.black,

          // resizeToAvoidBottomPadding: true,
          body: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _mesajListesiniOlustur(),
                  MyRow(en!, boy!, widget.hangiChip),
                  SizedBox(
                      // ALT BOSLUK
                      //height: boy,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int kk = 10;
  late List<MesajModel> _tumMesajlar;
  _mesajListesiniOlustur() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0), //////  KENAR BOSLUKLARI AYARLANIR
        child: StreamBuilder<List<MesajModel>>(
          ///////////////////////////////////////////
          stream: _sonuc(),

          builder: (context, streamMesajListesi) {
            if (!streamMesajListesi.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }
            print(streamMesajListesi.data.toString() + "---");
            _tumMesajlar = streamMesajListesi.data!;
            if (_tumMesajlar.length == 0) {
              return Center(
                child: Text(
                  "No message",
                  // style: GoogleFonts.itim(
                  //     fontSize: 24, letterSpacing: 2.5, color: Colors.black)
                ),
              );
            }

            List<MesajModel> lokal = [];

            lokal.addAll(_tumMesajlar);
            if (degis == true) {
              _tumMesajlar = [];
              _tumMesajlar.addAll(lokal);
            }
            //log("Items: " + streamMesajListesi.data.length.toString());

            return Stack(
              children: <Widget>[
                ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _tumMesajlar.length,
                  itemBuilder: (context, index) {
                    print(
                        _tumMesajlar[index].yorumVarmi.toString() + "--------");
                    tumMesajSayisi = _tumMesajlar.length;
                    var _saatDakikaDegeri = "";
                    try {
                      _saatDakikaDegeri = _saatDakikaGoster(
                          _tumMesajlar[index].date ?? Timestamp(1, 1));
                    } catch (e) {
                      print("errr  : " + e.toString());
                    }
                    print("list build");
                    // print(mesajSayisi.toString()+"--");
                    // print(_tumMesajlar[0].date.toString()+"**");

                    if (_tumMesajlar.length > 1) {
                      bildirimIcinSonMesaj = _saatDakikaGosterBildirim(
                          _tumMesajlar[1].date ?? Timestamp(1, 1));

                      if (_tumMesajlar[0].userID != _auth.currentUser?.uid &&
                          mesajSayisi != _tumMesajlar[0].date.toString()) {
                        // sayfaProvideri.capaRenkYesilYap();
                        mesajSayisi = _tumMesajlar[0].date.toString();
                      }
                    }

                    // log(_scrollController.initialScrollOffset.toString());
                    //log(_scrollController.position.isScrollingNotifier.toString());

                    return Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left:en!/18,right: en!/18,top: 7,bottom: 7),
                          child: Container(
                            height: 0.5,
                            color: Colors.black.withOpacity(0.3), //  5  px
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.5, right: 1.5),
                          child: Container(
                            
                            decoration: BoxDecoration(
                           //   color:Colors.red.withOpacity(0.5),
                              border: Border.all(
                                  color: Colors.black.withOpacity(0)),
                              borderRadius:
                                  BorderRadius.circular(en! / 64), //  20  px
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0), //  5  px
                              child: Wrap(
                                children: [
                            

                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0, left: 2, right: 0),
                                    child: kisiBilgileri(
                                        _tumMesajlar[index].potoUrl,
                                        _tumMesajlar[index].userName,
                                        _saatDakikaDegeri,
                                        _tumMesajlar[index].userID,
                                        _tumMesajlar[index].unicUserName ==
                                                    null ||
                                                _tumMesajlar[index]
                                                        .unicUserName ==
                                                    ""
                                            ? "anonymous"
                                            : _tumMesajlar[index].unicUserName,index),

                                    // KullaniciBilgileri(userid, _saatDakikaDegeri,_tumMesajlar[index].userName,_tumMesajlar[index].potoUrl),
                                  ),

                                  //color: Colors.black,

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(en! / 16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: boy! / 60,
                                          left: en! / 64,
                                          right: en! / 64,
                                          bottom: boy! / 60),
                                      child: Center(
                                        child: Text(
                                          _tumMesajlar[index].mesaj,
                                          textScaleFactor: 0.8,
                                          style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.montserrat(
                                                          letterSpacing: 10)
                                                      .fontFamily,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),

                                  FadeTransitionDemo(
                                      benimUid,
                                      _tumMesajlar[index].mesajId,
                                      _tumMesajlar[index].userID,
                                      _tumMesajlar,
                                      index,
                                      widget.mesajAdres,
                                      en!,
                                      boy!),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    );
                  },
                ),
                Capa(_tumMesajlar[0].userID, widget.mesajAdres,
                    _scrollController!, sayfaProvideri!.capaRenk),

                //  GeridenGelenMesaj(),
              ],
            );

            //mesajGelinceGoster(),
          },
        ),
      ),
    );
  }

  late Stream<List<MesajModel>> temp;
  late Stream<List<MesajModel>> ll;
  bool degis = false;
  int a = 1;
  late bool ilkAltaVurmayiEngelle;
  Stream<List<MesajModel>> getMesaj(aa) {
    if (a == 1) {
      print("get mesaj");
      var snapShot = FirebaseFirestore.instance
          .collection("--adreseMesaj")
          .doc(widget.mesajAdres)
          .collection("1")
          .orderBy("date", descending: true)
          .limit(kk)
          .snapshots();

      // print("snapShot.length" + snapShot.toList().toString() + "--------");

      var mesajlar =
          snapShot.map((mesajListesi) => mesajListesi.docs.map((mesaj) {
                //  print(mesaj.id.runtimeType.+"bbbbbbbb");

                return MesajModel.mapNesne(mesaj.data(), mesaj.id);
              }).toList());
      print("veri abani ilkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      temp = mesajlar;
      a = a + 1;
      print("++++++" + mesajlar.first.toString());
      degis = false;
      return mesajlar;
    } else {
      print("get mesaj");
      var snapShot = FirebaseFirestore.instance
          .collection("--adreseMesaj")
          .doc(widget.mesajAdres)
          .collection("1")
          .orderBy("date", descending: true)
          .limit(kk)
          .startAfter([_tumMesajlar.last.date]).snapshots();

      var mesajlar = snapShot.map((mesajListesi) => mesajListesi.docs
          .map((mesaj) => MesajModel.mapNesne(mesaj.data(), mesaj.id))
          .toList());

      print("veri abani okundu ussssssssssssssssssssssssssssssssssssssssss");

      mesajlar.listen((event) {
        //  if(_scrollController.offset >=
        //      _scrollController.position.maxScrollExtent)
        _tumMesajlar.addAll(event);
      });

      print("lllllllllllll" + _tumMesajlar.length.toString());

      a = a + 1;
      degis = false;
      ilkAltaVurmayiEngelle = true;
      // mmmm().listen((event) { });
      return mmmm();
    }
  }

  Stream<List<MesajModel>> mmmm() async* {
    yield _tumMesajlar;
  }

  void _ikinciMesaj() {
    //kk=kk+1;
    getMesaj(kk);
    sayfaProvideri?.gosterme();
    setState(() {});
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  List<String> _saatDakikaGosterBildirim(Timestamp date) {
    List<String> zaman = [];
    var _formatter = DateFormat
        .y(); //DateFormat.H();           //DateFormat.d() ;                 // DateFormat.M();                             //DateFormat.y();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    zaman.add(_formatlanmisTarih);
    _formatter = DateFormat.M();
    _formatlanmisTarih = _formatter.format(date.toDate());
    zaman.add(_formatlanmisTarih);
    _formatter = DateFormat.d();
    _formatlanmisTarih = _formatter.format(date.toDate());
    zaman.add(_formatlanmisTarih);
    _formatter = DateFormat.H();
    _formatlanmisTarih = _formatter.format(date.toDate());
    zaman.add(_formatlanmisTarih);
    _formatter = DateFormat.m();
    _formatlanmisTarih = _formatter.format(date.toDate());
    zaman.add(_formatlanmisTarih);

    return zaman;
  }
  //     leading: NetworkImage(_tumMesajlar[index].)

  Stream<List<MesajModel>>? _sonuc() {
    print("get mesaj");
    if (a == 1 && degis == false) {
      return getMesaj(10);
    } else if (a > 1 && degis == false) {
      return mmmm();
    } else if (degis == true) {
      return _alt();
    }
  }

  Stream<List<MesajModel>> _alt() {
    print("get mesaj");
    degis = true;
    var snapShot = FirebaseFirestore.instance
        .collection("--adreseMesaj")
        .doc(widget.mesajAdres)
        .collection("1")
        .orderBy("date", descending: true)
        .limit(kk)
        .snapshots();

    var mesajlar = snapShot.map((mesajListesi) => mesajListesi.docs
        .map((mesaj) => MesajModel.mapNesne(mesaj.data(), mesaj.id))
        .toList());
    print("veri abani okundu");

    return mesajlar;
  }

  void _alt2() {
    _alt();
    setState(() {});
  }

  int birKereYap = 0;
  Future<void> _scrollListener() async {
    //

    if (_scrollController!.offset >=
        _scrollController!.position.maxScrollExtent) {
      buildKontrol = true;
      sayfaProvideri?.goster();

      //_isLoading = true;
      _ikinciMesaj();
      await Future.delayed(Duration(seconds: 1));

      sayfaProvideri?.gosterme();
      print("_scrollController-*-*-*-*-*-*-*usssssss");
    } else if (_scrollController!.offset <=
            _scrollController!.position.minScrollExtent &&
        ilkAltaVurmayiEngelle) {
      buildKontrol = true;
      _alt2();
      ilkAltaVurmayiEngelle = false;
      print("_scrollController-*-*-*-*-*-*-*alllllllllll");
    }

    sayfaProvideri?.scrollListenerWithItemHeight(_scrollController!);

    //   sayfaProvideri.firstVisibleItemIndex  SCROLLL SAYILARI  SCROLLL HANGİ İNDEXTE
  }
  /*
   
  */

  kisiBilgileri(potoUrl, userName, zaman, userid, unicUserName,index) {
    return Row(children: <Widget>[
     
      //Text(son),
      if (userName == null)
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        )
      else
        Expanded(
          child: Container(
             
            width: boy! / 14,
            height: boy! / 18,
            decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.0))),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
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
                                      "assets/images/notification.png",
                                      false,
                                      "",
                                      "",
                                      1,
                                      1,
                                      "",
                                      "",
                                      -1,
                                      Colors.red),
                                  child: ProfilSyfasi(
                                    userName,
                                    userid,
                                    benimUid,
                                    potoUrl,
                                    unicUserName,
                                  ),
                                )));
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                       Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              border:
                                  Border.all(color: Colors.black.withOpacity(0.2)),
                              //borderRadius: BorderRadius.circular(widget.en / 16),  //  20  px
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0, left: en! / 64, right: en! / 64),
                                child: Text(
                                  userName,
                                  textScaleFactor: 0.7,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                       Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                    top: 1, left: 1, right: 0),
                            child: Text(
                              "@" + unicUserName,
                              textScaleFactor: 0.6,
                              style: TextStyle(
                                color: Color.fromARGB(255, 174, 153, 90),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        
        

        

      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(
          zaman,
          textScaleFactor: 0.6,
          //  style: GoogleFonts.itim(
          //     fontSize: 10, letterSpacing: 2.5, color: Colors.black),
        ),
      ),
    ]);
  }

  

  resimDondur(String potoUrl) {
    return Image.network(
      potoUrl,
      width: boy! / 14,
      height: boy! / 14,
      fit: BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        );
      },
      loadingBuilder:
          (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          );
        }
      },
    );
  }
}

class MyRow extends StatelessWidget {
  double en;
  double boy;
  int hangiChip;
  MyRow(this.en, this.boy, this.hangiChip);
  var _mesajController = TextEditingController();
  Widget build(BuildContext context) {
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: true);
    print("2. build mmmmmmm");
    print(hangiChip.toString() + ":  hangi chipppppp");

    FirebaseAuth _auth = FirebaseAuth.instance;
    //var sayfaProvideri =
    //    Provider.of<AdreseMesajProvider>(context, listen: true);

    return Container(
      width: en,
      height: boy / 10,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(
                en / 13) //  25  px                <--- border radius here
            ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: en / 30),
              child: TextField(
                controller: _mesajController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0)),
                  ),
                  hintText: "write message",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0)),
                    borderRadius: BorderRadius.all(Radius.circular(en / 64)),
                  ),
                ),
              ),
            ),
          ),
          MesajCubuguNotification(),
          Padding(
            padding: EdgeInsets.only(right: en / 25),
            child: Container(
              child: InkWell(
                onTap: () async {
                  if (_mesajController.text.trim().length > 0) {
                    MesajModel _kaydedilecekMesaj = MesajModel(
                        _mesajController.text,
                        Timestamp (0,0),
                        _auth.currentUser!.uid,
                        sayfaProvideriBen.userName,
                        sayfaProvideriBen.photoUrl,
                        sayfaProvideriBen.unicUserName);
                    _mesajController.clear();
                    await saveMessage(
                        _kaydedilecekMesaj.nesneMap(), _auth.currentUser?.uid);
                  }
                },
                child: Image.asset(
                  "assets/images/up.png",
                  width: en / 10,
                 // height: en / 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //////  KENAR BOSLUKLARI AYARLANIR

    /*
              
              */
  }

  saveMessage(_kaydedilecekMesaj, uid) async {
    bidirimGonder(_kaydedilecekMesaj, uid);
    var veritabani = FirebaseFirestore.instance;

    await veritabani
        .collection("--adreseMesaj")
        .doc(globalMesajAdres)
        .collection("1")
        .doc()
        .set(_kaydedilecekMesaj);
    if (tumMesajSayisi <= 1)
      bidirimGonder(_kaydedilecekMesaj, uid);
    else {
      hangiAdresegidecek(_kaydedilecekMesaj, uid);
      print("mmmmmmmmesaj yokkk");
    }
  }

  hangiAdresegidecek(_kaydedilecekMesaj, uid) {
    print("hangiAdresegidecek  --------------------");
    if (hangiChip == 1) {
      bildirimGonderilsinMi(_kaydedilecekMesaj, uid, 60); //il
    } else if (hangiChip == 2) {
      bildirimGonderilsinMi(_kaydedilecekMesaj, uid, 60); // ilçe
    } else if (hangiChip == 3) {
      bildirimGonderilsinMi(_kaydedilecekMesaj, uid, 30); // mahalle
    } else if (hangiChip == 4) {
      bildirimGonderilsinMi(_kaydedilecekMesaj, uid, 15); // sokak
    }
  }

  bildirimGonderilsinMi(_kaydedilecekMesaj, uid, int dakikaSonra) {
    print(bildirimIcinSonMesaj.toString() + "   bildirim icin son mesaj");
    DateTime _now = DateTime.now();
    DateTime sonMesajZamani = DateTime(
        int.parse(bildirimIcinSonMesaj[0]),
        int.parse(bildirimIcinSonMesaj[1]),
        int.parse(bildirimIcinSonMesaj[2]),
        int.parse(bildirimIcinSonMesaj[3]),
        int.parse(bildirimIcinSonMesaj[4]));
    int zamanfarki = _now.difference(sonMesajZamani).inMinutes;
    print(zamanfarki.toString() + "    zaman farkiii");
    if (zamanfarki > dakikaSonra) {
      print(zamanfarki.toString() + "qqqqqqqqqqqqqqqqqqqq");
      print(dakikaSonra.toString() + "qqqqqqqqqqqqqqqqqqqq");

      bidirimGonder(_kaydedilecekMesaj, uid);
    } else {
      var rng = new Random();
      //int rastgele=rng.nextInt((dakikaSonra+5));
      //  print(rastgele.toString()+ "  :  Rastgeleee"  +dakikaSonra.toString());

      if (rng.nextInt((dakikaSonra + 5)) == 5) {
        bidirimGonder(_kaydedilecekMesaj, uid);
        // print(rastgele.toString()+ "  :  Rastgeleee"  +dakikaSonra.toString());
      }
    }
  }

  bidirimGonder(_kaydedilecekMesaj, uid) {
    BildirimGondermeServisi _bildirimGondermeServisi =
        BildirimGondermeServisi();
    print("-- global Adressss  : " + globalMesajAdres!);
    //String tok = utf8.encode(globalMesajAdres.toString()).join();//tok
    _bildirimGondermeServisi.bildirimGonder("/topics/" + globalMesajAdres!,
        globaltopBarAdres!, _kaydedilecekMesaj["mesaj"], uid, globalMesajAdres!);
  }
}

class IkonButon extends StatefulWidget {
  double en;
  double boy;
  IkonButon(this.en, this.boy);

  @override
  _IkonButonState createState() => _IkonButonState();
}

class _IkonButonState extends State<IkonButon> {
  NotificationHandler _notificationHandler = NotificationHandler();
  DatabaseHelper _db1 = DatabaseHelper();
  Color ikonButonRenk = Colors.white;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    sayfaProvideri?.ikonRenkDegisBaslangic(
        globalMesajAdres!, _auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    var sayfaProvideri =
        Provider.of<AdreseMesajProvider>(context, listen: true);
    return sayfaProvideri.iconButonYukleniyor
        ? ikonDondur()
        : CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          );
  }

  ikonDondur() {
    return Padding(
      padding: EdgeInsets.only(right: widget.en / 20),
      child: Container(
        width: widget.en / 9,
        height: widget.en / 9,
        child: InkWell(
          onTap: () {
            var k = widget.en / 15;
            print(k);
            sayfaProvideri?.ikonRenkDegis(
                sayfaProvideri?.ikonButonRenk, globalMesajAdres);
            if (sayfaProvideri?.ikonButonRenk == Colors.yellow) {
              if (globalMesajAdres != "" && globalMesajAdres != null) {
                //  _tokenUtf8 = utf8.encode(globalMesajAdres.toString()).join();
                _notificationHandler.fcm.subscribeToTopic(globalMesajAdres!);

                //print(_tokenUtf8 + "---");
                print(globalMesajAdres.toString() + " eklenen adres");
                _db1.yerEkleToken(globalMesajAdres!, _auth.currentUser!.uid);
                // _db1.yerOku(sayfaProvideri.tamAdres);
              }
            } else if (sayfaProvideri?.ikonButonRenk == Colors.white) {
              if (globalMesajAdres != "" && globalMesajAdres != null) {
                //  _tokenUtf8 = utf8.encode(globalMesajAdres.toString()).join();
                _notificationHandler.fcm.unsubscribeFromTopic(globalMesajAdres!);
                _db1.yerSilToken(globalMesajAdres!, _auth.currentUser!.uid);
                //print(_tokenUtf8 + "---");
                //_db1.yerEkle(globalMesajAdres);
                // _db1.yerOku(sayfaProvideri.tamAdres);
              }
            }
          },
          child: Image.asset(
            sayfaProvideri!.ikonButonAdres,
            
            //  color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FadeTransitionDemo extends StatefulWidget {
  double en;
  double boy;
  String benimUid;
  String mesajId;
  String userid;
  List<MesajModel> _tumMesajlar;
  int index;
  String mesajAdres;

  FadeTransitionDemo(this.benimUid, this.mesajId, this.userid,
      this._tumMesajlar, this.index, this.mesajAdres, this.en, this.boy);

  FadeTransitionDemoState createState() => FadeTransitionDemoState();
}

class FadeTransitionDemoState extends State<FadeTransitionDemo>
    with TickerProviderStateMixin {
  var veritabani = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  //AnimationController controller;
  late AnimationController fadecontroller;
  late Animation<double> _animation;
  late int sayac;
  late int sikayetSayac;
  initState() {
    super.initState();
    sayac = 0;
    sikayetSayac = 0;
    fadecontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0, end: 1),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 1, end: 0),
          weight: 50,
        ),
      ],
    ).animate(fadecontroller);
  }

  @override
  void dispose() {
    fadecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*
          FadeTransition(
            opacity: _animation,
            child: Text(
              "Flutter Dev's",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),*/
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              /*
              InkWell(
                onTap: () {
                  if (sayac == 0) {
                    veritabani
                        .collection(globalMesajAdres)
                        .doc(widget.mesajId)
                        .collection("begenenler")
                        .doc(widget.benimUid)
                        .get()
                        .then((value) {
                      print(value.exists.toString());
                      if (!value.exists) {
                        veritabani
                            .collection(globalMesajAdres)
                            .doc(widget.mesajId)
                            .collection("begenenler")
                            .doc(widget.benimUid)
                            .set({});
                        print("begenilenlere eklendi !!");
                        veritabani
                            .runTransaction((Transaction transaction) async {
                          DocumentReference docRef = veritabani
                              .collection("--users")
                              .doc(widget.userid);
                          transaction.update(docRef,
                              {"begeniSayisi": FieldValue.increment(1)});
                          print("begeni artti");
                        });
                      }
                    });
                  }

                  if (sayac % 2 == 0)
                    fadecontroller.forward();
                  else
                    fadecontroller.reverse();
                  sayac++;
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: widget.en / 64, top: widget.boy / 115),
                  child: Text(
                    "Begen",
                    textScaleFactor: 0.6,
                  ),
                ),
              ), */
              Padding(
                  child: _yorumButton(widget.index),
                  padding: EdgeInsets.only(
                      left: widget.en / 64+2, top: widget.boy / 115)),
              Padding(
                  child: _silButton(widget.index),
                  padding: EdgeInsets.only(
                      left: widget.en / 32, top: widget.boy / 115)),
              Padding(
                  child: _sikayetButton(widget.index),
                  padding: EdgeInsets.only(
                      left: widget.en / 32, top: widget.boy / 115)),
            ],
          ),
        ),
      ],
    );
  }

  _sikayetButton(index) {
    if (widget._tumMesajlar[index].userID != _auth.currentUser?.uid) {
      return InkWell(
        onTap: () {
          if (sikayetSayac == 0) {
            FirebaseFirestore.instance.collection("--Sikayetler").doc().set({
              "sikayetci": _auth.currentUser?.uid,
              "suclu": widget._tumMesajlar[index].userID,
              "mesaj": widget._tumMesajlar[index].mesaj,
            });
            sikayetSayac++;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "complain",
            textScaleFactor: 0.64,
          ),
        ),
      );
    } else
      return Text("");
  }

  _silButton(index) {
    if (widget._tumMesajlar[index].userID == _auth.currentUser?.uid) {
      return InkWell(
        onTap: () {
          FirebaseFirestore.instance
              .collection("--adreseMesaj")
              .doc(widget.mesajAdres)
              .collection("1")
              .doc(widget._tumMesajlar[index].mesajId)
              .delete();
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "delete",
            textScaleFactor: 0.64,
          ),
        ),
      );
    } else
      return Text("");
  }

  _yorumButton(index) {
    if (widget._tumMesajlar[index].yorumVarmi == true)
      return InkWell(
        onTap: () {
          _yorumSayfasinaGit(index);
        },
        child: Container(
          color: Colors.green.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "comment",
              textScaleFactor: 0.64,
              style: TextStyle(fontWeight: FontWeight.bold),
              
            ),
          ),
        ),
      );
    else
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              _yorumSayfasinaGit(index);
            },
            child: Text(
              "comment",
              textScaleFactor: 0.64,
            ),
          ),
        ),
      );
  }

  void _yorumSayfasinaGit(int index) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
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
                "",
                false,
                widget._tumMesajlar[index].mesajId,
                widget._tumMesajlar[index].mesaj,
                1,
                1,
                "",
                "",
                0,
                Colors.red),
          ),
          ChangeNotifierProvider<NotificationHandler>.value(
            value: NotificationHandler(),
          ),
        ],
        child: YorumSayfasi(widget.mesajId, widget.mesajAdres,
            widget._tumMesajlar[index].mesaj, widget.en, widget.boy,globaltopBarAdres!),
      ),
    ));
  }
}
