// Packages:
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Services:
import 'package:clima/services/location.dart';

// Constants:
import 'package:clima/utilities/constants.dart';

Location location = Location();

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    // Location location = Location();
    await location.getCurrentLocation();
    print('Latitude: ${location.latitude} & Longitude: ${location.longitude}');

    getDataByCoordinates(lat: location.latitude, long: location.longitude);
  }

  void getDataByCoordinates({double lat, double long}) async {
    String byCoordinatesURL = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$openWeatherApiKey';
    http.Response response = await http.get(byCoordinatesURL);

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      // double longitude = jsonDecode(data)['coord']['lon'];
      // print('Longitude: $longitude');
      // String description = jsonDecode(data)['weather'][0]['description'];
      // print('Description: $description');

      dynamic decodedData = jsonDecode(data);
      double temperature = decodedData['main']['temp'];
      int conditionNumber = decodedData['weather'][0]['id'];
      String cityName = decodedData['name'];

      // print('Temperature: $temperature');
      // print('conditionNumber: $conditionNumber');
      // print('cityName: $cityName');
    } else {
      print((response.statusCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          color: Colors.red,
        ));
  }
}
