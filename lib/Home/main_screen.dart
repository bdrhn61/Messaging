

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:space/Home/bottom_nav_model.dart';
import 'package:space/publicMesaj/harita.dart';
import 'package:space/sign.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
print("Main Screennn build--------------------------------------------------------");
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
               
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
              
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
         //   _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
 

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          SignPage(),
          Harita(),
         // PlaceMesaj(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}

List<NavBarModel> _navBarItem = [
  NavBarModel(
    icon: "assets/images/user2.svg",
    activeIcon: "assets/images/user22.svg",
    
    color: Colors.blueAccent,
  ),
  NavBarModel(
    icon: "assets/images/adres2.svg",
    activeIcon: "assets/images/adres22.svg",
    
    color: Colors.brown,
  ),
  /*
  NavBarModel(
      icon: "assets/images/placeholder2.svg",
      activeIcon: "assets/images/placeholder22.svg",
      
      color: Colors.green),
      */
];
