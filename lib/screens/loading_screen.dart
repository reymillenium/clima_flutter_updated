// Packages:
import 'package:flutter/material.dart';

// import 'package:http/http.dart';
import 'package:http/http.dart' as http;

// Services:
import 'package:clima/services/location.dart';

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

    getCurrentData();
  }

  void getCurrentData() async {
    String appID = '888e3a5d9c71ad9496ae5659aaf9bcc0';
    String byCoordinatesURL = 'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$appID';
    http.Response response = await http.get(byCoordinatesURL);

    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
    } else {
      print((response.statusCode));
    }
  }

  Map weather = {
    "coord": {"lon": -0.1257, "lat": 51.5085},
    "weather": [
      {"id": 501, "main": "Rain", "description": "moderate rain", "icon": "10n"}
    ],
    "base": "stations",
    "main": {"temp": 272.88, "feels_like": 266.74, "temp_min": 272.04, "temp_max": 273.71, "pressure": 1009, "humidity": 74},
    "visibility": 10000,
    "wind": {"speed": 5.14, "deg": 50},
    "rain": {"1h": 0.15},
    "clouds": {"all": 75},
    "dt": 1612919579,
    "sys": {"type": 1, "id": 1414, "country": "GB", "sunrise": 1612941822, "sunset": 1612976755},
    "timezone": 0,
    "id": 2643743,
    "name": "London",
    "cod": 200
  };

  // Future<http.Response> fetchAlbum() {
  //   return http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
  // }

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
