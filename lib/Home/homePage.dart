import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space/Home/bottom_nav_model.dart';
import 'package:space/Home/tabItems.dart';
import 'package:space/models/Ben.dart';
import 'package:space/publicMesaj/harita.dart';
import 'package:space/sign.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  static List<Widget> _bottomNavView = [


    SignPage(),
    Harita(),
    //PlaceMesaj(),
   
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  TabItem _currentTab = TabItem.Kullanicilar;
  int _currentindex=0;


  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: SignPage(),
      TabItem.Profil: Harita(),
    //  TabItem.Mekanlar:PlaceMesaj(),
    };
  }
final _tabs = [SignPage(), Harita()];          //    PlaceMesaj()];

  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];
  Ben sayfaProvideriBen;
  @override
  Widget build(BuildContext context) {
   print("Home Page build--------------------------------------------------------");
    return 
 Scaffold(
       
      body:  Center(
            child: _bottomNavView.elementAt(_selectedIndex),
          
      ),
        
      bottomNavigationBar:  BottomNavigationBar(
               
                backgroundColor: Colors.black,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: 
                _navBarItem
                    .map(
                      (f) => 
                      
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          
                          f.icon,
                          width: 26.0,
                          color : f.color,
                          
                          
                          
                        ),
                        activeIcon: SvgPicture.asset(
                          f.activeIcon,
                          width: 26.0,
                          color: f.color,
                          
                        ),
                        label: "",
                      ),
                      
                    )
                    .toList(),),
              
      
       
      
      
    );

  }}
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
      color: Colors.green),
];
 

 //ÇALIşan SİYAHHHHHH
/*


  static List<Widget> _bottomNavView = [


    SignPage(),
    Harita(),
    PlaceMesaj(null),
   
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  TabItem _currentTab = TabItem.Kullanicilar;
  int _currentindex=0;


  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: SignPage(),
      TabItem.Profil: Harita(),
      TabItem.Mekanlar:PlaceMesaj(null),
    };
  }
final _tabs = [SignPage(), Harita(), PlaceMesaj(null)];




Scaffold(
       
      body:  Center(
            child: _bottomNavView.elementAt(_selectedIndex),
          
      ),
        
      bottomNavigationBar:  BottomNavigationBar(
               
                backgroundColor: Colors.black,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: 
                _navBarItem
                    .map(
                      (f) => 
                      
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          
                          f.icon,
                          width: 26.0,
                          color : f.color,
                          
                          
                          
                        ),
                        activeIcon: SvgPicture.asset(
                          f.activeIcon,
                          width: 26.0,
                          color: f.color,
                          
                        ),
                        title: Text(f.title),
                      ),
                      
                    )
                    .toList(),),
              
      
       
      
      
    );

*/

/*

 Scaffold(
      body: _tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentindex,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: new Image.asset('assets/images/user.png',width:_currentindex==0? 28:25,height: _currentindex==0? 28:25,color: Colors.blueAccent,),
              label:"" ),
          new BottomNavigationBarItem(
              icon: new Image.asset('assets/images/adres.png',width:_currentindex==1? 28:25,height: _currentindex==1? 28:25,color: Colors.brown,),
              label:""
              ),
              
          new BottomNavigationBarItem(
              icon: new Image.asset('assets/images/placeholder.png',width:_currentindex==2? 28:25,height: _currentindex==2? 28:25,color: Color.fromARGB(255, 132, 159, 116),),
              label:""
              ),
        
          ],
          onTap: (index) {
            setState(() {
              _currentindex = index;
            });
          }),
    );

GÖRÜNÜP KAYBOLAN İLK YPILAN
 return Container(
      child: MyCustomBottomNavigation(sayfaOlusturucu: tumSayfalar(),
          currentTab: _currentTab,
          onSelectedTab: (secilenTab) {
        
            setState(() {
              _currentTab = secilenTab;
              

            });

            print(secilenTab.toString());
          }),
    );

*/

