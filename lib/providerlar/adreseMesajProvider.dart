import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/LocalVeriTabani/database_helper.dart';

class AdreseMesajProvider with ChangeNotifier {
  bool isLoading;
  List<String> dynamicChips;
  List<String> dynamicChipsHarita;
  List<Color> chipRenk;
  String tamAdres;
  String sifreliMesajAdres;
  String tamAdresHarita;
  String sifreliMesajAdresHarita;
  var pageControl;
  int value;
  int aderseMesajvalue;
  bool mesajGeldimi;
  Color rek;
  DatabaseHelper _db1 = DatabaseHelper();
  Color ikonButonRenk;
  String ikonButonAdres;
  bool iconButonYukleniyor;
  String mesajId;
  String yorumYapilacakMesaj;
  double mesajSayfasinaGitButtonOpacity;
  double mesajSayfasinaGitButtonOpacityadreseMesaj;
  int firstVisibleItemIndex;
  Map<String, Map> kullanici = {};
  int begeniSayisi;
  Color capaRenk;
  bool localAdresGeldiMi = false;
  double anim_width=0;
  double anim_height=0;
  double anim_widthSgn=0;
  double anim_heightSgn=0;
  LatLng haritaCameraPosition =  LatLng(40.9963402, 39.7269885);
  
  AdreseMesajProvider(
      this.isLoading,
      this.tamAdres,
      this.tamAdresHarita,
      this.dynamicChips,
      this.dynamicChipsHarita,
      this.chipRenk,
      this.mesajGeldimi,
      this.rek,
      this.ikonButonRenk,
      this.ikonButonAdres,
      this.iconButonYukleniyor,
      this.mesajId,
      this.yorumYapilacakMesaj,
      this.mesajSayfasinaGitButtonOpacity,
      this.mesajSayfasinaGitButtonOpacityadreseMesaj,
      this.sifreliMesajAdres,
      this.sifreliMesajAdresHarita,
      this.begeniSayisi,
      this.capaRenk,
   );
  NotificationHandler ntf = NotificationHandler();

  haritadanMesajSayfasinaGitButtonSizeBuyut(double _en){
     anim_width=_en/5;
     anim_height=_en/5;
  }
  haritadanMesajSayfasinaGitButtonSizeKucult(){
     anim_width=0;
     anim_height=0;
  }
  haritadanMesajSayfasinaGitButtonSizeBuyutSgn(double _en){
     anim_widthSgn=_en/5;
     anim_heightSgn=_en/5;
  }
  haritadanMesajSayfasinaGitButtonSizeKucultSgn(){
     anim_widthSgn=0;
     anim_heightSgn=0;
  }
  haritaCameraPositionAta(double lat,double lang){
    haritaCameraPosition =  LatLng(lat, lang);
    notifyListeners();
  }
  void renkAyarlaSelect(int sayi) {
    for (int i = 0; i < chipRenk.length; i++) {
      if (i == sayi)
        chipRenk[i] = Colors.white;
      else
        chipRenk[i] = Colors.black;
    }
  }

  void renkAyarlaNotSelect(int sayi) {
    print(sayi.toString()+"sayi  ++");
    chipRenk[sayi] = Colors.black;
  }
  
  void renkAyarlaNotSelectHepsi() {
    
    for(int i=0;i<chipRenk.length;i++)
    chipRenk[i] = Colors.black;
  }

  void localAdresGeldiMiFalseYap() {
    localAdresGeldiMi = false;
    notifyListeners();
  }

  void localAdresGeldiMiTrueYap() {
    localAdresGeldiMi = true;
    notifyListeners();
  }

  bool getir() {
    return isLoading;
  }

  void goster() {
    isLoading = true;

    notifyListeners();
  }

  void gosterme() {
    isLoading = false;
    notifyListeners();
  }

  elemanlarYukleniyor() {
    return Opacity(
      opacity: isLoading ? 1 : 0,
      child: isLoading
          ? CircularProgressIndicator(backgroundColor: Colors.red)
          : null,
    );
  }

  bool acikMi = false;
  int renkSayaci=0;
  void scrollListenerWithItemHeight(ScrollController _scrollController) {
    int itemHeight = 60; // including padding above and below the list item
    double scrollOffset = _scrollController.offset;
    firstVisibleItemIndex = scrollOffset < itemHeight
        ? 0
        : ((scrollOffset - itemHeight) / itemHeight).ceil();
    print(firstVisibleItemIndex.toString() + "-----");

    if (firstVisibleItemIndex > 1 && acikMi == false) {
      acikMi = true;
      mesajGeldimi = true;
      print("-------------------------------------bb");
      capaRenk = Colors.red;
      ntf.mesajGeldimiFalseYap();
      

      notifyListeners();
    } else if (firstVisibleItemIndex < 1 && acikMi == true) {
      acikMi = false;
      mesajGeldimi = false;
      print("-------------------------------------cc");
      capaRenk = Colors.red;
      renkSayaci=0;

      ntf.mesajGeldimiFalseYap();
      notifyListeners();
    }
  }
  renkSayaciArttir(){
    renkSayaci++;
  }
  capaRenkYesilYap() {
    print("------------------------------------  yesil yapıldı");
    capaRenk = Colors.green;
   // notifyListeners();
  }

