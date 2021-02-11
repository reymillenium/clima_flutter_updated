// Packages:
import 'package:http/http.dart' as http;
import 'dart:convert';

// Constants:
import 'package:clima/utilities/constants.dart';

class NetworkHelper {
  // Gets the data given a latitude and a longitude (coordinates):
  Future getDataByCoordinates({double lat, double long}) async {
    String byCoordinatesURL = '$openWeatherMapURL?lat=$lat&lon=$long&appid=$openWeatherApiKey&units=metric';
    return await getData(url: byCoordinatesURL);
  }

  // Gets the data given a url:
  Future<dynamic> getData({String url}) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
