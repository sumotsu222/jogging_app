import 'package:jogging_app/repositories/repository.dart';

import 'package:jogging_app/injection_container.dart';


class UpdateRepository{

  UpdateRepository();

  final Repository repository = getIt<Repository>();

  dynamic update() async {

    await repository.update();
    return _getData();
  }

  dynamic _getData(){

    return repository.getData();
  }

  void clear(){
    repository.clear();
  }

}