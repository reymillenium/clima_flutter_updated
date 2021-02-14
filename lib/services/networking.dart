// Packages:
import 'package:http/http.dart' as http;
import 'dart:convert';

// Constants:
import 'package:clima/utilities/constants.dart';

class NetworkHelper {
  // Gets the data given a latitude and a longitude (coordinates):
  Future getCurrentDataByCoordinates({double lat, double long}) async {
    String byCoordinatesURL = '$openWeatherMapURL?lat=$lat&lon=$long&appid=$openWeatherApiKey&units=metric';
    print(byCoordinatesURL);
    return await _getData(url: byCoordinatesURL);
  }

  // Gets all the available data in one call, given a latitude and a longitude (coordinates):
  Future getOneCallDataByCoordinates({double lat, double long}) async {
    String oneCallByCoordinatesURL = '$openWeatherOneCallURL?lat=$lat&lon=$long&appid=$openWeatherApiKey&units=metric';
    // print(oneCallByCoordinatesURL);
    return await _getData(url: oneCallByCoordinatesURL);
  }

  // Gets the data given the name of a city:
  Future getDataByCity({String cityName}) async {
    String byCityURL = '$openWeatherMapURL?q=$cityName&appid=$openWeatherApiKey&units=metric';
    return await _getData(url: byCityURL);
  }

  // Gets the data given a url:
  Future<dynamic> _getData({String url}) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
