import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:jogging_app/repositories/repository.dart';

class RepositoryTestData extends Repository{

  //data structure:[time,latitude,longitude,distance]
  var _result=[];
  double _latitude=0.0;
  double _longitude=0.0;

  RepositoryTestData();

  Future<void> update() async{
    DateTime _time;
    double _distance = 0.0;
    Position _position;

    if(_result.length > 0){
      _distance = 20.0;
      _latitude  = _latitude  + ((Random().nextDouble()-0.5)/500);
      _longitude = _longitude + ((Random().nextDouble()-0.5)/500);

    }
    else{
      _position = await _determinePosition();
      _latitude  = _position.latitude;
      _longitude = _position.longitude;
    }

    _time = DateTime.now();

    _result.add({
      'time'     : _time,
      'latitude' : _latitude,
      'longitude': _longitude,
      'distance' : _distance
    });

  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }


  dynamic getData() {
    return _result;
  }

  void clear(){
    _result=[];
  }
}