// Packages:
import 'package:flutter/material.dart';

// Constants:
import 'package:clima/utilities/constants.dart';

// Services:
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {
  // Properties:
  final locationWeatherData;

  // Constructor:
  LocationScreen({this.locationWeatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Properties:
  WeatherModel weatherHelper = WeatherModel();
  double temperature;
  int conditionNumber;
  String cityName;
  String iconCode;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      temperature = weatherData['main']['temp'];
      conditionNumber = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      iconCode = weatherData['weather'][0]['icon'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature °',
                      style: kTempTextStyle,
                    ),
                    Image(
                      image: weatherHelper.getOpenWeatherIcon(iconCode: iconCode),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "${weatherHelper.getMessage(temperature)} in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
