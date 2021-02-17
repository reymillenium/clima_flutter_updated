// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Screens:
import 'package:clima/screens/city_screen.dart';

// Components:
import 'package:clima/components/reusable_card.dart';
import 'package:clima/components/current_weather_summary_card.dart';
import 'package:clima/components/horizontal_hourly_forecast_card_child.dart';
import 'package:clima/components/daily_forecast_card_child.dart';
import 'package:clima/components/gradient_rect_slider_track_shape.dart';
import 'package:clima/components/air_quality_card_child.dart';

// Services:
import 'package:clima/services/weather.dart';
import 'package:clima/services/routes.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  // Properties:
  final locationWeatherData;
  final oneCallWeatherData;
  final airPollutionWeatherData;

  // Constructor:
  LocationScreen({
    this.locationWeatherData,
    this.oneCallWeatherData,
    this.airPollutionWeatherData,
  });

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
  int sunrise;
  int sunset;
  int aqi;

  // From OneCall weather data (forecast)
  String currentDescription;
  dynamic hourlyForecast;
  dynamic dailyForecast;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeatherData, widget.oneCallWeatherData, widget.airPollutionWeatherData);
  }

  void updateUI(dynamic weatherData, dynamic oneCallWeatherData, dynamic airPollutionWeatherData) {
    setState(() {
      // From current weather data:
      currentTemperature = pick(weatherData, 'main', 'temp').asDoubleOrNull() ?? -100;
      currentMinTemperature = pick(weatherData, 'main', 'temp_min').asDoubleOrNull() ?? -100;
      currentMaxTemperature = pick(weatherData, 'main', 'temp_max').asDoubleOrNull() ?? -100;
      currentConditionNumber = pick(weatherData, 'weather', 0, 'id').asIntOrNull() ?? 0;
      cityName = pick(weatherData, 'name').asStringOrNull() ?? 'Unknown'; // * Not included on One Call
      currentIconCode = pick(weatherData, 'weather', 0, 'icon').asStringOrNull() ?? '11n';
      sunrise = pick(weatherData, 'sys', 'sunrise').asIntOrNull() ?? 0;
      sunset = pick(weatherData, 'sys', 'sunset').asIntOrNull() ?? 0;

      // From OneCall weather data (forecast):
      currentDescription = pick(oneCallWeatherData, 'current', 'weather', 0, 'description').asStringOrNull() ?? 'unknown'; // current.weather[0].description
      hourlyForecast = pick(oneCallWeatherData, 'hourly').value;
      dailyForecast = pick(oneCallWeatherData, 'daily').value;

      // From Air Pollution weather data:
      aqi = pick(airPollutionWeatherData, 'list', 0, 'main', 'aqi').asIntOrNull(); // list[0].main.aqi
      // print(aqi);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Row # 1: Current Weather Summary
                SizedBox(
                  height: 250,
                  child: ReusableCard(
                    // color: kActiveCardColor,
                    color: kNewTestingCardColor,
                    cardChild: CurrentWeatherSummaryCard(
                      cityName: cityName,
                      currentDescription: currentDescription,
                      currentTemperature: currentTemperature,
                      weatherBigIcon: weatherHelper.getOpenWeatherBigIcon(iconCode: currentIconCode),
                      currentIconCode: currentIconCode,
                      currentMaxTemperature: currentMaxTemperature,
                      currentMinTemperature: currentMinTemperature,
                      onPressedTopLeft: () async {
                        var weatherData = await weatherHelper.getCurrentLocationCurrentWeather();
                        var oneCallWeatherData = await weatherHelper.getCurrentLocationOneCallWeather();
                        var airPollutionWeatherData = await weatherHelper.getCurrentLocationAirPollutionData();
                        updateUI(weatherData, oneCallWeatherData, airPollutionWeatherData);
                      },
                      onPressedTopRight: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        double latitude = weatherData['coord']['lat'];
                        double longitude = weatherData['coord']['lon'];
                        var oneCallWeatherData = await weatherHelper.getOneCallWeatherByCoordinates(latitude: latitude, longitude: longitude);
                        var airPollutionWeatherData = await weatherHelper.getAirPollutionDataByCoordinates(latitude: latitude, longitude: longitude);
                        if (weatherData != null) {
                          updateUI(weatherData, oneCallWeatherData, airPollutionWeatherData);
                        }
                      },
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 2: Horizontal Hourly
                SizedBox(
                  height: 150,
                  child: ReusableCard(
                    // color: kActiveCardColor,
                    color: kNewTestingCardColor,
                    cardChild: HorizontalHourlyForecastCardChild(
                      currentIconCode: currentIconCode,
                      currentTemperature: currentTemperature,
                      sunrise: sunrise,
                      sunset: sunset,
                      hourlyForecast: hourlyForecast,
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 3: Daily Forecast
                SizedBox(
                  height: 350,
                  child: ReusableCard(
                    color: kNewTestingCardColor,
                    cardChild: DailyForecastCardChild(
                      dailyForecast: dailyForecast,
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 4: Air Quality
                SizedBox(
                  height: 100,
                  child: ReusableCard(
                    color: kNewTestingCardColor,
                    cardChild: AirQualityCardChild(
                      aqi: 51,
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 5:
                SizedBox(
                  height: 100,
                  child: ReusableCard(
                    color: kActiveCardColor,
                    cardChild: null,
                    onTapEvent: null,
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
