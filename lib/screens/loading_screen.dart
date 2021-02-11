// Packages:
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen();
    }));
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  // final spinkit = SpinKitSquareCircle(
  //   color: Colors.white,
  //   size: 50.0,
  //   controller: AnimationController(vsync: TickerProvider., duration: const Duration(milliseconds: 1200)),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          // margin: EdgeInsets.all(30),
          color: Colors.black,
          child: spinkit,
        ));
  }
}
