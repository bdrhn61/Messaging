import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


enum TabItem { Kullanicilar, Profil,Mekanlar }

class TabItemData {
  //final String label;
 // final IconData icon;
  SvgPicture tabResimProfil;

  TabItemData(/*this.label,*/ this.tabResimProfil);
 


  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar:
        TabItemData(SvgPicture.asset("assets/images/adres2.svg",width: 25,height: 25,color: Colors.brown,)),
    TabItem.Profil: TabItemData( SvgPicture.asset("assets/images/user2.svg",width: 25,height: 25,color: Colors.blueAccent),),
    TabItem.Mekanlar:TabItemData( SvgPicture.asset("assets/images/placeholder2.svg",width: 25,height: 25,color: Color.fromARGB(255, 132, 159, 116),),),
  };
   static Map<TabItem, TabItemData> tumTablar2 = {
    TabItem.Kullanicilar:
        TabItemData( SvgPicture.asset("assets/images/adres22.svg",width: 25,height: 25,color: Colors.brown,)),
    TabItem.Profil: TabItemData( SvgPicture.asset("assets/images/user22.svg",width: 25,height: 25,color: Colors.blueAccent,),),
    TabItem.Mekanlar:TabItemData( SvgPicture.asset("assets/images/placeholder22.svg",width: 25,height: 25,color: Color.fromARGB(255, 132, 159, 116),),),
  };
}
