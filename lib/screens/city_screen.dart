// Packages:
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:deep_pick/deep_pick.dart';

// Screens:
import 'package:clima/screens/location_screen.dart';

// Services:
import 'package:clima/services/weather.dart';
import 'package:clima/services/routes.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  // Properties:
  WeatherModel weatherHelper = WeatherModel();
  String cityName;
  Timer searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 500); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () {
          setState(() {
            cityName = value;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 50.0,
                  ),
                ),
              ),

              // TextField
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  autofocus: true,
                  style: kTextFieldInputStyle,
                  decoration: kTextFieldDecoration,
                  cursorColor: Colors.blue,
                  onChanged: (value) {
                    _onChangeHandler(value);
                  },
                ),
              ),

              // Search button
              FlatButton(
                onPressed: () async {
                  var weatherData = await weatherHelper.getCityWeather(cityName: cityName);
                  if (weatherData != null) {
                    RoutesHelper routesHelper = RoutesHelper();
                    Navigator.of(context).push(routesHelper.createRoute(destiny: LocationScreen(locationWeatherData: weatherData)));
                  } else {
                    String alertMessage = cityName == null ? 'You must type the name of a valid city' : 'That city does not exist.';
                    weatherHelper.createAlert(context, alertMessage).show();
                  }
                },
                child: Text(
                  'Get Weather',
                  style: kButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
