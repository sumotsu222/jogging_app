import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:jogging_app/usecases/update_repository.dart';
import 'package:jogging_app/usecases/get_distance.dart';
import 'package:jogging_app/usecases/mapping.dart';
import 'package:jogging_app/usecases/get_completion_time.dart';

//状態遷移
class StateController extends Bloc<AppEvent, AppState> {

  StreamSubscription<int>? _tickerSubscription;
  final Ticker _ticker;
  final _repository = UpdateRepository();
  bool  _displayUpdate = false;

  StateController({required Ticker ticker})
      :_ticker = ticker,
        super(InitialState(false,[],[],0.0,0.0));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppStart){
      yield* _mapStart(event.inputCompletionDistance);
    }
    else if(event is AppProgress){
      yield* _mapProgress(event.inputCompletionDistance);
    }
    else if(event is AppInitialization){
      yield* _mapInitialization();
    }
  }

  //開始
  Stream<AppState> _mapStart(double inputCompletionDistance) async* {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((_) => add(AppProgress(inputCompletionDistance: inputCompletionDistance)));
  }

  //記録中
  Stream<AppState> _mapProgress(double inputCompletionDistance) async* {
    final distance;
    final mappingData;
    final cameraPosition;
    final data;
    final completionTime;

    //リポジトリアップデート
    data = await _repository.update();
    //累積走行距離の算出
    distance = GetDistance().getDistance(data);
    //完了予定時間の算出

    completionTime = GetCompletionTime().getCompletionTime(data,inputCompletionDistance,distance);

    //経度、緯度の配列取得
    mappingData = Mapping().makeMappingData(data);
    //カメラ位置取得
    cameraPosition = Mapping().getCameraPosition(data);

    _displayUpdate = !_displayUpdate;
    yield WhileJogging(_displayUpdate,mappingData,cameraPosition,distance,completionTime);
  }

  //初期化
  Stream<AppState> _mapInitialization() async* {
    final cameraPosition;
    final data;

    //リポジトリアップデート
    data = await _repository.update();
    //カメラ位置取得
    cameraPosition = Mapping().getCameraPosition(data);

    _tickerSubscription?.cancel();
    _repository.clear();
    yield InitialState(_displayUpdate,[],cameraPosition,0.0,0.0);
  }
}

//状態定義
abstract class AppState extends Equatable {
  final bool displayUpdate;
  final List<List<double>> mappingData;
  final List<double> cameraPosition;
  final double distance;
  final double completionTime;

  const AppState(this.displayUpdate,this.mappingData,this.cameraPosition,this.distance,this.completionTime);

  @override
  List<Object> get props => [displayUpdate,mappingData,cameraPosition,distance,completionTime];
}

class InitialState extends AppState{
  const InitialState(
      bool displayUpdate,
      List<List<double>> mappingData,
      List<double> cameraPosition,
      double distance,
      double completionTime,
      ) : super(displayUpdate,mappingData,cameraPosition,distance,completionTime);
}
class WhileJogging extends AppState{
  const WhileJogging(
      bool displayUpdate,
      List<List<double>> mappingData,
      List<double> cameraPosition,
      double distance,
      double completionTime,
      ) : super(displayUpdate,mappingData,cameraPosition,distance,completionTime);
}


//イベント定義
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AppEvent{
  final double inputCompletionDistance;
  const AppStart({this.inputCompletionDistance = 0.0});

  @override
  List<Object> get props => [inputCompletionDistance];
}

class AppProgress extends AppEvent{
  final double inputCompletionDistance;
  const AppProgress({this.inputCompletionDistance = 0.0});

  @override
  List<Object> get props => [inputCompletionDistance];
}
class AppInitialization extends AppEvent{
  const AppInitialization();
}


//表示アップデートタイミング設定
class Ticker {
  const Ticker();
  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 2),(_) => _);
  }
}
