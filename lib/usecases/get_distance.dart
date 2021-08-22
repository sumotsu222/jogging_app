import 'package:jogging_app/entities/distance.dart';

class GetDistance{

  GetDistance();

  double getDistance(var rawData){
    List<double> _data;
    double _distance;

    _data = _makeDistanceData(rawData);

    //距離を計算
    _distance = Distance().calcDistance(_data);

    return _distance;
  }

  List<double> _makeDistanceData(var rawData){

    List<double> _result = [];

    for(int i=0; i<rawData.length; i++){
      _result.add(rawData[i]['distance']);
    }

    return _result;
  }


}