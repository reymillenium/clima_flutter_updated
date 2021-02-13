// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';

// Screens:
import 'package:clima/screens/city_screen.dart';

// Services:
import 'package:clima/services/weather.dart';
import 'package:clima/services/routes.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  // Properties:
  final locationWeatherData;
  final oneCallWeatherData;

  // Constructor:
  LocationScreen({this.locationWeatherData, this.oneCallWeatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Properties:
  WeatherModel weatherHelper = WeatherModel();
  double currentTemperature;
  int currentConditionNumber;
  String cityName;
  String currentIconCode;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      currentTemperature = pick(weatherData, 'main', 'temp').asDoubleOrNull() ?? -100; // current.temp
      currentConditionNumber = pick(weatherData, 'weather', 0, 'id').asIntOrNull() ?? 0; // current.weather[0].id
      cityName = pick(weatherData, 'name').asStringOrNull() ?? 'Unknown'; // * Not included on One Call
      currentIconCode = pick(weatherData, 'weather', 0, 'icon').asStringOrNull() ?? '11n'; // current.weather[0].icon
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Near button
                    FlatButton(
                      onPressed: () async {
                        var oneCallWeatherData = await weatherHelper.getCurrentLocationOneCallWeather();
                        var weatherData = await weatherHelper.getCurrentLocationCurrentWeather();
                        updateUI(weatherData);
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 24.0,
                      ),
                    ),

                    // Cities locator button
                    FlatButton(
                      onPressed: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        if (weatherData != null) {
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),

                // City Name
                Text(
                  cityName,
                  style: kNewCityNameTitleTextStyle,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$currentTemperature °',
                        style: kTempTextStyle,
                      ),
                      Image(
                        image: weatherHelper.getOpenWeatherIcon(iconCode: currentIconCode),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    "${weatherHelper.getMessage(currentTemperature)} in $cityName!",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
