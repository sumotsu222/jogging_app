import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:jogging_app/usecases/update_repository.dart';
import 'package:jogging_app/usecases/get_distance.dart';
import 'package:jogging_app/usecases/mapping.dart';

//状態遷移
class StateController extends Bloc<AppEvent, AppState> {

  StreamSubscription<int>? _tickerSubscription;
  final Ticker _ticker;
  final repository = UpdateRepository();
  bool  displayUpdate = false;

  StateController({required Ticker ticker})
      :_ticker = ticker,
        super(InitialState(false,[],[],0.0));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppStart){
      yield* _mapStart(event);
    }
    else if(event is AppProgress){
      yield* _mapProgress(event);
    }
    else if(event is AppInitialization){
      yield* _mapInitialization(event);
    }
  }

  //開始
  Stream<AppState> _mapStart(AppEvent start) async* {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((_) => add(AppProgress()));
  }

  //記録中
  Stream<AppState> _mapProgress(AppEvent start) async* {
    final distance;
    final mappingData;
    final cameraPosition;
    final data;

    //リポジトリアップデート
    data = await repository.update();
    //累積走行距離の算出
    distance = GetDistance().getDistance(data);
    //経度、緯度の配列取得
    mappingData = Mapping().makeMappingData(data);
    //カメラ位置取得
    cameraPosition = Mapping().getCameraPosition(data);

    displayUpdate = !displayUpdate;
    yield WhileJogging(displayUpdate,mappingData,cameraPosition,distance);
  }

  //初期化
  Stream<AppState> _mapInitialization(AppEvent start) async* {
    final cameraPosition;
    final data;

    //リポジトリアップデート
    data = await repository.update();
    //カメラ位置取得
    cameraPosition = Mapping().getCameraPosition(data);

    _tickerSubscription?.cancel();
    repository.clear();
    yield InitialState(displayUpdate,[],cameraPosition,0.0);
  }
}

//状態定義
abstract class AppState extends Equatable {
  final bool displayUpdate;
  final List<List<double>> mappingData;
  final List<double> cameraPosition;
  final double distance;

  const AppState(this.displayUpdate,this.mappingData,this.cameraPosition,this.distance);

  @override
  List<Object> get props => [displayUpdate,mappingData,cameraPosition,distance];
}

class InitialState extends AppState{
  const InitialState(
      bool displayUpdate,
      List<List<double>> mappingData,
      List<double> cameraPosition,
      double distance,
      ) : super(displayUpdate,mappingData,cameraPosition,distance);
}
class WhileJogging extends AppState{
  const WhileJogging(
      bool displayUpdate,
      List<List<double>> mappingData,
      List<double> cameraPosition,
      double distance,
      ) : super(displayUpdate,mappingData,cameraPosition,distance);
}


//イベント定義
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AppEvent{
  final String number;
  const AppStart({this.number = '0'});

  @override
  List<Object> get props => [number];
}

class AppProgress extends AppEvent{
  const AppProgress();
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
