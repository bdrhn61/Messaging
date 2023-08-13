import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/BildirimGonderme/bidirimGondermeServis.dart';
import 'package:space/Key/keyStore.dart';
import 'package:space/Profil/privateProvider.dart';
import 'package:space/models/Ben.dart';

late String _benimUid;
late String _onunUid;
int _mesajSayisi = 0;
late Map<String, dynamic> _resltData;
List _mesajListesi = [];
var _mesajinUidsi = [];
var _mesajList1 = [];
var _pub;
var _pub2;

late int _kacinciMesaj;
late SharedPreferences _prefsMesenger;
FirebaseAuth _auth = FirebaseAuth.instance;
late RsaKeyHelper _helperMessenger;
bool _publicKeyYazilsinmi = false;
late String _onunKey;
late String _benimKey;
Map<String, String> _dahaOnceAlinmisToken={"":""};

class MessengerMesaj extends StatelessWidget {
  String _benimUserId;
  String _mesajGonderilecekUserId;
  String _mesajGonderilecekIsim;
  String onunPhotoUrl;
  String _mesajAdres;
  int _nerdenGeliyon;

  MessengerMesaj(
      this._mesajGonderilecekUserId,
      this._benimUserId,
      this.onunPhotoUrl,
      this._mesajAdres,
      this._nerdenGeliyon,
      this._mesajGonderilecekIsim);

  @override
  Widget build(BuildContext context) {
    print(
        "Messenger mesaj   buildddd  ----------------------------------------------------------------");
    double boy = MediaQuery.of(context).size.height;
    _benimUid = _benimUserId;
    _onunUid = _mesajGonderilecekUserId;
    return Container(
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(boy / 38)),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              elevation: 0,
              title: Text(
                _mesajGonderilecekIsim,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: Column(
              children: [
                //  Text(_mesajGonderilecekIsim),
                StreamDondur(
                  _mesajAdres,
                  _nerdenGeliyon,
                  _mesajGonderilecekIsim,
                ),
                KutuMesaj(onunPhotoUrl, _nerdenGeliyon, _mesajAdres,
                    _mesajGonderilecekIsim),
              ],
            )),
      ),
    );
  }
}

class StreamDondur extends StatefulWidget {
  String mesajAdres;
  int _nerdenGeliyon;
  String _mesajGonderilecekIsim;

  StreamDondur(
    this.mesajAdres,
    this._nerdenGeliyon,
    this._mesajGonderilecekIsim,
  );
  @override
  _StreamDondurState createState() => _StreamDondurState();
}

late Map<dynamic, dynamic> donenMap;

class _StreamDondurState extends State<StreamDondur> {
late   PrivateProvider _sayfaProvideri;
late   double boy;
late  double en;
  int sayac = 0;
late  String privateKey;
  var _pubb;

  @override
  void initState() {
    _mesajSayisi = 0;
    _kacinciMesaj = 0;
    //_sayfaProvideri.setMesajGonderilecekIsim(widget._mesajGonderilecekIsim);

    WidgetsBinding.instance.addPostFrameCallback((_) => yourFunction(context));

    super.initState();
  }

