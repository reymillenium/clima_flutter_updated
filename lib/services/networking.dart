// Packages:
import 'package:http/http.dart' as http;
import 'dart:convert';

// Constants:
import 'package:clima/utilities/constants.dart';

class NetworkHelper {
  Future getDataByCoordinates({double lat, double long}) async {
    String byCoordinatesURL = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$openWeatherApiKey';
    http.Response response = await http.get(byCoordinatesURL);

    if (response.statusCode == 200) {
      // String data = response.body;
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
