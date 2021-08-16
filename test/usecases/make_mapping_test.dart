import 'package:flutter_test/flutter_test.dart';
import 'package:jogging_app/usecases/mapping.dart';

void main(){

  var rawData = [{
    'time'     : '2021-08-13 18:54:11.806252',
    'latitude' : 37.4219983,
    'longitude': -122.084,
    'distance'  : 1.0
  },{
    'time'     : '2021-08-13 18:54:11.806252',
    'latitude' : 38.4219983,
    'longitude': -123.084,
    'distance'  : 0.2
  },{
    'time'     : '2021-08-13 18:54:11.806252',
    'latitude' : 39.4219983,
    'longitude': -124.084,
    'distance'  : 2.3
  }];


  test(('distance'),(){
    print('test start');

    expect(Mapping().makeMappingData(rawData),0);
  });
}