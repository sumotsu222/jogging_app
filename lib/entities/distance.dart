class Distance {

  Distance();

  double calcDistance(List<double> data){
    double distance = 0.0;

    data.forEach((item){
      distance = distance + item;
    });

    return distance;
  }
}