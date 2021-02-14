// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Components:
import 'package:clima/components/reusable_card.dart';
import 'package:clima/components/current_weather_summary_card.dart';
import 'package:clima/components/horizontal_hourly_forecast_card_child.dart';

// Services:
import 'package:clima/services/weather.dart';
import 'package:clima/services/routes.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class HorizontalHourlyForecastCardChild extends StatelessWidget {
  // Properties:
  final WeatherModel weatherHelper = WeatherModel();

  // From current weather data
  final double currentTemperature;
  final String currentIconCode;

  // From OneCall weather data (forecast)

  final dynamic hourlyForecast;

  // Constructor:
  HorizontalHourlyForecastCardChild({this.currentTemperature, this.currentIconCode, this.hourlyForecast});

  List<Widget> createForecastListViewChildren() {
    List<Widget> result = [];
    Container presentWeather = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Now'),
          Image(
            image: weatherHelper.getOpenWeatherSmallIcon(iconCode: currentIconCode),
            width: 40,
          ),
          // Text('🌩'), // weatherHelper.getOpenWeatherBigIcon(iconCode: currentIconCode)
          Text('${currentTemperature ?? 0} °'),
        ],
      ),
    );
    result.add(presentWeather);

    // currentTemperature = pick(weatherData, 'main', 'temp').asDoubleOrNull() ?? -100;
    // currentMinTemperature = pick(weatherData, 'main', 'temp_min').asDoubleOrNull() ?? -100;
    // currentMaxTemperature = pick(weatherData, 'main', 'temp_max').asDoubleOrNull() ?? -100;
    // currentConditionNumber = pick(weatherData, 'weather', 0, 'id').asIntOrNull() ?? 0;
    // cityName = pick(weatherData, 'name').asStringOrNull() ?? 'Unknown'; // * Not included on One Call
    // currentIconCode = pick(weatherData, 'weather', 0, 'icon').asStringOrNull() ?? '11n';

    // print(hourlyForecast.value[0]);

    for (var i = 0; i <= 24; i++) {
      // print(pick(hourlyForecast[i], 'dt').asDoubleOrNull());
      // print(hourlyForecast);
      Container newtWeatherElement = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${pick(hourlyForecast[i], 'dt').asDoubleOrNull()}'),
            Image(
              image: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
              width: 40,
            ),
            Text('${pick(hourlyForecast[i], 'temp').asDoubleOrNull().toStringAsFixed(1) ?? 0} °'), // hourly[0].temp
          ],
        ),
      );

      result.add(newtWeatherElement);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      children: createForecastListViewChildren(),
    );
  }
}
