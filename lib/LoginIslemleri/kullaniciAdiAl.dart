import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space/Hakkimda/hakkimdaVT.dart';
import 'package:space/Home/main_screen.dart';
import 'package:space/counterpro.dart';
import 'package:space/models/Ben.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/providerlar/placeMesajProvider.dart';
import 'package:space/toastSnackBar.dart';

class KullaniciAdiAl extends StatelessWidget {
  TextEditingController userNameTextcontroller = TextEditingController();
  double en;
  double boy;
  Ben sayfaProvideriBen;
  HakkimdaVt _hakkimdaVt = HakkimdaVt();
  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    sayfaProvideriBen = Provider.of<Ben>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        print("object");
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: en / 20, right: en / 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: en / 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(en / 32),
                      border: Border.all(
                        color: Colors.white,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: userNameTextcontroller,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0)),
                            ),
                            hintText: sayfaProvideriBen.unicUserName == null ||
                                    sayfaProvideriBen.unicUserName == ""
                                ? "user name"
                                : sayfaProvideriBen.unicUserName)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (userNameTextcontroller.text.trim().length > 4) {
                        bool deger = await _hakkimdaVt.kullaniciAdiniVTyeYaz(
                            userNameTextcontroller.text, context);
                        if (deger) homePageGit(context);
                      } else {
                        showInSnackBar(
                            "The number of characters used must be at least 5.",
                            context);
                      }
                      //   kullaniciAdiniVTyeYaz(userNameTextcontroller.text);
                      //  print(userNameTextcontroller.text);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(en / 30),
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void homePageGit(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<AdreseMesajProvider>(
                create: (_) => AdreseMesajProvider(
                    false,
                    "adres",
                    "adres",
                    ["", "", "", "", ""],
                    ["", "", "", "", ""],
                    [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black
                    ],
                    false,
                    Colors.red,
                    Colors.white,
                    "assets/images/ringing.png",
                    false,
                    "",
                    "",
                    1,
                    1,
                    "",
                    "",
                    null,
                    Colors.red),
              ),
              // ChangeNotifierProvider<NotificationHandler>.value(
              //    value: NotificationHandler(),
              //   ),
              ChangeNotifierProvider<PlaceMesajProvider>(
                create: (_) => PlaceMesajProvider(0, false, null, null),
              ),
              ChangeNotifierProvider<CounterPro>(
                  create: (_) => CounterPro(1, false, 0), child: MainScreen())
            ],
            child: MainScreen(),
          ),
        ));
  }
}
