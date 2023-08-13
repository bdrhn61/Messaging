import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space/Home/bottom_nav_model.dart';
import 'package:space/Home/tabItems.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.black,
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.black,
       // backgroundColor: Colors.black,
        // border:Border(top: BorderSide(width: 50)),  //TAB BARIN BOYU
        items: [
          _naviItemOlustur(TabItem.Profil),
          _naviItemOlustur(TabItem.Kullanicilar),
          _naviItemOlustur(TabItem.Mekanlar),
        ],
        onTap: (index) {
          print(index);
          onSelectedTab(TabItem.values[index]);
        } ,
      ),
      tabBuilder: (BuildContext context, int index) {
        final gosterilecekItem = TabItem.values[index];

        return CupertinoTabView(builder: (context) {
          return sayfaOlusturucu[gosterilecekItem];
        });
      },
    );
  }

  BottomNavigationBarItem _naviItemOlustur(TabItem tabItem) {
    final _olusturulacakTab2 = TabItemData.tumTablar2[tabItem];
    final _olusturulacakTab =  TabItemData.tumTablar[tabItem];

    print("ssss");
    return BottomNavigationBarItem(
     // activeIcon: _olusturulacakTab2.tabResimProfil,
      icon: (_olusturulacakTab.tabResimProfil),
      
    );
  }
}

List<NavBarModel> _navBarItem = [
  
  NavBarModel(
    icon: "assets/images/user2.svg",
    activeIcon: "assets/images/user22.svg",
    title: "Search",
    color: Colors.blueAccent,
  ),
  NavBarModel(
    icon: "assets/images/adres2.svg",
    activeIcon: "assets/images/adres22.svg",
    title: "Home",
    color: Colors.brown,
  ),
  NavBarModel(
    icon: "assets/images/placeholder2.svg",
    activeIcon: "assets/images/placeholder22.svg",
    title: "Add",
    color: Colors.green
  ),
 
];