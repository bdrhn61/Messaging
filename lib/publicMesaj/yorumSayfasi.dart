import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:space/BildirimGonderme/bidirimGondermeServis.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/Profil/profilSayfasi.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';

import '../models/publicMesajModel.dart';

late AdreseMesajProvider sayfaProvideri;
late String globalMesajAdres;
late String globaltopBarAdres;
late int _yorumVarMi;

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
class YorumSayfasi extends StatefulWidget {
  String mesajAdres;
  String mesajId;

  String topBarAdres;
  double en;
  double boy;
  String yorumunGonderilecegiSayfaninTopBarAdresi;

  YorumSayfasi(
      this.mesajId, this.mesajAdres, this.topBarAdres, this.en, this.boy,this.yorumunGonderilecegiSayfaninTopBarAdresi);
  @override
  YorumSayfasiState createState() => YorumSayfasiState();
}

late ScrollController _scrollController;

class YorumSayfasiState extends State<YorumSayfasi>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var veritabani = FirebaseFirestore.instance;
  var pageCon = PageController(initialPage: 1);
  late String benimUid;
  late String anonimMiUserName;

  var sayfaProvideri2;
  late Ben sayfaProvideriBen;
  @override
  void initState() {
    benimUid = _auth.currentUser!.uid;
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    sayfaProvideriBen.capaRengiDegissinmiAta(widget.topBarAdres);
    globalMesajAdres = widget.mesajAdres;
    globaltopBarAdres = widget.topBarAdres;
    print("adrese mesaj init -*********************-**-*-*");
    print(widget.mesajId.toString());
    //getMesaj(10);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    //_scrollListener
    ilkAltaVurmayiEngelle = false;
    sayfaProvideri2 = Provider.of<NotificationHandler>(context, listen: false);

    sayfaProvideri2.defaultRenkAta();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget build(BuildContext context) {
    //boy=MediaQuery.of(context).size.height;
    //en=MediaQuery.of(context).size.width;
    sayfaProvideri = Provider.of<AdreseMesajProvider>(context, listen: false);

    print("adrese mesaj build");
    print(widget.en); //   boy 569   en 320
    print(
        "1. build mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    return Container(
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.en / 21),
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: widget.boy / 14,
            automaticallyImplyLeading: false,

            title: Text(
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
          ),
          floatingActionButton: sayfaProvideri.elemanlarYukleniyor(),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          backgroundColor: Colors.black,

          // resizeToAvoidBottomPadding: true,
          body: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.en / 21), //  15  px
                bottomRight: Radius.circular(widget.en / 21)),
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _mesajListesiniOlustur(),
                  MyRow(widget.en, widget.boy, widget.mesajId,widget.yorumunGonderilecegiSayfaninTopBarAdresi,_tumMesajlar),
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
            _yorumVarMi = _tumMesajlar.length;
            if (_tumMesajlar.length == 0) {
              return Center(
                child: Text(
                  "no message",
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
                    var _saatDakikaDegeri = "";
                    try {
                      _saatDakikaDegeri = _saatDakikaGoster(
                          _tumMesajlar[index].date ?? Timestamp(1, 1));
                    } catch (e) {
                      print("errr  : " + e.toString());
                    }
                    print("list build");

                    anonimMiUserName =
                        _tumMesajlar[index].unicUserName == null ||
                                _tumMesajlar[index].unicUserName == ""
                            ? "anonymous"
                            : _tumMesajlar[index].unicUserName;

                    // log(_scrollController.initialScrollOffset.toString());
                    //log(_scrollController.position.isScrollingNotifier.toString());

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.en / 64),
                            child: Wrap(direction: Axis.vertical, children: [
                              InkWell(
                                onTap: (){
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
                                    _tumMesajlar[index].userName,
                                    _tumMesajlar[index].userID,
                                    benimUid,
                                    _tumMesajlar[index].potoUrl,
                                    _tumMesajlar[index].unicUserName,
                                  ),
                                )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.2)),
                                    //borderRadius: BorderRadius.circular(widget.en / 16),  //  20  px
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(2), //  5  px
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 0,
                                          left: widget.en / 64,
                                          right: widget.en / 64),
                                      child: Text(
                                        _tumMesajlar[index].userName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ), //_saatDakikaDegeri

                                      // KullaniciBilgileri(userid, _saatDakikaDegeri,_tumMesajlar[index].userName,_tumMesajlar[index].potoUrl),
                                    ),

                                    //color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.en / 64 + widget.en / 64,
                                    top: 2),
                                child: Text(
                                  "@" + anonimMiUserName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 174, 153, 90),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(widget.boy / 113),
                          child: Text(_tumMesajlar[index].mesaj),
                        ),
                      ],
                    );
                  },
                ),
                Capa2(),
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
          .collection(widget.mesajId)
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
          .collection(widget.mesajId)
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
    sayfaProvideri.gosterme();
    setState(() {});
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
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
    return null;
  }

  Stream<List<MesajModel>> _alt() {
    print("get mesaj");
    degis = true;
    var snapShot = FirebaseFirestore.instance
        .collection("--adreseMesaj")
        .doc(widget.mesajAdres)
        .collection(widget.mesajId)
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

    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      sayfaProvideri.goster();

      //_isLoading = true;
      _ikinciMesaj();
      await Future.delayed(Duration(seconds: 1));

      sayfaProvideri.gosterme();
      print("_scrollController-*-*-*-*-*-*-*usssssss");
    } else if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        ilkAltaVurmayiEngelle) {
      _alt2();
      ilkAltaVurmayiEngelle = false;
      print("_scrollController-*-*-*-*-*-*-*alllllllllll");
    }

    sayfaProvideri.scrollListenerWithItemHeight(_scrollController);

    //   sayfaProvideri.firstVisibleItemIndex  SCROLLL SAYILARI  SCROLLL HANGİ İNDEXTE
  }
}

