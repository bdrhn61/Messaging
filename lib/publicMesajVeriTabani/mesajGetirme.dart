// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:space/models/publicMesajModel.dart';

class MesajGetir {
  
  int ilkVurusMu;
  Stream<List<MesajModel>> mesajlar;
  List<MesajModel> _tumMesajlar;
  MesajGetir(
    this.ilkVurusMu,
    this.mesajlar,
    this._tumMesajlar,
  ) {
    ilkVurusMu=0;
  }
  Stream<List<MesajModel>>? mesajGetir(String mesajAdres)  {
    if(ilkVurusMu==0){
      ilkVurusMu++;
    var snapShot = FirebaseFirestore.instance
        .collection(mesajAdres)
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots();


     mesajlar =
        snapShot.map((mesajListesi) => mesajListesi.docs.map((mesaj) {
              //  print(mesaj.id.runtimeType.+"bbbbbbbb");

              return MesajModel.mapNesne(mesaj.data(), mesaj.id);
            }).toList());

    return mesajlar;
    }
    return null;

  }
 Stream<List<MesajModel>> mesajGetirUsteVurunca(String mesajAdres, Timestamp date ){
    
      var snapShot = FirebaseFirestore.instance
          .collection(mesajAdres)
          .orderBy("date", descending: true)
          .limit(10)
          .startAfter([date]).snapshots();

         mesajlar = snapShot.map((mesajListesi) => mesajListesi.docs
          .map((mesaj) => MesajModel.mapNesne(mesaj.data(), mesaj.id))
          .toList());

      print("veri abani okundu ussssssssssssssssssssssssssssssssssssssssss");
    return mesajlar;

  }
  mesajlariPesPeseEkle(List<MesajModel> _tumMesajlar){

  }
}
