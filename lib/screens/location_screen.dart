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
  int sunrise;
  int sunset;

  // From OneCall weather data (forecast)
  String currentDescription;
  dynamic hourlyForecast;
  dynamic dailyForecast;

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
      sunrise = pick(weatherData, 'sys', 'sunrise').asIntOrNull() ?? 0;
      sunset = pick(weatherData, 'sys', 'sunset').asIntOrNull() ?? 0;
      // print('Sunrise: $sunrise');
      // print('Sunset: $sunset');
      // print('Sunrise2: ${pick(oneCallWeatherData, 'current', 'sunrise').asIntOrNull()}'); // current.sunrise
      // print('Sunset2: ${pick(oneCallWeatherData, 'current', 'sunset').asIntOrNull()}'); // current.sunset

      // From OneCall weather data (forecast)
      currentDescription = pick(oneCallWeatherData, 'current', 'weather', 0, 'description').asStringOrNull() ?? 'unknown'; // current.weather[0].description
      hourlyForecast = pick(oneCallWeatherData, 'hourly').value;
      dailyForecast = pick(oneCallWeatherData, 'daily').value;
      // print(pick(oneCallWeatherData, 'hourly'));
      // print(pick(oneCallWeatherData, 'hourly').value);
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
                        var oneCallWeatherData = await weatherHelper.getCurrentLocationOneCallWeather();
                        var weatherData = await weatherHelper.getCurrentLocationCurrentWeather();
                        updateUI(weatherData, oneCallWeatherData);
                      },
                      onPressedTopRight: () async {
                        RoutesHelper routesHelper = RoutesHelper();
                        // Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        var weatherData = await Navigator.of(context).push(routesHelper.createRoute(destiny: CityScreen()));
                        double latitude = weatherData['coord']['lat'];
                        double longitude = weatherData['coord']['lon'];
                        var oneCallWeatherData = await weatherHelper.getOneCallWeatherByCoordinates(latitude: latitude, longitude: longitude);
                        if (weatherData != null) {
                          updateUI(weatherData, oneCallWeatherData);
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
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
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
                  ),
                ),

                // Row # 4: Air Quality
                SizedBox(
                  height: 110,
                  child: ReusableCard(
                    color: kNewTestingCardColor,
                    cardChild: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            // color: Colors.red,
                            child: Text(
                              'Air Quality',
                              textAlign: TextAlign.left,
                              style: TextStyle(),
                            ),
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                              // activeTrackColor: Colors.white,
                              // inactiveTrackColor: kLabelTextColor,
                              thumbColor: kBottomContainerColor,
                              overlayColor: kTranslucentBottomContainerColor,
                              trackHeight: 6,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 30,
                              ),
                            ),
                            child: Slider(
                              // label: '${bmiCalculatorBrain.getHeight()}',
                              // label: 'test',
                              value: 51,
                              min: 1,
                              max: 500,
                              onChanged: (double newValue) {
                                setState(() {
                                  // bmiCalculatorBrain.setHeight(newValue.round());
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTapEvent: () {
                      // setState(() {
                      //   bmiCalculatorBrain.toggleGenderCards(Gender.male);
                      // });
                    },
                  ),
                ),

                // Row # 5:
                SizedBox(
                  height: 100,
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

LinearGradient gradient = LinearGradient(colors: <Color>[Colors.green, Colors.yellow, Colors.orange, Colors.purple, Colors.red]);
