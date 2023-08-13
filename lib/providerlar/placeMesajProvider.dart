import 'package:flutter/material.dart';

class PlaceMesajProvider with ChangeNotifier{
PlaceMesajProvider(this.sayac,this.kontrol,this.lat,this.lang);
double lat;
double lang;
int sayac;
List<String> placeIdList;

bool kontrol;
konumGir(double enlem,double boylam){
lat=enlem;
lang=boylam;
notifyListeners();
}
sayacAttir(){
  sayac++;
  
}
placeListAta(List<String> liste){
placeIdList=liste;
kontrol=true;
notifyListeners();
}
kontrolDegis(BuildContext ctnx){
  
  kontrol=true;
  notifyListeners();

}
} 