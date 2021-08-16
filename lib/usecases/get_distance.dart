import 'package:jogging_app/entities/distance.dart';

class GetDistance{

  GetDistance();

  double getDistance(var rawData){
    List<double> data;
    double distance;

    data = _makeDistanceData(rawData);

    //距離を計算
    distance = Distance().calcDistance(data);

    return distance;
  }

  List<double> _makeDistanceData(var rawData){

    List<double> result = [];

    for(int i=0; i<rawData.length; i++){
      result.add(rawData[i]['distance']);
    }

    return result;
  }


}