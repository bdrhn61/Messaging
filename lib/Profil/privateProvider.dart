
import 'package:flutter/material.dart';

class PrivateProvider with ChangeNotifier {
String mesajGonderilecekAdres;
String onunIsim;
PrivateProvider();
setMesajGonderilecekAdres(String adres){
  mesajGonderilecekAdres=adres;
  notifyListeners();
}

setMesajGonderilecekAdresMesengerdanGeldim(String adres){
  mesajGonderilecekAdres=adres;
  
}

setMesajGonderilecekIsim(String isim){
  onunIsim=isim;
  notifyListeners();
}



}