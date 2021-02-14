// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
  final int sunrise;
  final int sunset;

  // From OneCall weather data (forecast)

  final dynamic hourlyForecast;

  // Constructor:
  HorizontalHourlyForecastCardChild({
    this.currentTemperature,
    this.currentIconCode,
    this.sunrise,
    this.sunset,
    this.hourlyForecast,
  });

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

    for (var i = 0; i <= 24; i++) {
      var timeSinceEpochInSec = pick(hourlyForecast[i], 'dt').asIntOrNull();
      // print('timeSinceEpochInSec: $timeSinceEpochInSec');

      final dateUtc = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000, isUtc: true);
      // print('dateUtc: $dateUtc');

      var newDateLocal = dateUtc.toLocal();
      // print('newDateLocal: $newDateLocal');

      DateTime now = new DateTime.now();
      DateTime upToHourDateTime = new DateTime(now.year, now.month, now.day, now.hour);
      // print(upToHourDateTime);

      if (newDateLocal.isAfter(upToHourDateTime)) {
        // print('Compliant newDateLocal: $newDateLocal');

        // var formattedDateTime = DateFormat('hh:mm a').format(newDateLocal);
        var formattedDateTime = DateFormat('ha').format(newDateLocal).toLowerCase();
        // print('formattedDateTime: $formattedDateTime');

        // Composing the element to insert
        Container newtWeatherElement = Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('$formattedDateTime'),
              Image(
                image: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
                width: 40,
              ),
              Text('${pick(hourlyForecast[i], 'temp').asDoubleOrNull().toStringAsFixed(1) ?? 0} °'), // hourly[0].temp
            ],
          ),
        );

        result.add(newtWeatherElement);

        var timeSinceEpochInSecSunrise = sunrise;
        final dateUtcSunrise = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSecSunrise * 1000, isUtc: true);
        var localDateTimeSunrise = dateUtcSunrise.toLocal();
        DateTime upToHourNewLocalDateTime = new DateTime(newDateLocal.year, newDateLocal.month, newDateLocal.day, newDateLocal.hour);
        DateTime upToHourDateTimeSunrise = new DateTime(localDateTimeSunrise.year, localDateTimeSunrise.month, localDateTimeSunrise.day, localDateTimeSunrise.hour);

        if (upToHourDateTimeSunrise == upToHourNewLocalDateTime) {
          var formattedSunriseDateTime = DateFormat('h:mm a').format(localDateTimeSunrise).toLowerCase();

          // Composing the Sunrise element to insert
          Container newtSunriseElement = Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$formattedSunriseDateTime'),
                // Image(
                //   image: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
                //   width: 40,
                // ),
                Text('🌅'), // hourly[0].temp
                Text('Sunrise'), // hourly[0].temp
              ],
            ),
          );

          result.add(newtSunriseElement);
        }

        var timeSinceEpochInSecSunset = sunset;
        final dateUtcSunset = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSecSunset * 1000, isUtc: true);
        var localDateTimeSunset = dateUtcSunset.toLocal();
        // DateTime upToHourNewLocalDateTime = new DateTime(newDateLocal.year, newDateLocal.month, newDateLocal.day, newDateLocal.hour);
        DateTime upToHourDateTimeSunset = new DateTime(localDateTimeSunset.year, localDateTimeSunset.month, localDateTimeSunset.day, localDateTimeSunset.hour);

        if (upToHourDateTimeSunset == upToHourNewLocalDateTime) {
          var formattedSunsetDateTime = DateFormat('h:mm a').format(localDateTimeSunset).toLowerCase();

          // Composing the Sunrise element to insert
          Container newtSunsetElement = Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$formattedSunsetDateTime'),
                // Image(
                //   image: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
                //   width: 40,
                // ),
                Text('🌆'), // hourly[0].temp
                Text('Sunset'), // hourly[0].temp
              ],
            ),
          );

          result.add(newtSunsetElement);
        }
      }
    }

    return result;
  }

  String getClockInUtc(int timeSinceEpochInSec) {
    final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000, isUtc: true);
    return '${time.hour}:${time.second}';
  }

  String getClockInUtcPlus3Hours(int timeSinceEpochInSec) {
    final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000, isUtc: true).add(const Duration(hours: 3));
    return '${time.hour}:${time.second}';
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