  yourFunction(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('--mesajlar')
        .doc(_benimUid + "--" + _onunUid)
        .get()
        .then((value) {
      if (value.data() != null) {
        print(_onunUid + "111");
        _sayfaProvideri.setMesajGonderilecekAdres(_benimUid + "--" + _onunUid);
      } else {
        print(_onunUid + "222");

        _sayfaProvideri.setMesajGonderilecekAdres(_onunUid + "--" + _benimUid);
      }
    });
    _prefsMesenger = await SharedPreferences.getInstance();
    _helperMessenger = RsaKeyHelper();
    privateKey = _prefsMesenger.getString(_auth.currentUser!.uid + "private")!;
    _pubb = _helperMessenger.parsePrivateKeyFromPem(privateKey);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Stream messenger   buildddd  ----------------------------------------------------------------");
    _sayfaProvideri = Provider.of<PrivateProvider>(context, listen: true);
    double boy = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;

    Color _renk = Colors.red;

    return Expanded(
      child: Column(children: [
        // ustBar(en),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('--mesajlar')
                .doc(_sayfaProvideri.mesajGonderilecekAdres)
                .snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              }

              DocumentSnapshot result = snapshot.data;

              if (result.data() != null) {
                keyYazilsinmi(result.data());
                Map<String, dynamic> veri = result.data();
                veri.removeWhere((key, value) => key == _onunUid);
                veri.removeWhere((key, value) => key == _auth.currentUser.uid);
                _resltData = veri;
                List aa = [];
                aa = veri.keys.toList()..sort();
                print("1");
                print(veri[_onunUid]);

                if (aa.length != 0) if (veri[aa[aa.length - 1]]["date"] !=
                    null) {
                  print("3");

                  _mesajListesi = saatSirala(
                      veri.values.toList(), veri, veri.keys.toList());
                  print("tttt  " + veri.toString());

                  _mesajSayisi = _mesajListesi.length;
                }
                String gosterilecekMesaj = "";
                Alignment sagSol= Alignment.centerLeft;
                return ListView.builder(
                  reverse: true,
                  itemCount: _mesajListesi.length,
                  itemBuilder: (context, index) {
                    if (_mesajinUidsi[_mesajinUidsi.length - index - 1]
                            .toString() ==
                        _benimUid) {
                      _renk = Colors.black;
                      sagSol=Alignment.centerLeft;
                      gosterilecekMesaj = decrypt(
                          _mesajListesi[_mesajListesi.length - index - 1]
                              .toString(),
                          _pubb);
                    } else {
                      gosterilecekMesaj = decrypt(
                          _mesajList1[_mesajListesi.length - index - 1]
                              .toString(),
                          _pubb);
                          sagSol=Alignment.centerRight;

                      _renk = Color.fromARGB(255, 174, 153, 90);
                    }

                    return  Container(
                      
                          child: Wrap(
                            children: [
                              Align(
                                alignment: sagSol,
                                child: Container(
                                  
                                  padding: EdgeInsets.only(left: en/22, right: en/22),
                                  decoration: BoxDecoration(
                                    
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(
                                            en/22) //                 <--- border radius here
                                        ),
                                  ),
                                  child: Text(
                                    gosterilecekMesaj,
                                    style: GoogleFonts.montserrat(
                                        fontSize: en/21,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: _renk),
                                  ),
                                ),
                              ),
                              Container(height: en/22,)
                            ],
                          ),
                        
                     
                    );
                  },
                );
              } else {
                return Center(child: Text(""));
              }
            },
          ),
        ),
      ]),
    );
  }

  ustBar(double en) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        Text(
          widget._mesajGonderilecekIsim,
          style: TextStyle(fontSize: en / 16),
        ),
      ],
    );
  }

  List saatSirala(
      var list, Map<String, dynamic> resultData, List<String> keyList) {
    Map<String, dynamic> topluYaz = {};
    var zaman = [];
    var mesajList = [];
    _mesajList1 =[];
    _mesajinUidsi = [];
    for (int i = 0; i < list.length; i++) zaman.add(list[i]["date"]);
//print(zaman.toString()+"  ------------");
    var temp = zaman..sort();

    //  print(keyList.toString() + "  ***********");
    for (int j = 0; j < temp.length; j++) {
      for (int i = 0; i < keyList.length; i++) {
        if (resultData[keyList[i]]["date"] == temp[j]) {
          // print(resultData[keyList[i]]["mesaj"].toString());
          mesajList.add(resultData[keyList[i]]["mesaj"].toString());
          _mesajList1.add(resultData[keyList[i]]["mesaj1"].toString());

          _mesajinUidsi.add(resultData[keyList[i]]["_benimUid"].toString());
          topluYaz[keyList[i]] = resultData[keyList[i]];

          break;
        }
      }
    }
    // print(mesajList.toString() + "   wwwwwww");
    return mesajList;
  }

  String _okunacakAdres() {
    if (widget._nerdenGeliyon == 1)
      return widget.mesajAdres;
    else if (_sayfaProvideri.mesajGonderilecekAdres == null)
      return _onunUid + "--" + _benimUid;
    else
      return _sayfaProvideri.mesajGonderilecekAdres;
  }

  void keyYazilsinmi(Map<String, dynamic> data) {
    if (data[_auth.currentUser.uid] == null ||
        data[_auth.currentUser.uid] == "") {
      _publicKeyYazilsinmi = true;
      print("true çalıştı");
    } else {
      _benimKey = data[_auth.currentUser.uid].toString();
      _onunKey = data[_onunUid].toString();
      _publicKeyYazilsinmi = false;
      print("false çalıştı");
      _pub = _helperMessenger.parsePublicKeyFromPem(_benimKey);
      _pub2 = _helperMessenger.parsePublicKeyFromPem(_onunKey);
    }
  }
}

class KutuMesaj extends StatelessWidget {
  String _onunPhotoUrl;
  int _nerdenGeliyon;
  String mesajAdres;
  String mesajGonderlecekIsim;

  KutuMesaj(this._onunPhotoUrl, this._nerdenGeliyon, this.mesajAdres,
      this.mesajGonderlecekIsim);

