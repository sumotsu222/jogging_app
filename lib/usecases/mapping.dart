class Mapping{

  Mapping();

  makeMappingData(var rawData){
    List<List<double>> result = [];

    for(int i = 0; i < rawData.length; i++){
      result.add([rawData[i]['latitude'],rawData[i]['longitude']]);
    }

    return result;
  }

  getCameraPosition(var rawData){
    List<double> result = [];

    if(rawData.length > 0) {
      result.add(rawData[rawData.length - 1]['latitude']);
      result.add(rawData[rawData.length - 1]['longitude']);
    }

    return result;
  }

}