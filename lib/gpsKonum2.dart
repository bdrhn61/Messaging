import 'dart:async';
import 'package:location/location.dart';


class GpsKonum2{
late StreamSubscription<LocationData> locationSubscription;
  Location location = new Location();
  late bool _serviceEnabled;
  late LocationData locationData;
  int sayac=0;
  servisDur() async {
    _serviceEnabled = false; //= await location.serviceEnabled();
  }

  dur() {
    locationSubscription.cancel();
  }

  konumal() async {
    PermissionStatus _permissionGranted;
    

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }


    locationData = await location.getLocation();
    print(locationData.latitude.toString() +
        "  --  " +
        locationData.longitude.toString());



/*
location.changeSettings(distanceFilter: 10);
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
print("liaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    });

    */
  }

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
     
      if (!serviceRequestedResult) {
        return;
      }
    }
  }
}