  //HARİTA   PROVİDER
////////////////////////////////////////////////////////////////////////////////////////////////
  void haritayaDokun(tam) {
    //tamAdres=tam;
    value = null;
    haritadanMesajSayfasinaGitButtonSizeKucult();
    
    notifyListeners();
    
  }

  void adresGir(ulke, sehir, ilce, mahalle, sokak) {
    dynamicChips[0] = ulke;
    dynamicChips[1] = sehir;
    dynamicChips[2] = ilce;
    dynamicChips[3] = mahalle;
    dynamicChips[4] = sokak;

    notifyListeners();
  }

  void adresGirBaslangic(ulke, sehir, ilce, mahalle, sokak) {
    dynamicChips[0] = ulke;
    dynamicChips[1] = sehir;
    dynamicChips[2] = ilce;
    dynamicChips[3] = mahalle;
    dynamicChips[4] = sokak;
    dynamicChipsHarita[0] = ulke;
    dynamicChipsHarita[1] = sehir;
    dynamicChipsHarita[2] = ilce;
    dynamicChipsHarita[3] = mahalle;
    dynamicChipsHarita[4] = sokak;
    notifyListeners();
  }

  void adresGirHarita(ulke, sehir, ilce, mahalle, sokak) {
    dynamicChipsHarita[0] = ulke;
    dynamicChipsHarita[1] = sehir;
    dynamicChipsHarita[2] = ilce;
    dynamicChipsHarita[3] = mahalle;
    dynamicChipsHarita[4] = sokak;

    notifyListeners();
  }

  void valueNullYap() {
    value = null;
    tamAdres = "null";
    haritadanMesajSayfasinaGitButtonSizeKucult();
  }

  void adreseMesajValueNullYap() {
    aderseMesajvalue = null;
    tamAdresHarita = "null";
    haritadanMesajSayfasinaGitButtonSizeKucult();
  }

  void ulke(_selected, _index, _adres, bool nerdengeliyon,double _en) {
    if (_selected) {
      if (nerdengeliyon) {
        value = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyutSgn( _en);
        tamAdres = dynamicChips[0];
        var bytes = utf8.encode(dynamicChips[0]);
        sifreliMesajAdres = sha256.convert(bytes).toString();
      } else {
        aderseMesajvalue = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyut(_en);
        tamAdresHarita = dynamicChipsHarita[0];
        var bytes = utf8.encode(dynamicChipsHarita[0]);
        sifreliMesajAdresHarita = sha256.convert(bytes).toString();
      }
    } else {
      if (nerdengeliyon) {
        tamAdres = "null";
        value = null;
        haritadanMesajSayfasinaGitButtonSizeKucultSgn();
      } else {
        tamAdresHarita = "null";
        aderseMesajvalue = null;
        haritadanMesajSayfasinaGitButtonSizeKucult();
      }
    }
    notifyListeners();
  }

  void sehir(_selected, _index, _adres, bool nerdengeliyon,double _en) {
    if (_selected) {
      if (nerdengeliyon) {
        value = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyutSgn(_en);
        tamAdres = dynamicChips[1];
        var bytes = utf8.encode(dynamicChips[0] + dynamicChips[1]);
        sifreliMesajAdres = sha256.convert(bytes).toString();
      } else {
        aderseMesajvalue = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyut(_en);
        tamAdresHarita = dynamicChipsHarita[1];
        var bytes = utf8.encode(dynamicChipsHarita[0] + dynamicChipsHarita[1]);
        sifreliMesajAdresHarita = sha256.convert(bytes).toString();
      }
    } else {
      if (nerdengeliyon) {
        tamAdres = "null";
        value = null;
        haritadanMesajSayfasinaGitButtonSizeKucultSgn();
      } else {
        tamAdresHarita = "null";
        aderseMesajvalue = null;
        haritadanMesajSayfasinaGitButtonSizeKucult();
      }
    }
    notifyListeners();
  }

