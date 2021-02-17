// Packages:
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Screens:
import 'package:clima/screens/location_screen.dart';

// Components:
import 'package:clima/components/transition_spinner.dart';

// Services:
import 'package:clima/services/routes.dart';

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
    getLocationData();
  }

  void getLocationData() async {
    var weatherData = await WeatherModel().getCurrentLocationCurrentWeather();
    var oneCallWeatherData = await WeatherModel().getCurrentLocationOneCallWeather();
    var airPollutionWeatherData = await WeatherModel().getCurrentLocationAirPollutionData();
    var airPollutionWeatherDataAQICN = await WeatherModel().getCurrentLocationAirPollutionDataAQICN();
    // print(airPollutionWeatherData);
    // await Future.delayed(const Duration(milliseconds: 500));
    RoutesHelper routesHelper = RoutesHelper();
    Navigator.of(context).push(routesHelper.createRoute(
        destiny: LocationScreen(
      locationWeatherData: weatherData,
      oneCallWeatherData: oneCallWeatherData,
      airPollutionWeatherData: airPollutionWeatherData,
      airPollutionWeatherDataAQICN: airPollutionWeatherDataAQICN,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TransitionSpinner(),
    ));
  }
}
