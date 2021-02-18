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
  final airPollutionWeatherDataAQICN;

  // Constructor:
  LocationScreen({
    this.locationWeatherData,
    this.oneCallWeatherData,
    this.airPollutionWeatherData,
    this.airPollutionWeatherDataAQICN,
  });

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Properties:
  WeatherModel weatherHelper = WeatherModel();
  // From current weather data:
  double currentTemperature;
  double currentMinTemperature;
  double currentMaxTemperature;
  int currentConditionNumber;
  String cityName;
  String currentIconCode;
  int sunrise;
  int sunset;

  // From OneCall weather data (forecast):
  String currentDescription;
  dynamic hourlyForecast;
  dynamic dailyForecast;

  // From Air Pollution weather data:
  double aqi; // Air Quality Index
  double co; // Сoncentration of CO (Carbon monoxide), μg/m3
  double no; // Сoncentration of NO (Nitrogen monoxide), μg/m3
  double no2; // Сoncentration of NO2 (Nitrogen dioxide), μg/m3
  double o3; // Сoncentration of O3 (Ozone), μg/m3
  double so2; // Сoncentration of SO2 (Sulphur dioxide), μg/m3
  double pm2_5; // Сoncentration of PM2.5 (Fine particles matter), μg/m3
  double pm10; // Сoncentration of PM10 (Coarse particulate matter), μg/m3
  double nh3; // Сoncentration of NH3 (Ammonia), μg/m3

  // From AQICN (https://aqicn.org/):
  int aqiAQICN; // Air Quality Index

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeatherData, widget.oneCallWeatherData, widget.airPollutionWeatherData, widget.airPollutionWeatherDataAQICN);
  }

  void updateUI(dynamic weatherData, dynamic oneCallWeatherData, dynamic airPollutionWeatherData, dynamic airPollutionWeatherDataAQICN) {
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
      currentDescription = pick(oneCallWeatherData, 'current', 'weather', 0, 'description').asStringOrNull() ?? 'unknown';
      hourlyForecast = pick(oneCallWeatherData, 'hourly').value;
      dailyForecast = pick(oneCallWeatherData, 'daily').value;

      // From Air Pollution weather data:
      aqi = pick(airPollutionWeatherData, 'list', 0, 'main', 'aqi').asDoubleOrNull(); // Air Quality Index
      // print(aqi);
      co = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'co').asDoubleOrNull(); // Сoncentration of CO (Carbon monoxide), μg/m3
      no = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'no').asDoubleOrNull(); // Сoncentration of NO (Nitrogen monoxide), μg/m3
      no2 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'no2').asDoubleOrNull(); // Сoncentration of NO2 (Nitrogen dioxide), μg/m3
      o3 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'o3').asDoubleOrNull(); // Сoncentration of O3 (Ozone), μg/m3
      so2 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'so2').asDoubleOrNull(); // Сoncentration of SO2 (Sulphur dioxide), μg/m3
      pm2_5 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'pm2_5').asDoubleOrNull(); // Сoncentration of PM2.5 (Fine particles matter), μg/m3
      pm10 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'pm10').asDoubleOrNull(); // Сoncentration of PM10 (Coarse particulate matter), μg/m3
      nh3 = pick(airPollutionWeatherData, 'list', 0, 'main', 'components', 'nh3').asDoubleOrNull(); // Сoncentration of NH3 (Ammonia), μg/m3

      // From AQICN (https://aqicn.org/):
      aqiAQICN = pick(airPollutionWeatherDataAQICN, 'data', 'aqi').asIntOrNull(); // Air Quality Index AQICN
      // print(aqiAQICN);
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
                        var airPollutionWeatherDataAQICN = await WeatherModel().getCurrentLocationAirPollutionDataAQICN();
                        updateUI(
                          weatherData,
                          oneCallWeatherData,
                          airPollutionWeatherData,
                          airPollutionWeatherDataAQICN,
                        );
                      },
                      onPressedTopRight: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        double latitude = weatherData['coord']['lat'];
                        double longitude = weatherData['coord']['lon'];
                        var oneCallWeatherData = await weatherHelper.getOneCallWeatherByCoordinates(latitude: latitude, longitude: longitude);
                        var airPollutionWeatherData = await weatherHelper.getAirPollutionDataByCoordinates(latitude: latitude, longitude: longitude);
                        var airPollutionWeatherDataAQICN = await WeatherModel().getCurrentLocationAirPollutionDataAQICN();
                        if (weatherData != null) {
                          updateUI(
                            weatherData,
                            oneCallWeatherData,
                            airPollutionWeatherData,
                            airPollutionWeatherDataAQICN,
                          );
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
                      dailyForecast: dailyForecast,
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
                  height: 120,
                  child: ReusableCard(
                    color: kNewTestingCardColor,
                    cardChild: AirQualityCardChild(
                      aqi: aqiAQICN,
                    ),
                    onTapEvent: null,
                  ),
                ),

                // Row # 5: Extra data
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
