class Mapping{

  Mapping();

  makeMappingData(var rawData){
    List<List<double>> _result = [];

    for(int i = 0; i < rawData.length; i++){
      _result.add([rawData[i]['latitude'],rawData[i]['longitude']]);
    }

    return _result;
  }

  getCameraPosition(var rawData){
    List<double> _result = [];

    if(rawData.length > 0) {
      _result.add(rawData[rawData.length - 1]['latitude']);
      _result.add(rawData[rawData.length - 1]['longitude']);
    }

    return _result;
  }

}