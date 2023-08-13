// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:space/BildirimGonderme/notificationHandler.dart';
import 'package:space/gpsKonum2.dart';
import 'package:space/providerlar/adreseMesajProvider.dart';
import 'package:space/publicMesaj/adreseMesaj.dart';
import 'package:space/toastSnackBar.dart';

class Harita extends StatefulWidget {
  @override
  _HaritaState createState() => _HaritaState();
}

class _HaritaState extends State<Harita> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};
  //LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  late AdreseMesajProvider sayfaProvider;
  late GoogleMapController con;
  late int mevkiSayisi;
  late List<Color> renk;
  late Chipler _chipler;
  late double en;
  late double boy;
  GpsKonum2 gpsKonum = GpsKonum2();
  CameraPosition pozisyon =
      CameraPosition(target: LatLng(33.2097068, -126.8814167), zoom: 0.0);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    controller.setMapStyle(Utils.mapStyle);
  }

  @override
  void initState() {
    renk = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black
    ];
    _chipler = Chipler( boy: null, controller: _controller, en: null, renk: [],)
    super.initState();
    print("harita init*-*-*-*-*-*-*-*-*-*");
  }

  @override
  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    print("HArit build");
    sayfaProvider = Provider.of<AdreseMesajProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        print("sssssss");
        neverSatisfied(context);
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: GoogleMap(
                      //  mapType: MapType.normal,

                      onMapCreated: _onMapCreated,
                      zoomControlsEnabled: false,

                      initialCameraPosition: pozisyon,
                      //mapType: _currentMapType,
                      markers: _markers,

                      onTap: (LatLng latLng) {
                        haritayaDokun(latLng);
                      },
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        //map hareket etmesi için
                        new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                        ),
                      ].toSet(),
                    ),
                  ),
                ),
              ),
              Center(
                  heightFactor: 2,
                  child: //chipler(sayfaProvider.dynamicChips),

                      Chipler( boy: null, controller: _controller, en: null, renk: [],)
                  //
                  ),
            ],
          )),
    );
  }

  late List<Placemark> placemarks;
  Future<void> haritayaDokun(LatLng latLng) async {
    //final coordinates = new Coordinates(latLng.latitude, latLng.longitude);

    // var latitude = latLng.latitude;
    // var longitude = latLng.longitude;
    // print(latitude.toString() + " aa " + longitude.toString());

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///
    ///
    try {
      placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    } catch (e) {
    
      showInSnackBar(e.hashCode.toString(), context);
    }

    debugPrint("ULKE:  " + placemarks[0].country.toString());
    debugPrint("isoCountryCode:  " + placemarks[0].isoCountryCode.toString());

    debugPrint("posta kodu:  " + placemarks[0].postalCode.toString());
    debugPrint("ŞEHİR:  " + placemarks[0].administrativeArea.toString());
    debugPrint("MAHALLE:  " + placemarks[0].street.toString());
    debugPrint("SOKAK:  " + placemarks[0].thoroughfare.toString());
    debugPrint("locality:  " + placemarks[0].locality.toString());
    debugPrint("name:  " + placemarks[0].name.toString());
    debugPrint(
        "subAdministrativeArea:  " + placemarks[0].subAdministrativeArea.toString());
    debugPrint("subLocality:  " + placemarks[0].subLocality.toString());
    debugPrint("subThoroughfare:  " + placemarks[0].subThoroughfare.toString());

    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    _chipler.haritayaDokundum(placemarks);
    /*
   
    sayfaProvider.haritayaDokun(placemarks[0].country.toString() +
        "  " +
        placemarks[0].isoCountryCode.toString());

    sayfaProvider.adresGir(
        placemarks[0].country.toString(),
        placemarks[0].administrativeArea.toString(),
        placemarks[0].subAdministrativeArea.toString(),
        placemarks[0].street.toString(),
        placemarks[0].thoroughfare.toString());
     */
  }

// KULLANILMIYOR

}

AdreseMesajProvider? _sayfaProviderChip;

class Chipler extends StatelessWidget {
  List<Color> renk;
  Completer<GoogleMapController> controller;
  double en;
  double boy;
  Chipler({
    Key? key,
    required this.renk,
    required this.controller,
    required this.en,
    required this.boy,
  }) : super(key: key);
  GpsKonum2 gpsKonum = GpsKonum2();

