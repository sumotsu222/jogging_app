class Distance {

  Distance();

  double calcDistance(List<double> data){
    double _distance = 0.0;

    data.forEach((item){
      _distance = _distance + item;
    });

    return _distance;
  }
}