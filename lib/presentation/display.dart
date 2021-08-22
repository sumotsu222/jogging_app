import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:jogging_app/presentation/state_controller.dart';

class Display extends StatelessWidget {

  Completer<GoogleMapController> _controller = Completer();

  String _distance = '';
  List<List<double>> _mappingData = [];
  List<double> _cameraPosition = [];
  String _completionTime = '';

  //表示データの単位調整
  Display(AppState state){
    _distance = (state.distance/1000).toStringAsFixed(2).toString();
    _mappingData = state.mappingData;
    _cameraPosition = state.cameraPosition;
    if(state.completionTime != 0.0) {
      _completionTime =
          (((state.completionTime / 1000) / 60)).toStringAsFixed(2).toString();
    }
    else{
      _completionTime = ' - ';
    }

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
                  polylines: testPolyline(_mappingData),
                  myLocationEnabled: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('走行距離:$_distance km'),
                  Text(' 完了予定時間:$_completionTime min'),
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
    _mappingData.forEach((item) {
      polygonCords.add(LatLng(item[0], item[1]));
    });
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
}
