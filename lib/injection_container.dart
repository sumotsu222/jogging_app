
import 'package:get_it/get_it.dart';

import 'package:jogging_app/repositories/repository.dart';
import 'package:jogging_app/repositories/repository_impl.dart';
import 'package:jogging_app/repositories/repository_test_data.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  getIt.registerSingleton<Repository>(RepositoryImpl());

}