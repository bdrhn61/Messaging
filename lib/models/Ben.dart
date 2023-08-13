import 'dart:typed_data';

import 'package:flutter/material.dart';

class Ben with ChangeNotifier {
  late String userName;
  late String userid;
  late String photoUrl;
  late String eMail;
  late int begeniSayisi;
  late Uint8List fotoBytes;
  late int sayfaKontroller;
  late BuildContext ctnx;
  late bool buildEtme;
  late String capaRengiDegissinmi;
  late String unicUserName;
  List<String> infoKeyList = [
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
  Map<String, String> hakkimdaMap = {
    "hakkimda": "",
    "cinsiyet": "",
    "yas": "",
    "boy": "",
    "ilgi_Alanlari": "",
    "egitim": "",
    "is": "",
    "İnstagram": "",
    "twitter": "",
    "snapchat": "",
    "youtube": ""
  };

  void capaRengiDegissinmiAta(String adres) {
    capaRengiDegissinmi = adres;
  }

  void buildEtmeAta(bool? etsinmi) {
    buildEtme = etsinmi!;
  }

//Map<String,dynamic> benMap={"kullaniciId":"","kullaniciAdi":"","kullaniciEmail":"","kullaniciPhotoUrl":"","kullaniciFotoBytes":null};
  void sayfaKontrollerGir(int index, BuildContext cont) {
    sayfaKontroller = index;
    ctnx = cont;
  }

  unicUserNameSet(String unicUserName){
   this.unicUserName=unicUserName;
  }

  void benset(String userName, String userid, String photoUrl, String eMail,
      Uint8List fotoBytes, int begeniSayisi,String unicUserName) {
    this.userName = userName;
    this.userid = userid;
    this.photoUrl = photoUrl;
    this.eMail = eMail;
    this.fotoBytes = fotoBytes;
    this.begeniSayisi = begeniSayisi;
    this.unicUserName=unicUserName;
  }

  void benHakkimdaSet(Map<String,dynamic> vTGelendeger) {
    for(int i=0;i<infoKeyList.length;i++)
    hakkimdaMap[infoKeyList[i]]=vTGelendeger[infoKeyList[i]];
  }
  
  void benHakkimdaDegisiklikSet(List<String> anahtar,List<String> deger) {
    for(int i=0;i<anahtar.length;i++)
    hakkimdaMap[anahtar[i]]=deger[i];
    print("veri bene setlendi");
  }

  void photoUrlSet(String foto) {
    this.photoUrl = foto;
    print("resim setlendi");
    notifyListeners();
  }

  void photoUrlSetNotNotify(String foto) {
    this.photoUrl = foto;
    print("resim setlendi");
    notifyListeners();
  }

  Map<String, dynamic> benMapGetir() {
    Map<String, dynamic> kullanici = {
      'userID': this.userid,
      'userName': this.userName,
      'eMail': this.eMail,
      'photoUrl': this.photoUrl,
      'begeniSayisi': this.begeniSayisi,
    };
    //benMap["kullaniciId"]=this.userid;
    //benMap["kullaniciAdi"]=this.userName;
    //benMap["kullaniciEmail"]="email";
    //benMap["kullaniciPhotoUrl"]=this.photoUrl;
    //benMap["kullaniciFotoBytes"]=this.fotoBytes;

    return kullanici;
  }
}
