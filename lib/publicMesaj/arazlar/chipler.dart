import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/gpsKonum2.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';
import 'package:space/toastSnackBar.dart';

class ChiplerSgn extends StatefulWidget {

  @override
  ChiplerSgnState createState() => ChiplerSgnState();
}

class ChiplerSgnState extends State<ChiplerSgn> {
  late double en;
  late double boy;
  late AdreseMesajProvider _sayfaProviderChip;
  late List<Placemark> placemarks;
  GpsKonum2 gpsKonum = GpsKonum2();

  
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) => _yourFunction(context));

    super.initState();
  }

  _yourFunction(BuildContext context) async {
    await gpsKonum.konumal();
    try {
      print(gpsKonum.locationData.latitude.toString() +
          " ****** " +
          gpsKonum.locationData.longitude.toString());
      await adresIslemleri(context, gpsKonum.locationData.latitude,
          gpsKonum.locationData.longitude);
    } catch (e) {
      showInSnackBar("Failed to get current location.", context);
    }
  }

  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    print("Chip build");
    _sayfaProviderChip = Provider.of<AdreseMesajProvider>(context);

    if (_sayfaProviderChip.dynamicChips[0] != "" &&
        _sayfaProviderChip.dynamicChips[1] != "") {
      return Container(
        // color: Colors.green,
        child: Wrap(children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 45,
                left: en / 35,
                right: en / 35),
            child: Align(
              alignment: Alignment.topCenter,
              
                
                child: Wrap(
                  
                  alignment: WrapAlignment.spaceAround,
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: [
                    if (_sayfaProviderChip.dynamicChips[0] != "" &&
                        _sayfaProviderChip.dynamicChips[0] != "Unnamed Road" &&
                        _sayfaProviderChip.dynamicChips[0] != ".")
                      ChoiceChip(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        selected: _sayfaProviderChip.value == 0,
                        label: Text(
                          _sayfaProviderChip.dynamicChips[0],
                          style: GoogleFonts.montserrat(
                              color: _sayfaProviderChip.chipRenk[0], fontWeight: FontWeight.bold),
                        ),
                        onSelected: (selected) {
                          _sayfaProviderChip.ulke(selected, 0,
                              _sayfaProviderChip.dynamicChips[0], true,en);
                          print("selected");
                          if (selected) {
                            _sayfaProviderChip
                                .renkAyarlaSelect(_sayfaProviderChip.value);
                          }
                          if (!selected) {
                            _sayfaProviderChip
                                .renkAyarlaNotSelect(0);
                          }
                        },
                      ),
                    if (_sayfaProviderChip.dynamicChips[1] != "" &&
                        _sayfaProviderChip.dynamicChips[1] != "Unnamed Road" &&
                        _sayfaProviderChip.dynamicChips[1] != ".")
                      ChoiceChip(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        label: Text(
                          _sayfaProviderChip.dynamicChips[1],
                          style: GoogleFonts.montserrat(
                              color: _sayfaProviderChip.chipRenk[1], fontWeight: FontWeight.bold),
                        ),
                        selected: _sayfaProviderChip.value == 1,
                        onSelected: (selected) {
                          _sayfaProviderChip.sehir(selected, 1,
                              _sayfaProviderChip.dynamicChips[1], true,en);
                          print("selected");
                          if (selected) {
                            _sayfaProviderChip
                                .renkAyarlaSelect(_sayfaProviderChip.value);
                          }
                          if (!selected) {
                            _sayfaProviderChip
                                .renkAyarlaNotSelect(1);
                          }
                        },
                      ),
                    if (_sayfaProviderChip.dynamicChips[2] != "" &&
                        _sayfaProviderChip.dynamicChips[2] != "Unnamed Road" &&
                        _sayfaProviderChip.dynamicChips[2] != ".")
                      ChoiceChip(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        label: Text(
                          _sayfaProviderChip.dynamicChips[2],
                          style: GoogleFonts.montserrat(
                              color: _sayfaProviderChip.chipRenk[2], fontWeight: FontWeight.bold),
                        ),
                        selected: _sayfaProviderChip.value == 2,
                        onSelected: (selected) {
                          _sayfaProviderChip.ilce(selected, 2,
                              _sayfaProviderChip.dynamicChips[2], true,en);
                          print("selected");
                          if (selected) {
                            _sayfaProviderChip
                                .renkAyarlaSelect(_sayfaProviderChip.value);
                          }
                          if (!selected) {
                            _sayfaProviderChip
                                .renkAyarlaNotSelect(2);
                          }
                        },
                      ),
                    if (_sayfaProviderChip.dynamicChips[3] != "" &&
                        _sayfaProviderChip.dynamicChips[3] != "Unnamed Road" &&
                        _sayfaProviderChip.dynamicChips[3] != ".")
                      ChoiceChip(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        label: Text(
                          _sayfaProviderChip.dynamicChips[3],
                          style: GoogleFonts.montserrat(
                              color: _sayfaProviderChip.chipRenk[3], fontWeight: FontWeight.bold),
                        ),
                        selected: _sayfaProviderChip.value == 3,
                        onSelected: (selected) {
                          _sayfaProviderChip.mahalle(selected, 3,
                              _sayfaProviderChip.dynamicChips[3], true,en);
                          print("selected");
                          if (selected) {
                            _sayfaProviderChip
                                .renkAyarlaSelect(_sayfaProviderChip.value);
                          }
                          if (!selected) {
                            _sayfaProviderChip
                                .renkAyarlaNotSelect(3);
                          }
                        },
                      ),
                    if (_sayfaProviderChip.dynamicChips[4] != "" &&
                        _sayfaProviderChip.dynamicChips[4] != "Unnamed Road" &&
                        _sayfaProviderChip.dynamicChips[4] != ".")
                      ChoiceChip(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        label: Text(
                          _sayfaProviderChip.dynamicChips[4],
                          style: GoogleFonts.montserrat(
                              color: _sayfaProviderChip.chipRenk[4], fontWeight: FontWeight.bold),
                        ),
                        selected: _sayfaProviderChip.value == 4,
                        onSelected: (selected) {
                          _sayfaProviderChip.sokak(selected, 4,
                              _sayfaProviderChip.dynamicChips[4], true,en,boy);
                          print("selected");
                         if (selected) {
                            _sayfaProviderChip
                                .renkAyarlaSelect(_sayfaProviderChip.value);
                          }
                          if (!selected) {
                            _sayfaProviderChip
                                .renkAyarlaNotSelect(4);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              
                child: Container(
                  child: InkWell(
                    onTap: _sayfaProviderChip.mesajSayfasinaGitButtonOpacity ==
                            1
                        ? () {
                            
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
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
                                          0,
                                          Colors.red),
                                    ),
                                    ChangeNotifierProvider<
                                        NotificationHandler>.value(
                                      value: NotificationHandler(),
                                    ),
                                  ],
                                  child: AdreseMesaj(
                                      _sayfaProviderChip.sifreliMesajAdres == ""
                                          ? "**a*a"
                                          : _sayfaProviderChip
                                              .sifreliMesajAdres,
                                      _sayfaProviderChip.tamAdres,
                                      
                                      _sayfaProviderChip.value),
                                ),
                              ));
                          }
                        : null,
                    child:     AnimatedContainer(
            width: _sayfaProviderChip.anim_widthSgn,
            height: _sayfaProviderChip.anim_heightSgn,
            //en/5
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Image.asset(
                  "assets/images/rightt2.png",
                  width: _sayfaProviderChip.anim_widthSgn,
                  height: _sayfaProviderChip.anim_heightSgn,
                ),
            
            
          ),
                  ),
                ),
              ),
            ),
          
        ]),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 45,
        ),
        child: Center(
          child: ChoiceChip(
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            side: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1.0,
            ),
            backgroundColor: Colors.white,
            label: Text(
              "No Location",
              style: GoogleFonts.montserrat(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            selected: false,
            onSelected: (selected) {},
          ),
        ),
      );

      /*
      
      */
    }
  }

  haritayaDokundum() {
    // _sayfaProviderChip.haritayaDokun(placemarks[0].country.toString() +
    //    "  " +
    //    placemarks[0].isoCountryCode.toString());

    _sayfaProviderChip.adresGirBaslangic(
        placemarks[0].country.toString(),
        placemarks[0].administrativeArea.toString(),
        placemarks[0].subAdministrativeArea.toString(),
        placemarks[0].street.toString(),
        placemarks[0].thoroughfare.toString());
  }

  adresIslemleri(BuildContext context, double? lat, double? lang) async {
    // print(lat.toString()+" ******** "+lang.toString());
    try {
      placemarks = await placemarkFromCoordinates(lat!, lang!);
      haritayaDokundum();
    } catch (e) {
      
      showInSnackBar('hata', context);
    }
  }
}
