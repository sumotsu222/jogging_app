import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jogging_app/presentation/state_controller.dart';

class InputController extends StatefulWidget {

  @override
  State<InputController>  createState() => _InputController();
}

class _InputController extends State<InputController> {
  TextEditingController _controller = TextEditingController(text: '0.0');
  String _inputStr = '0.0';
  double _inputCompletionDistance = 0.0;
  bool _isEnabled = false;

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
          iconSize: 50,
          icon: Icon(Icons.play_arrow),
          onPressed: (){appStart(); },
        ),
        Container(
          width: 150,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '予想走行距離(km)',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _inputStr = value;
            },
          ),
        ),
        IconButton(
          iconSize: 50,
          icon: Icon(Icons.stop),
          onPressed: (){appFinish(); },
        ),
      ]
    );
  }

  Future<String?> appStart() {
    if(_isEnabled == false) {
      _isEnabled = true;
      try {
        _inputCompletionDistance = double.parse(_inputStr) * 1000; //km → m
        BlocProvider.of<StateController>(context).add(
            AppStart(inputCompletionDistance: _inputCompletionDistance));
      }
      catch (BadNumberFormatException) {
        return showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('エラー'),
              content: const Text(
                  '走行予定距離を入力してください。\n入力可能な数値：0.00〜\n\n例：1(1km)、1.1(1.1km)'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
        );
      }
    }
    return Future.value('');
  }

  void appFinish() {
    _isEnabled = false;
    BlocProvider.of<StateController>(context).add(AppInitialization());
  }
}