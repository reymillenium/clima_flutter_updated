// Packages:
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:deep_pick/deep_pick.dart';

// Services:
import 'package:clima/services/weather.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  // Properties:
  WeatherModel weatherHelper = WeatherModel();
  double temperature;
  int conditionNumber;
  String cityName;
  String iconCode;
  FocusNode myFocusNode;
  Timer searchOnStoppedTyping;
  // String cityName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
  }

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

  void updateUI(dynamic weatherData) {
    setState(() {
      temperature = pick(weatherData, 'main', 'temp').asDoubleOrNull() ?? -100;
      conditionNumber = pick(weatherData, 'weather', 0, 'id').asIntOrNull() ?? 0;
      cityName = pick(weatherData, 'name').asStringOrNull() ?? 'Error City';
      iconCode = pick(weatherData, 'weather', 0, 'icon').asStringOrNull() ?? '11n';
    });
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
                  updateUI(weatherData);
                  print(weatherData);
                },
                child: Text(
                  'Get Weather',
                  style: kButtonTextStyle,
                ),
              ),

              Text(cityName),
            ],
          ),
        ),
      ),
    );
  }
}
