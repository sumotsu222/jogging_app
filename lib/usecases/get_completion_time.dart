import 'package:jogging_app/entities/completion_time.dart';

class GetCompletionTime{

  GetCompletionTime();

  double getCompletionTime(var rawData, double distanceExpect, double distanceAlreadyCompleted){
    double _completiontime = 0.0;

    _completiontime = CompletionTime().calcCompletionTime(rawData,distanceExpect,distanceAlreadyCompleted);

    return _completiontime;
  }

}