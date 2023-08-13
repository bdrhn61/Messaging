import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GpsKonum extends StatefulWidget {
  @override
  GpsKonumState createState() => GpsKonumState();
}

class GpsKonumState extends State<GpsKonum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("konum"),
              onPressed: () {
                konumal();
              },
            ),
            ElevatedButton(
              child: Text("cancel"),
              onPressed: () {
                dur();
              },
            ),
            ElevatedButton(
              child: Text("servis dur"),
              onPressed: () {
                servisDur();
              },
            ),
            Text('Service enabled: ${_serviceEnabled ?? "unknown"}',
                style: Theme.of(context).textTheme.bodyText1),
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 42),
                  child: ElevatedButton(
                    child: const Text('Check'),
                    onPressed: _checkService,
                  ),
                ),
                ElevatedButton(
                  child: const Text('Request'),
                  onPressed: _serviceEnabled == true ? null : _requestService,
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  late StreamSubscription<LocationData> locationSubscription;
  Location location = new Location();
  late bool _serviceEnabled;
  servisDur() async {
    _serviceEnabled = false; //= await location.serviceEnabled();
  }

  dur() {
    locationSubscription.cancel();
  }

  konumal() async {
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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

    _locationData = await location.getLocation();
    print(_locationData.latitude.toString() +
        "  --  " +
        _locationData.longitude.toString());

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
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }
}
