class CompletionTime {

  CompletionTime();

  //距離の単位：m
  //時間の単位：ms
  double calcCompletionTime(var _data, double distanceExpect, double distanceAlreadyCompleted){
    double _completionTime = 0.0;

    double _timeRecent = 0.0;
    double _distanceRecent = 0.0;
    double _speedRecent = 0.0;

    double _distanceLeft = 0.0;

    double _timeExpect = 0.0;
    double _timeAlreadyCompleted = 0.0;


    if(_data.length >= 4){
      //直近の速さを求める
      for(int i=_data.length-1; _data.length-3 <= i ;i--){
        _distanceRecent = _distanceRecent + _data[i]['distance'];
      }
      _timeRecent = _data[_data.length-1]['time'].difference(_data[_data.length-4]['time']).inMilliseconds.toDouble();

      if (_timeRecent != 0) {
        _speedRecent = _distanceRecent / _timeRecent;
      }

      //現時点の走行距離と予測距離を引く
      _distanceLeft = distanceExpect - distanceAlreadyCompleted;

      //完了予定時間を出す
      if(_speedRecent != 0) {
        _timeExpect = _distanceLeft / _speedRecent;
      }

      //今の走行時間と足し合わせる
      _timeAlreadyCompleted = _data[_data.length-1]['time'].difference(_data[0]['time']).inMilliseconds.toDouble();
      _completionTime = _timeExpect + _timeAlreadyCompleted;

    }
    /*
    print('----------------');
    print('distanceRecent : $_distanceRecent');
    print('timeRecent : $_timeRecent');
    print('distanceAlreadyCompleted : $distanceAlreadyCompleted');
    print('distanceLeft:$_distanceLeft');
    print('speedRcent : $_speedRecent');
    print('timeExpect : $_timeExpect');
    print('timeAlreadyCompleted : $_timeAlreadyCompleted');
    print('completionTime : $_completionTime');
    */

    if(_distanceLeft <= 0){
      _completionTime = 0.0;
    }

    return _completionTime;
  }
}