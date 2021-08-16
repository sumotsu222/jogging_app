import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jogging_app/presentation/state_controller.dart';

class InputController extends StatefulWidget {

  @override
  State<InputController>  createState() => _InputController();
}

class _InputController extends State<InputController> {
  final controller = TextEditingController();
  String inputStr = '0';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StateController>(context).add(AppInitialization());
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            iconSize: 60,
            icon: Icon(Icons.play_arrow),
            onPressed: () { appStart(); },
          ),
          Container(
            width: 100,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'input data',
              ),
              onChanged: (value) {
                inputStr = value;
              },
            ),
          ),
          IconButton(
            iconSize: 60,
            icon: Icon(Icons.stop),
            onPressed: () { appFinish(); },
          ),
        ]
      );
  }

  void appStart() {
    controller.clear();
    BlocProvider.of<StateController>(context).add(AppStart(number: inputStr));
  }

  void appFinish() {
    controller.clear();
    BlocProvider.of<StateController>(context).add(AppInitialization());
  }
}