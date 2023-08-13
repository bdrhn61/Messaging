import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class KonumIslemleri  {
 
  late Position pozisyon;
    konumGetir() async {
     pozisyon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("KONUM :  " +
        pozisyon.latitude.toString() +
        "   " +
        pozisyon.longitude.toString());

      
  }

  late Position position;
  late List<Placemark> placemarks;
  Future<List<Placemark>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("KONUM :  " +
        position.latitude.toString() +
        "   " +
        position.longitude.toString());
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    debugPrint("ULKE:  " + placemarks[0].country.toString());
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
    //debugPrint("placemark:  "+placemarks.toString());
    return placemarks;
  }

  Position getPosition() {
    return pozisyon;
  }
  List<Placemark> getPlacemark(){
    return placemarks;
  }
}