class MyRow extends StatelessWidget {
  double en;
  double boy;
  String mesajid;
  String _yorumunGonderilecegiSayfaninTopBarAdresi;
  List<MesajModel> _tumMesajlar;
  MyRow(this.en, this.boy, this.mesajid,this._yorumunGonderilecegiSayfaninTopBarAdresi,this._tumMesajlar);
  var _mesajController = TextEditingController();
   final fbReal = FirebaseDatabase.instance;
  Widget build(BuildContext context) {
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: true);
    print("2. build mmmmmmm");

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
          Padding(
            padding: EdgeInsets.only(right: en / 20),
            child: InkWell(
              onTap: () async {

                print("wwwwwwwwwwwwwwwwww");
                print(_tumMesajlar[1].userID);
               //  final ref = fbReal.reference();
               // DataSnapshot _sonuc = await ref.child("token").child(_onunUid).once();

/*
                if (_mesajController.text.trim().length > 0) {
                  MesajModel _kaydedilecekMesaj = MesajModel(
                      _mesajController.text,
                      null,
                      _auth.currentUser.uid,
                      sayfaProvideriBen.userName,
                      sayfaProvideriBen.photoUrl,
                      sayfaProvideriBen.unicUserName);
                  _mesajController.clear();
                  await saveMessage(
                      _kaydedilecekMesaj.nesneMap(), _auth.currentUser.uid);

                      bidirimGonder(_kaydedilecekMesaj.nesneMap(), _auth.currentUser.uid); 
                }
                */
              },
              child: Image.asset(
                "assets/images/up.png",
                width: en / 10,
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
    var veritabani = FirebaseFirestore.instance;

    await veritabani // --mesajAdres   globaladres   mesajid
        .collection("--adreseMesaj")
        .doc(globalMesajAdres)
        .collection(mesajid)
        .doc()

        //  .collection(globalMesajAdres)
        //   .doc(mesajid)
        //  .collection("Yorumlar")
        //  .doc()
        .set(_kaydedilecekMesaj);
    print(_yorumVarMi.toString() + "--");
    if (_yorumVarMi == 0 || _yorumVarMi == 1) {
      print("ilk yorum yapıldı");
      veritabani
          .collection("--adreseMesaj")
          .doc(globalMesajAdres)
          .collection("1")
          .doc(mesajid)
          .set({"yorumVarMi": true}, SetOptions(merge: true));
    }

    //String tok = utf8.encode(globalMesajAdres.toString()).join();//tok
    //   _bildirimGondermeServisi.bildirimGonder("/topics/" + globalMesajAdres,
    //      globaltopBarAdres, _kaydedilecekMesaj["mesaj"], uid);
  }

  void bidirimGonder( _kaydedilecekMesaj, uid) {

    
    BildirimGondermeServisi _bildirimGondermeServisi =
        BildirimGondermeServisi();
    print("-- global Adressss  : " + globalMesajAdres);
    //String tok = utf8.encode(globalMesajAdres.toString()).join();//tok
    _bildirimGondermeServisi.bildirimGonder("/topics/" + globalMesajAdres,
     _yorumunGonderilecegiSayfaninTopBarAdresi.toString()+" : "+ globaltopBarAdres, _kaydedilecekMesaj["mesaj"], uid, globalMesajAdres);
  
  }
}

class Capa2 extends StatelessWidget {
 

  Widget build(BuildContext context) {
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: true);

    sayfaProvideriBen.buildEtmeAta(null);

    print("capaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    var sayfaProvideri =
        Provider.of<AdreseMesajProvider>(context, listen: true);
    var sayfaProvideri2 =
        Provider.of<NotificationHandler>(context, listen: true);

    return Opacity(
        opacity: sayfaProvideri.mesajGeldimi ? 1 : 0,
        child: sayfaProvideri.mesajGeldimi
            ?

            /// RESPONSİV YAP
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: sayfaProvideri2.mesajGeldimi
                      ? Colors.green
                      : Colors.red, //sayfaProvideri.rek, //Colors.red ,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    _scrollController.animateTo(0,
                        duration: Duration(seconds: 2),
                        curve: Curves.decelerate);
                    //_scrollController.jumpTo(0);
                    //  _notificationHandler.fcm.unsubscribeFromTopic("rize");
                    //print("aaaaaaaa");
                  },
                ),
              )
            : null);
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
  initState() {
    super.initState();
    sayac = 0;
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
        onTap: () {},
        child: Text(
          "Şikayet et",
          textScaleFactor: 0.6,
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
              .collection(widget.mesajAdres)
              .doc(widget._tumMesajlar[index].mesajId)
              .delete();
        },
        child: Text(
          "Sil",
          textScaleFactor: 0.6,
        ),
      );
    } else
      return Text("");
  }
}