  Widget build(BuildContext context) {
    en = MediaQuery.of(context).size.width;
    boy = MediaQuery.of(context).size.height;
    print("Chip build");
    _sayfaProviderChip = Provider.of<AdreseMesajProvider>(context);

    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 14, left: 5, right: 5),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 5.0,
              runSpacing: 5.0,
              children: [
                if (_sayfaProviderChip?.dynamicChipsHarita[0] != "" &&
                    _sayfaProviderChip?.dynamicChipsHarita[0] !=
                        "Unnamed Road" &&
                    _sayfaProviderChip?.dynamicChipsHarita[0] != ".")
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
                    selected: _sayfaProviderChip?.aderseMesajvalue == 0,
                    label: Text(
                      _sayfaProviderChip!.dynamicChipsHarita[0],
                      style: GoogleFonts.montserrat(
                          color: renk[0], fontWeight: FontWeight.bold),
                    ),
                    onSelected: (selected) {
                      _sayfaProviderChip.ulke(selected, 0,
                          _sayfaProviderChip?.dynamicChipsHarita[0], false, en);
                      print("selected");
                      if (selected) {
                        renk[0] = Colors.white;
                        renk[1] = Colors.black;
                        renk[2] = Colors.black;
                        renk[3] = Colors.black;
                        renk[4] = Colors.black;
                      }
                      if (!selected) {
                        renk[0] = Colors.black;
                      }
                    },
                  ),
                if (_sayfaProviderChip?.dynamicChipsHarita[1] != "" &&
                    _sayfaProviderChip?.dynamicChipsHarita[1] !=
                        "Unnamed Road" &&
                    _sayfaProviderChip?.dynamicChipsHarita[1] != ".")
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
                      _sayfaProviderChip!.dynamicChipsHarita[1],
                      style: GoogleFonts.montserrat(
                          color: renk[1], fontWeight: FontWeight.bold),
                    ),
                    selected: _sayfaProviderChip?.aderseMesajvalue == 1,
                    onSelected: (selected) {
                      _sayfaProviderChip?.sehir(selected, 1,
                          _sayfaProviderChip?.dynamicChipsHarita[1], false, en);
                      print("selected");
                      if (selected) {
                        renk[0] = Colors.black;
                        renk[1] = Colors.white;
                        renk[2] = Colors.black;
                        renk[3] = Colors.black;
                        renk[4] = Colors.black;
                      }
                      if (!selected) {
                        renk[1] = Colors.black;
                      }
                    },
                  ),
                if (_sayfaProviderChip?.dynamicChipsHarita[2] != "" &&
                    _sayfaProviderChip?.dynamicChipsHarita[2] !=
                        "Unnamed Road" &&
                    _sayfaProviderChip?.dynamicChipsHarita[2] != ".")
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
                      _sayfaProviderChip!.dynamicChipsHarita[2],
                      style: GoogleFonts.montserrat(
                          color: renk[2], fontWeight: FontWeight.bold),
                    ),
                    selected: _sayfaProviderChip?.aderseMesajvalue == 2,
                    onSelected: (selected) {
                      _sayfaProviderChip?.ilce(selected, 2,
                          _sayfaProviderChip?.dynamicChipsHarita[2], false, en);
                      print("selected");
                      if (selected) {
                        renk[0] = Colors.black;
                        renk[1] = Colors.black;
                        renk[2] = Colors.white;
                        renk[3] = Colors.black;
                        renk[4] = Colors.black;
                      }
                      if (!selected) {
                        renk[2] = Colors.black;
                      }
                    },
                  ),
                if (_sayfaProviderChip?.dynamicChipsHarita[3] != "" &&
                    _sayfaProviderChip?.dynamicChipsHarita[3] !=
                        "Unnamed Road" &&
                    _sayfaProviderChip?.dynamicChipsHarita[3] != ".")
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
                      _sayfaProviderChip!.dynamicChipsHarita[3],
                      style: GoogleFonts.montserrat(
                          color: renk[3], fontWeight: FontWeight.bold),
                    ),
                    selected: _sayfaProviderChip?.aderseMesajvalue == 3,
                    onSelected: (selected) {
                      _sayfaProviderChip?.mahalle(selected, 3,
                          _sayfaProviderChip?.dynamicChipsHarita[3], false, en);
                      print("selected");
                      if (selected) {
                        renk[0] = Colors.black;
                        renk[1] = Colors.black;
                        renk[2] = Colors.black;
                        renk[3] = Colors.white;
                        renk[4] = Colors.black;
                      }
                      if (!selected) {
                        renk[3] = Colors.black;
                      }
                    },
                  ),
                if (_sayfaProviderChip?.dynamicChipsHarita[4] != "" &&
                    _sayfaProviderChip?.dynamicChipsHarita[4] !=
                        "Unnamed Road" &&
                    _sayfaProviderChip?.dynamicChipsHarita[4] != ".")
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
                      _sayfaProviderChip!.dynamicChipsHarita[4],
                      style: GoogleFonts.montserrat(
                          color: renk[4], fontWeight: FontWeight.bold),
                    ),
                    selected: _sayfaProviderChip?.aderseMesajvalue == 4,
                    onSelected: (selected) {
                      _sayfaProviderChip?.sokak(
                          selected,
                          4,
                          _sayfaProviderChip?.dynamicChipsHarita[4],
                          false,
                          en,
                          boy);
                      print("selected");
                      if (selected) {
                        renk[0] = Colors.black;
                        renk[1] = Colors.black;
                        renk[2] = Colors.black;
                        renk[3] = Colors.black;
                        renk[4] = Colors.white;
                      }
                      if (!selected) {
                        renk[4] = Colors.black;
                      }
                    },
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(top: boy / 65, right: boy / 50),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      print("global Adressss" +
                          _sayfaProviderChip!.sifreliMesajAdresHarita);
                      if (_sayfaProviderChip
                              ?.mesajSayfasinaGitButtonOpacityadreseMesaj ==
                          1)
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
                                    null,
                                    Colors.red),
                              ),
                              ChangeNotifierProvider<NotificationHandler>.value(
                                value: NotificationHandler(),
                              ),
                            ],
                            child: AdreseMesaj(
                                _sayfaProviderChip?.sifreliMesajAdresHarita == ""
                                    ? "**a*a"
                                    : _sayfaProviderChip!
                                        .sifreliMesajAdresHarita,
                                _sayfaProviderChip!.tamAdresHarita,
                                _sayfaProviderChip!.aderseMesajvalue),
                          ),
                        ));
                    },
                    child: AnimatedContainer(
                      width: _sayfaProviderChip?.anim_width,
                      height: _sayfaProviderChip?.anim_height,
                      //en/5
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                      child: Image.asset(
                        "assets/images/rightt2.png",
                        width: _sayfaProviderChip?.anim_width,
                        height: _sayfaProviderChip?.anim_height,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(top: boy / 1.26, left: en / 2.5, right: en / 2.5),
        child: InkWell(
          onTap: () async {
            await gpsKonum.konumal();

            //_sayfaProviderChip.haritaCameraPositionAta(15, 15);

            final GoogleMapController controller = await _controller.future;
            controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(gpsKonum.locationData.latitude,
                  gpsKonum.locationData.longitude),
              zoom: 15,
            )));

            //  CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);
            // CameraUpdate zoom = CameraUpdate.zoomTo(16);
          },
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/harita-konum.png",
              width: boy / 16,
              height: boy / 16,
            ),
          ),
        ),
      ),
    ]);
  }

  haritayaDokundum(List<Placemark> placemarks) {
    print("renk atandı");
    if (_sayfaProviderChip?.aderseMesajvalue != null)
      renk[_sayfaProviderChip!.aderseMesajvalue] = Colors.black;

    _sayfaProviderChip?.adreseMesajValueNullYap();

    // _sayfaProviderChip.haritayaDokun(placemarks[0].country.toString() +
    //     "  " +
    //     placemarks[0].isoCountryCode.toString());

    _sayfaProviderChip?.adresGirHarita(
        placemarks[0].country.toString(),
        placemarks[0].administrativeArea.toString(),
        placemarks[0].subAdministrativeArea.toString(),
        placemarks[0].street.toString(),
        placemarks[0].thoroughfare.toString());
  }
}

