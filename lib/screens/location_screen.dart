// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Screens:
import 'package:clima/screens/city_screen.dart';

// Components:
import 'package:clima/components/reusable_card.dart';
import 'package:clima/components/current_weather_summary_card.dart';

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
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Row # 1: Current Weather Summary
                Expanded(
                  flex: 2,
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: CurrentWeatherSummaryCard(
                      cityName: cityName,
                      currentDescription: currentDescription,
                      currentTemperature: currentTemperature,
                      weatherBigIcon: weatherHelper.getOpenWeatherBigIcon(iconCode: currentIconCode),
                      currentIconCode: currentIconCode,
                      currentMaxTemperature: currentMaxTemperature,
                      currentMinTemperature: currentMinTemperature,
                      onPressedTopLeft: () async {
                        var oneCallWeatherData = await weatherHelper.getCurrentLocationOneCallWeather();
                        var weatherData = await weatherHelper.getCurrentLocationCurrentWeather();
                        updateUI(weatherData, oneCallWeatherData);
                      },
                      onPressedTopRight: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var oneCallWeatherData = await weatherHelper.getCurrentLocationOneCallWeather();
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        if (weatherData != null) {
                          updateUI(weatherData, oneCallWeatherData);
                        }
                      },
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 2:
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Now'),
                              Text('🌩'),
                              Text('75 °'),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('12am'),
                              Text('🌩'),
                              Text('75 °'),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [],
                        ),
                        Divider(
                          color: Colors.white70,
                          height: 20,
                          thickness: 1,
                          indent: 4,
                          endIndent: 4,
                        ),
                      ],
                    ),
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
