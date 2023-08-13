import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/models/Ben.dart';
import 'package:space/models/publicMesajModel.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';

// ignore: must_be_immutable
class Capa extends StatefulWidget {
  String mesajId;
  String mesajAdres;
  ScrollController _scrollController;
  Color capaRenk;
  Capa(this.mesajId, this.mesajAdres, this._scrollController, this.capaRenk);

  @override
  _CapaState createState() => _CapaState();
}

class _CapaState extends State<Capa> {
  Timestamp _kontrol = Timestamp(0, 0);

  @override
  void initState() {
    super.initState();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  String mesajSayisi = "-2";

  List<MesajModel> _tumMesajlar = [];

  Widget build(BuildContext context) {
    Ben sayfaProvideriBen = Provider.of<Ben>(context, listen: true);

    var sayfaProvideri =
        Provider.of<AdreseMesajProvider>(context, listen: true);

    sayfaProvideriBen.buildEtmeAta(null);

    print("capaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-------");
    print(sayfaProvideri.mesajGeldimi.toString());

    return Opacity(
        opacity: sayfaProvideri.mesajGeldimi ? 1 : 0,
        child: sayfaProvideri.mesajGeldimi
            ?

            /// RESPONSİV YAP
            Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder<List<MesajModel>>(
                    stream: mesajGetir(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(""),
                        );
                      }
                      _tumMesajlar = snapshot.data!;

                      if (sayfaProvideri.renkSayaci == 0) {
                        _kontrol = _tumMesajlar[0].date;
                        sayfaProvideri.renkSayaciArttir();
                      }

                      if (_tumMesajlar[0].userID != _auth.currentUser?.uid &&
                          sayfaProvideri.renkSayaci > 0 &&
                          _kontrol != _tumMesajlar[0].date) {
                        sayfaProvideri.capaRenkYesilYap();
                        mesajSayisi = _tumMesajlar[0].date.toString();
                      }

                      List<MesajModel>? tumMesaj = snapshot.data;
                      
                      //  sayfaProvideri.geridenGelenMesajAta(tumMesaj[0].mesaj);
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              color: sayfaProvideri
                                  .capaRenk.withOpacity(0.7), //sayfaProvideri.rek, //Colors.red ,
                              icon: Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                widget._scrollController.animateTo(0,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.decelerate);
                                //_scrollController.jumpTo(0);
                                //  _notificationHandler.fcm.unsubscribeFromTopic("rize");
                                //print("aaaaaaaa");
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Wrap(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      tumMesaj![0].mesaj,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              )
            : null);
  }

  mesajGetir() {
    var snapShot = FirebaseFirestore.instance
        .collection("--adreseMesaj")
        .doc(widget.mesajAdres)
        .collection("1")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();

    // print("snapShot.length" + snapShot.toList().toString() + "--------");

    var mesajlar =
        snapShot.map((mesajListesi) => mesajListesi.docs.map((mesaj) {
              //  print(mesaj.id.runtimeType.+"bbbbbbbb");

              return MesajModel.mapNesne(mesaj.data(), mesaj.id);
            }).toList());
    // print("veri abani ilkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    // print(mesajlar.toString()+"----------------------------***********************************");
    return mesajlar;
  }
}