  var _mesajController = TextEditingController();
  PrivateProvider _sayfaProvideri;
  Ben _sayfaProvideriBen;
  double en;
  double boy;
  BildirimGondermeServisi _bildirimGondermeServisi = BildirimGondermeServisi();
  final fbReal = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    print(
        "Kutu Messenger    buildddd  ----------------------------------------------------------------");

    boy = MediaQuery.of(context).size.height;
    en = MediaQuery.of(context).size.width;
    _sayfaProvideri = Provider.of<PrivateProvider>(context, listen: false);
    _sayfaProvideriBen = Provider.of<Ben>(context, listen: true);

    final double _boy = MediaQuery.of(context).size.height;
    return _mesajKutusuDondur(_boy);
  }

  _mesajKutusuDondur(double _boy) {
    return Container(
      width: en,
      height: boy / 10,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(
            Radius.circular(25) //                 <--- border radius here
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: en / 20),
            child: InkWell(
              onTap: () async {
                if (_mesajController.text.trim().length > 0) {
                  String mesaj = _mesajController.text.trim();
                  _mesajController.clear();
                  _mesajYaz(mesaj);
                }
              },
              child: Image.asset(
                "assets/images/up.png",
                width: en / 10,
              //  height: en / 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mesajYazOrtak(
      String adres, String mesaj, var transection) async {
    Map<String, dynamic> sss = {};

    if (_mesajSayisi >= 20) {
      sss = sonBesMesajSirala(
          _resltData.values.toList(), _resltData, _resltData.keys.toList());

      sss[Timestamp.now().toDate().toString()] = {
        "mesaj": encrypt(mesaj, _pub),
        "mesaj1": encrypt(mesaj, _pub2),
        "_benimUid": _benimUid,
        "date": FieldValue.serverTimestamp()
      };
      sss[_auth.currentUser.uid]=_benimKey;
      sss[_onunUid]=_onunKey;


      print("mesaj sayisi 10 i gecti");

      await FirebaseFirestore.instance
          .collection('--mesajlar')
          .doc(adres)
          .set(sss, SetOptions(merge: false));

      _ozelBildirimGonder(mesaj,adres);
    } else {
      DocumentReference _ref =
          FirebaseFirestore.instance.doc("--mesajlar/" + adres);
      Map<String, dynamic> veri = {};
      if (_publicKeyYazilsinmi || _mesajSayisi == 0) {
        veri = await ilkYazmaIcinIkiAnahtarGetir(mesaj);
        transection.set(
            _ref,
            {
              Timestamp.now().toDate().toString(): veri,
              _auth.currentUser.uid: _benimKey,
              _onunUid: _onunKey
            },
            SetOptions(merge: true));
      } else {
        veri = veriyiSifrele(mesaj);
        transection.set(_ref, {Timestamp.now().toDate().toString(): veri},
            SetOptions(merge: true));
      }
      _ozelBildirimGonder(mesaj,adres);
    }
  }

  Future<void> _mesajYaz(String mesaj) async {
    if (_mesajSayisi == 0) {
      DocumentReference ref = FirebaseFirestore.instance
          .doc("--mesajlar/" + _onunUid + "--" + _benimUid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot value = await transaction.get(ref);
        if (value.data() == null || value.data() == {}) {
          print(value.data().toString() + "----value.data()");
          _sayfaProvideri
              .setMesajGonderilecekAdres(_benimUid + "--" + _onunUid);

          await _mesajYazOrtak(
              _sayfaProvideri.mesajGonderilecekAdres, mesaj, transaction);
          await ikiTarafadaYaz(mesaj, transaction);
        } else {
          print(value.data().toString() + "********value.data()");
          _sayfaProvideri
              .setMesajGonderilecekAdres(_onunUid + "--" + _benimUid);

          await _mesajYazOrtak(
              _sayfaProvideri.mesajGonderilecekAdres, mesaj, transaction);
          await ikiTarafadaYaz(mesaj, transaction);
        }
      });

      // _sayfaProvideri.setMesajGonderilecekAdres(_benimUid + "--" + _onunUid);
    } else {

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await _mesajYazOrtak(
            _sayfaProvideri.mesajGonderilecekAdres, mesaj, transaction);
        if (_kacinciMesaj == 0) {
          print("iki tarafa yaz çalıştı ---");
          await ikiTarafadaYaz(mesaj, transaction);
          _kacinciMesaj++;
        }
      });
    }
  }

  ikiTarafadaYaz(String mesaj, var transaction) async {
    FirebaseFirestore fire = FirebaseFirestore.instance;

    Map<String, dynamic> veri = veriyiSifrele(mesaj);

    Map<String, dynamic> banaYaz = {
      "mesajId": _benimUid + "--" + _onunUid,
      "photoUrl": _onunPhotoUrl,
      "date": FieldValue.serverTimestamp(),
      "name": mesajGonderlecekIsim,
    };
    Map<String, dynamic> onaYaz = {
      "mesajId": _benimUid + "--" + _onunUid,
      "photoUrl": _sayfaProvideriBen.photoUrl,
      "date": FieldValue.serverTimestamp(),
      "name": _sayfaProvideriBen.userName,
    };
    print("bana-ona yazmaya başlandı");

    DocumentReference _benimUidRef =
        await fire.doc("--usersMesajlar/" + _benimUid);
    DocumentReference _onunUidRef =
        await fire.doc("--usersMesajlar/" + _onunUid);

    await transaction
        .set(
          _benimUidRef,
          {
            _onunUid: banaYaz,
          },
          SetOptions(merge: true),
        )
        .set(
          _onunUidRef,
          {
            _benimUid: onaYaz,
          },
          SetOptions(merge: true),
        );

    print("bana yazıldı");

    print("ona  yazıldı");

    // _sayfaProvideri.setMesajGonderilecekAdres(_benimUid + "--" + _onunUid);

    //  Timer(Duration(seconds: 10), () {

    print("ilk mesaj kaydedildi");
  }

  Map<String, dynamic> sonBesMesajSirala(
      var list, Map<String, dynamic> resultData, List<String> keyList) {
    Map<String, dynamic> topluYaz = {};
    var zaman = [];
    var mesajList = [];
    for (int i = 0; i < list.length; i++) zaman.add(list[i]["date"]);
//print(zaman.toString()+"  ------------");
    var temp = zaman..sort();
    temp = temp.reversed.toList();

    //   print(keyList.toString() + "  ***********");
    for (int j = 0; j <= 10; j++) {
      for (int i = 0; i < keyList.length; i++) {
        if (resultData[keyList[i]]["date"] == temp[j]) {
          // print(resultData[keyList[i]]["mesaj"].toString());
          //  mesajList.add(resultData[keyList[i]]["mesaj"].toString());
          topluYaz[keyList[i]] = resultData[keyList[i]];

          break;
        }
      }
    }
    //  print(topluYaz.toString() + "   000000000000000000000000000000");
    return topluYaz;
  }

  Future<void> _ozelBildirimGonder(String mesaj,String adres) async {
    String token;
    
    if(_dahaOnceAlinmisToken.containsKey(_onunUid)){
      print("daha once alinmisss -----");
      token=_dahaOnceAlinmisToken[_onunUid]!;
    }else{
      print("daha once alinmamisss !!!!!!!!!!!");
      final ref = fbReal.reference();
      var _sonuc = await ref.child("token").child(_onunUid).once();
      if (_sonuc.snapshot.value != null) {
      token= _sonuc.snapshot.value.toString();
      _dahaOnceAlinmisToken[_onunUid]=token;
      }

    }
    
    print(token.toString() + "   sonuc");
    
      _bildirimGondermeServisi.ozelBildirimGonder(token,
          _sayfaProvideriBen.userName, mesaj, _auth.currentUser!.uid,adres,_onunPhotoUrl);
    

    //
  }

  Future<Map<String, dynamic>> ilkYazmaIcinIkiAnahtarGetir(String mesaj) async {
    _prefsMesenger = await SharedPreferences.getInstance();

    _benimKey = _prefsMesenger.getString(_auth.currentUser.uid + "public");
    KeySrore keyStore = KeySrore();
    _onunKey = await keyStore.keyGetir(_onunUid);
    _pub = _helperMessenger.parsePublicKeyFromPem(_benimKey);
    _pub2 = _helperMessenger.parsePublicKeyFromPem(_onunKey);

    Map<String, dynamic> veri = {
      "mesaj": encrypt(mesaj, _pub),
      "mesaj1": encrypt(mesaj, _pub2),
      "_benimUid": _benimUid,
      "date": FieldValue.serverTimestamp()
    };

    return veri;
  }

  Map<String, dynamic> veriyiSifrele(String mesaj) {
    _pub = _helperMessenger.parsePublicKeyFromPem(_benimKey);
    _pub2 = _helperMessenger.parsePublicKeyFromPem(_onunKey);

    Map<String, dynamic> veri = {
      "mesaj": encrypt(mesaj, _pub),
      "mesaj1": encrypt(mesaj, _pub2),
      "_benimUid": _benimUid,
      "date": FieldValue.serverTimestamp()
    };

    return veri;
  }
}
