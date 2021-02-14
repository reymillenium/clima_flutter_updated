// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Screens:
import 'package:clima/screens/city_screen.dart';

// Components:
import 'package:clima/components/reusable_card.dart';

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
  // From current weather data
  double currentTemperature;
  double currentMinTemperature;
  double currentMaxTemperature;
  int currentConditionNumber;
  String cityName;
  String currentIconCode;

  // From OneCall weather data (forecast)
  String currentDescription;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeatherData, widget.oneCallWeatherData);
  }

  void updateUI(dynamic weatherData, dynamic oneCallWeatherData) {
    setState(() {
      // From current weather data
      currentTemperature = pick(weatherData, 'main', 'temp').asDoubleOrNull() ?? -100;
      currentMinTemperature = pick(weatherData, 'main', 'temp_min').asDoubleOrNull() ?? -100;
      currentMaxTemperature = pick(weatherData, 'main', 'temp_max').asDoubleOrNull() ?? -100;
      currentConditionNumber = pick(weatherData, 'weather', 0, 'id').asIntOrNull() ?? 0;
      cityName = pick(weatherData, 'name').asStringOrNull() ?? 'Unknown'; // * Not included on One Call
      currentIconCode = pick(weatherData, 'weather', 0, 'icon').asStringOrNull() ?? '11n';

      // From OneCall weather data (forecast)
      currentDescription = pick(oneCallWeatherData, 'current', 'weather', 0, 'description').asStringOrNull() ?? 'unknown'; // current.weather[0].description
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('images/location_background.jpg'),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
        //   ),
        // ),
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
                        updateUI(weatherData, oneCallWeatherData);
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 24.0,
                      ),
                    ),

                    // City locator button
                    FlatButton(
                      onPressed: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        if (weatherData != null) {
                          // updateUI(weatherData, );
                        }
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),

                // Row # 1: Current Weather Summary
                Expanded(
                  flex: 2,
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // cityName.toUpperCase(),
                          cityName,
                          style: kNewCityNameTitleTextStyle,
                          // style: kLabelTextStyle,
                        ),
                        Text(currentDescription),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${currentTemperature.toStringAsFixed(1)} °',
                              style: kNewHugeTemperatureValueTextStyle,
                            ),
                            Image(
                              image: weatherHelper.getOpenWeatherBigIcon(iconCode: currentIconCode),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('H: ${currentMaxTemperature.toStringAsFixed(1)} °'),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('L: ${currentMinTemperature.toStringAsFixed(1)} °'),
                          ],
                        )
                      ],
                    ),
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
                  ),
                ),

                // Row # 2:
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: null,
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
                  ),
                ),

                // Row # 3:
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: null,
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
                  ),
                ),

                // Row # 4:
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: null,
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
                  ),
                ),

                // Row # 5:
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: null,
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
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