class Utils {
  static String mapStyle = '''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "geometry.fill",
    "stylers": [
      {
        "weight": 2.5
      }
    ]
  },
  {
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "weight": 2
      }
    ]
  },
  {
    "elementType": "labels.text",
    "stylers": [
      {
        "weight": 8
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#000000"
      },
      {
        "weight": 8
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ffffff"
      },
      {
        "weight": 6
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "weight": 2.5
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2977a8"
      },
      {
        "weight": 5.5
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
]
  ''';
}

void neverSatisfied(BuildContext cntx) {
  var en = MediaQuery.of(cntx).size.width;
  print(en / 30);
  showGeneralDialog(
      context: cntx,
      pageBuilder: (cntx, anim1, anim2) {return Container(child: Text(""),);},
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: 'aaaaa',
      transitionBuilder: (cntx, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    // side:  BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(16.0)),
                content: Builder(
                  builder: (cntx) {
                    double height = MediaQuery.of(cntx).size.height;
                    double width = MediaQuery.of(cntx).size.width;
                    return Container(
                      height: height / 4,
                      width: width / 4,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Are you sure you want to exit ?",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: height / 20),
                            InkWell(
                              onTap :(){

                                print("object");
                                exit(0);
                              },//
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(width / 64)),
                                child: Padding(
                                    padding: EdgeInsets.all(width / 64),
                                    child: Text("YES",
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 450));
}
