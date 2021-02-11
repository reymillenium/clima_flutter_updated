// Packages:
import 'package:clima/services/routes.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Services:
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

// Screens:
import 'package:clima/screens/location_screen.dart';

// Components:
import 'package:clima/components/transition_spinner.dart';

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
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    var weatherData = await network.getDataByCoordinates(lat: location.latitude, long: location.longitude);

    // Adds an additional delay so we show a little more of the spinner:
    // await Future.delayed(const Duration(milliseconds: 500));
    RoutesHelper routesHelper = RoutesHelper();
    Navigator.of(context).push(routesHelper.createRoute(destiny: LocationScreen(locationWeatherData: weatherData)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TransitionSpinner(),
    ));
  }
}
