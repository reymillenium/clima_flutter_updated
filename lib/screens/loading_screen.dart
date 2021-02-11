// Packages:
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

// Services:
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

// Screens:
import 'package:clima/screens/location_screen.dart';

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
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return LocationScreen(
    //     locationWeatherData: weatherData,
    //   );
    // }));

    // Using an animated transition between two screens:
    // Navigator.push(context, _createRoute(destiny: LocationScreen(locationWeatherData: weatherData)));
    Navigator.of(context).push(_createRoute(destiny: LocationScreen(locationWeatherData: weatherData)));
  }

  final spinkit = SpinKitDualRing(
    color: Colors.white,
    size: 100.0,
    // duration: Duration(milliseconds: 3000),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: spinkit,
    ));
  }
}

Route _createRoute({Widget destiny}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destiny,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
