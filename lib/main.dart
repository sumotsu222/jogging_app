import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

import 'package:jogging_app/presentation/state_controller.dart';
import 'package:jogging_app/presentation/input_controller.dart';
import 'package:jogging_app/presentation/display.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jogging_app',
      home: JoggingApp(),
    );
  }
}

class JoggingApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => StateController(ticker:Ticker()),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            BlocBuilder<StateController, AppState>(
              buildWhen: (prev, state) => (prev.displayUpdate  != state.displayUpdate) ||
                                          (prev.cameraPosition != state.cameraPosition) ,
              builder: (_, state) {
                //Googleマップとデータの表示
                return Display(state);
              },
            ),
            //ユーザー入力
            InputController(),
            //Text(debug().start().toString()),
          ]
        ),
      ),
    );
  }
}
