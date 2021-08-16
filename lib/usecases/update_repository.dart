import 'package:jogging_app/repositories/repository_impl.dart';

class UpdateRepository{

  UpdateRepository();

  final repository = RepositoryImpl();

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