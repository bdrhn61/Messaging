import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space/Messenger/messengerMesaj.dart';
import 'package:space/models/Ben.dart';

import '../Profil/privateProvider.dart';

Map<String, dynamic> _resltData;
int _mesajSayisi = 0;
var _photoList = [];
var _mesajGonderilecekUidList = [];
var _anahtarListesi = [];
List _mesajListesi = [];

class Mesenger extends StatefulWidget {
  final Function onNext;
  Mesenger({this.onNext});
  @override
  _MesengerState createState() => _MesengerState();
}

class _MesengerState extends State<Mesenger> {
  var _auth = FirebaseAuth.instance;
  Ben sayfaProvideriBen;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => yourFunction(context));

    super.initState();
  }

  yourFunction(BuildContext context) async {
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);
    sayfaProvideriBen.sayfaKontrollerGir(1, context);

    /*
    await FirebaseFirestore.instance
        .collection('--usersMesajlar')
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      // print(value.data().toString() + "value.data()-*-*-*-*-*");
      if (value.data() != null) {
        var aa = value.data().values.toList();
        List sirala = [];
        //  print(aa.indexOf("tuIzVfN98nEghxDItgDZ").toString() +
        //      "   oooooooooooooooooooooooooooooooooooooooo");
        //  print(aa[0].toString() + "  *----------------------------");
        //  print(aa[0].runtimeType.toString());

        for (int i = 0; i < aa.length; i++) {
          sirala.add(aa[i][2]);
        }
        sirala = sirala..sort();
        // print(sirala.toString());
        //print(sirala.indexOf(sirala[0]));
        //print(sirala.indexOf("aqk09DkZrizqsFbvZMGo"));
      } else {
        print("bosssssss");
      }
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    double boy = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    // en/20  =16 dır
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        sayfaProvideriBen.sayfaKontrollerGir(0, null);
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(boy / 38)),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    sayfaProvideriBen.sayfaKontrollerGir(0, null);
                    Navigator.of(context).pop();
                  }),
              elevation: 0,
              title: Text(
                "Chat",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: EdgeInsets.only(left: en / 40, right: en / 40),
              child: Column(children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('--usersMesajlar')
                        .doc(_auth.currentUser.uid)
                        .snapshots(),
                    builder: (
                      context,
                      snapshot,
                    ) {
                      print(snapshot.hasData.toString() +
                          "sssss***-*-*-*-*-*-*-*-");
                      if (!snapshot.hasData) {
                        print("circular progresssssss");
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        );
                      }

                      DocumentSnapshot<Map> result = snapshot.data;

                      if (result.data() != null) {
                        _resltData = result.data();
                        print(result.data().length.toString() +
                            "  ---result.data().length");

                        List aa = [];
                        aa = result.data().keys.toList()..sort();

                        print(aa.length.toString() + "  ---aa.length");

                        if (aa.length != 0) if (result.data()[aa[aa.length - 1]]
                                ["date"] !=
                            null) {
                          print(result.data()[aa[aa.length - 1]].toString() +
                              "   wwwwwwwwwwwwwwwwwwww");
                          //print(result.data().values.toString()+"  --sortedKeys -------------");

                          //  print(sortedKeys.toString()+"  --sortedKeys -------------  " +kk.runtimeType.toString());

                          //    print(result.data().values.toList().toString()+"  --sortedKeys -------------  " +kk.runtimeType.toString());
                          //      sayac++;
                          //      if (sayac % 2 == 0) {

                          //      }
                          _mesajListesi = saatSirala(
                              result.data().values.toList(),
                              result.data(),
                              result.data().keys.toList());
                          _mesajSayisi = _mesajListesi.length;

                          if (result.data().length > 40) {
                            print("_elliGectiSirala  çalıştı   ---");
                            _elliGectiSirala(result.data().values.toList(),
                                result.data(), result.data().keys.toList());
                          }
                        }

                        return GridView.builder(
                          itemCount: _mesajListesi.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: en / 4.4,
                            crossAxisSpacing: en / 40,
                            mainAxisSpacing: en / 40,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              //color: Colors.yellow,
                              child: Wrap(
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () => {
                                        print(
                                          _anahtarListesi[_mesajListesi
                                                          .length -
                                                      index -
                                                      1]
                                                  .toString() +
                                              "  **  " +
                                              _auth.currentUser.uid +
                                              "  **  " +
                                              _photoList[_mesajListesi
                                                          .length -
                                                      index -
                                                      1]
                                                  .toString() +
                                              "  **  " +
                                              _mesajGonderilecekUidList[
                                                      _mesajListesi.length -
                                                          index -
                                                          1]
                                                  .toString() +
                                              "  **  " +
                                              _mesajListesi[
                                                      _mesajListesi.length -
                                                          index -
                                                          1]
                                                  .toString(),
                                        ),
                                        resimClick(
                                          _anahtarListesi[_mesajListesi.length -
                                                  index -
                                                  1]
                                              .toString(),
                                          _auth.currentUser.uid,
                                          _photoList[_mesajListesi.length -
                                                  index -
                                                  1]
                                              .toString(),
                                          _mesajGonderilecekUidList[
                                                  _mesajListesi.length -
                                                      index -
                                                      1]
                                              .toString(),
                                          _mesajListesi[_mesajListesi.length -
                                                  index -
                                                  1]
                                              .toString(),
                                        ),
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(en / 16), //20
                                            topRight: Radius.circular(en / 16),
                                            bottomLeft:
                                                Radius.circular(en / 16),
                                            bottomRight:
                                                Radius.circular(en / 16)),

                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(21),bottomLeft: Radius.circular(24),bottomRight: Radius.circular(21)),

                                        // borderRadius: BorderRadius.lerp(BorderRadius.circular(5), BorderRadius.circular(10), 2),
                                        child: Image.network(
                                          _photoList[_mesajListesi.length -
                                                  index -
                                                  1]
                                              .toString(),
                                          fit: BoxFit.fill,
                                          width: en / 6,
                                          height: en / 6,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.black),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        //  FOTOĞRAFIN ALTINDAKİ İSİM
                                        child: Text(
                                          _mesajListesi[_mesajListesi.length -
                                                  index -
                                                  1]
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }

  resimClick(String mesajGonderilecekUid, String benimUid, String onunPhotoUrl,
      mesajAdres, String mesajGonderilecekIsim) {
    //print( sortedKeys[sirasizList.indexOf(
    //                    siraliList[sortedValues.length - index - 1])].toString());
    print("object");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<PrivateProvider>(
                  create: (_) => PrivateProvider(),
                  child: MessengerMesaj(mesajGonderilecekUid, benimUid,
                      onunPhotoUrl, mesajAdres, 1, mesajGonderilecekIsim),
                )));
  }

  List saatSirala(
      var list, Map<String, dynamic> resultData, List<String> keyList) {
    Map<String, dynamic> topluYaz = {};
    var zaman = [];
    var mesajList = [];
    _photoList = [];
    _mesajGonderilecekUidList = [];
    _anahtarListesi = [];

    for (int i = 0; i < list.length; i++) zaman.add(list[i]["date"]);
//print(zaman.toString()+"  ------------");
    var temp = zaman..sort();

    //  print(keyList.toString() + "  ***********");
    for (int j = 0; j < temp.length; j++) {
      for (int i = 0; i < keyList.length; i++) {
        if (resultData[keyList[i]]["date"] == temp[j]) {
          // print(resultData[keyList[i]]["mesaj"].toString());
          mesajList.add(resultData[keyList[i]]["name"].toString());
          _photoList.add(resultData[keyList[i]]["photoUrl"].toString());
          _mesajGonderilecekUidList
              .add(resultData[keyList[i]]["mesajId"].toString());
          _anahtarListesi.add(keyList[i].toString());

          topluYaz[keyList[i]] = resultData[keyList[i]];

          break;
        }
      }
    }
    // print(mesajList.toString() + "   wwwwwww");
    return mesajList;
  }

  _elliGectiSirala(
    var list, Map<String, dynamic> resultData, List<String> keyList) {
    Map<String, dynamic> topluYaz = {};
    var zaman = [];

    Map<String, dynamic> _siralanmisElli = {};

    for (int i = 0; i < list.length; i++) zaman.add(list[i]["date"]);
//print(zaman.toString()+"  ------------");
    var temp = zaman..sort();

    //  print(keyList.toString() + "  ***********");
    for (int j = temp.length-1; j >temp.length/2; j--) {
      for (int i = 0; i < keyList.length; i++) {
        if (resultData[keyList[i]]["date"] == temp[j]) {
          _siralanmisElli[keyList[i]] = resultData[keyList[i]];

          break;
        }
      }
    }
    
    DocumentReference _ref = FirebaseFirestore.instance
          .doc("--usersMesajlar/" + _auth.currentUser.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(_ref, _siralanmisElli);

    });
    print(_siralanmisElli.toString() + "   wwwwwww");
  }
}