  void ilce(_selected, _index, _adres, bool nerdengeliyon,double _en) {
    if (_selected) {
      if (nerdengeliyon) {
        value = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyutSgn(_en);
        tamAdres = dynamicChips[2];
        var bytes =
            utf8.encode(dynamicChips[0] + dynamicChips[1] + dynamicChips[2]);
        sifreliMesajAdres = sha256.convert(bytes).toString();
      } else {
        aderseMesajvalue = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyut(_en);
        tamAdresHarita = dynamicChipsHarita[2];
        var bytes = utf8.encode(dynamicChipsHarita[0] +
            dynamicChipsHarita[1] +
            dynamicChipsHarita[2]);
        sifreliMesajAdresHarita = sha256.convert(bytes).toString();
      }
    } else {
      if (nerdengeliyon) {
        tamAdres = "null";
        value = null;
        haritadanMesajSayfasinaGitButtonSizeKucultSgn();
      } else {
        tamAdresHarita = "null";
        aderseMesajvalue = null;
        haritadanMesajSayfasinaGitButtonSizeKucult();
      }
    }
    notifyListeners();
  }

  Future<void> mahalle(_selected, _index, _adres, bool nerdengeliyon,double _en) async {
    if (_selected) {
      if (nerdengeliyon) {
        value = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyutSgn(_en);
        tamAdres = dynamicChips[3];
        var bytes =
            utf8.encode(dynamicChips[1] + dynamicChips[2] + dynamicChips[3]);
        sifreliMesajAdres = sha256.convert(bytes).toString();
      } else {
        aderseMesajvalue = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyut(_en);
        tamAdresHarita = dynamicChipsHarita[3];
        var bytes = utf8.encode(dynamicChipsHarita[1] +
            dynamicChipsHarita[2] +
            dynamicChipsHarita[3]);
        sifreliMesajAdresHarita = sha256.convert(bytes).toString();
      }
    } else {
      if (nerdengeliyon) {
        tamAdres = "null";
        value = null;
        haritadanMesajSayfasinaGitButtonSizeKucultSgn();
      } else {
        tamAdresHarita = "null";
        aderseMesajvalue = null;
        haritadanMesajSayfasinaGitButtonSizeKucult();
      }
    }
    notifyListeners();
  }

  void sokak(_selected, _index, _adres, bool nerdengeliyon,double _en,double _boy) {
    if (_selected) {
      if (nerdengeliyon) {
        value = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyutSgn(_en);
        tamAdres = dynamicChips[4];
        var bytes =
            utf8.encode(dynamicChips[2] + dynamicChips[3] + dynamicChips[4]);
        sifreliMesajAdres = sha256.convert(bytes).toString();
      } else {
        aderseMesajvalue = _index;
        haritadanMesajSayfasinaGitButtonSizeBuyut(_en);
        tamAdresHarita = dynamicChipsHarita[4];
        var bytes = utf8.encode(dynamicChipsHarita[2] +
            dynamicChipsHarita[3] +
            dynamicChipsHarita[4]);
        sifreliMesajAdresHarita = sha256.convert(bytes).toString();
      }
    } else {
      if (nerdengeliyon) {
        tamAdres = "null";
        value = null;
        haritadanMesajSayfasinaGitButtonSizeKucultSgn();
      } else {
        tamAdresHarita = "null";
        aderseMesajvalue = null;
        haritadanMesajSayfasinaGitButtonSizeKucult();
      }
    }
    notifyListeners();
  }

  void pageCont(page) {
    pageControl = page;
  }

  void ikonRenkDegis(ikonButonSayac, adrss) {
    print(ikonButonSayac.toString());
    if (ikonButonSayac == Colors.yellow) {
      ikonButonRenk = Colors.white;
      ikonButonAdres = "assets/images/notification.png";
      // ntf.fcm.unsubscribeFromTopic(adrss);
      print("beyaz");
    } else if (ikonButonSayac == Colors.white) {
      ikonButonRenk = Colors.yellow;
      ikonButonAdres = "assets/images/notification1.png";
      print("sarı");
    }

    notifyListeners();
  }

  void ikonRenkDegisBaslangic(String adres, String userId) async {
    iconButonYukleniyor = false;

    var sonuc = await _db1.yerOku(adres, userId);
    print(sonuc.length);
    if (sonuc.length == 0) {
      ikonButonRenk = Colors.white;
      ikonButonAdres = "assets/images/notification.png";
      iconButonYukleniyor = true;

      print("Baslangıc icon rengi beyaza atandı");
    } else {
      ikonButonRenk = Colors.yellow;
      ikonButonAdres = "assets/images/notification1.png";
      iconButonYukleniyor = true;
      print("Baslangıc icon rengi sarıya atandı");
    }

    print(sonuc.toString() + "+++++++");
    //_db1.yerOkuHepsini();
    notifyListeners();
  }

  void placeTamAdres(String _adres) {
    tamAdres = _adres;
  }

  begeniSayisiAta(int sayi) {
    begeniSayisi = sayi;
    notifyListeners();
  }
}
