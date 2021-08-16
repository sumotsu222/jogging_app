import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:jogging_app/presentation/state_controller.dart';

class Display extends StatelessWidget {

  Completer<GoogleMapController> _controller = Completer();

  String _distance = '';
  List<List<double>> _mappingData = [];
  List<double> _cameraPosition = [];

  Display(AppState state){
    _distance = state.distance.toStringAsFixed(2).toString();
    _mappingData = state.mappingData;
    _cameraPosition = state.cameraPosition;

  }

  @override
  Widget build(BuildContext context){
    return Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                child: _cameraPosition.isEmpty ? CircularProgressIndicator()
                : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_cameraPosition[0],_cameraPosition[1]),
                    zoom: 14.4746,),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  //polygons: rhombusPolygon(_mappingData),
                  polylines: testPolyline(_mappingData),
                  myLocationEnabled: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('$_distance km'),
                  Text('xxx min jogging'),
                  Text('xxx min later finish'),
                ]
              ),
            ),
          ],
        ),
      );
  }
}

Set<Polyline> testPolyline(List<List<double>> _mappingData) {
  final polygonCords = <LatLng>[];

  if(_mappingData.length == 0){
    polygonCords.add(LatLng(0.0, 0.0));
  }
  else{
    _mappingData.forEach((item){
      polygonCords.add(LatLng(item[0],item[1]));
    });
    /*
    for(int i=0; i<_mappingData.length; i++){
      //polygonCords.add(LatLng(_mappingData[i][0]+(i.toDouble()/10000),_mappingData[i][1]));
      if (0 == i%2) {
        polygonCords.add(LatLng(_mappingData[i][0] + (i.toDouble() / 1000),
            _mappingData[i][1]));
      }
      else{
        polygonCords.add(LatLng(_mappingData[i][0],
            _mappingData[i][1] + (i.toDouble() / 1000)));
      }
    }
    */
  }

  final Set<Polyline>_polyLine = {};

  _polyLine.add(Polyline(
    polylineId: PolylineId('route'),
    visible: true,
    color: Colors.blue,
    width: 3,
    points: polygonCords,
  ),);

  return _polyLine;
  //return _polyLine;
}

/*
Set<Polygon> rhombusPolygon(List<List<double>> _mappingData) {
  final polygonCords = <LatLng>[];

  //ダミーデータ設定
  if(_mappingData.length == 0){
    polygonCords.add(LatLng(0.0, 0.0));
  }
  else{
    for(int i=0; i<_mappingData.length; i++){
      //polygonCords.add(LatLng(_mappingData[i][0]+(i.toDouble()/10000),_mappingData[i][1]));
      if (0 == i%2) {
        polygonCords.add(LatLng(_mappingData[i][0] + (i.toDouble() / 10000),
            _mappingData[i][1]));
      }
      else{
        polygonCords.add(LatLng(_mappingData[i][0],
            _mappingData[i][1] + (i.toDouble() / 10000)));
      }
    }
  }

  /*
  _mappingData.forEach((item){
    polygonCords.add(LatLng(item[0],item[1]));
  });
  */

  final polygonSet = <Polygon>{};
  polygonSet.add(Polygon(
    polygonId: PolygonId('test'),
    points: polygonCords,
    strokeWidth: 3,
    strokeColor: Colors.blue,
    fillColor: Colors.lightBlue.withOpacity(0),
  ));

  return polygonSet;
}
*/