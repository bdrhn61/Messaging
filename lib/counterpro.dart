// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CounterPro with ChangeNotifier {
  int sayac;
  bool galeri;
  
  Widget galeriWidget;
  

  double goster;
  CounterPro({
    required this.sayac,
    required this.galeri,
    required this.galeriWidget,
    required this.goster,
  });


  void gosterTrue() {
    goster = 1;
    notifyListeners();
  }

  void gosterFalse() {
    goster = 0;
   // notifyListeners();
  }

  void galeriGetir() {
    galeri = true;
    notifyListeners();
  }

  void arttir() {
    sayac++;
    notifyListeners();
  }

}
