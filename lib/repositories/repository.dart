abstract class Repository{
  Future<bool> update();
  dynamic getData();
  void clear();
}