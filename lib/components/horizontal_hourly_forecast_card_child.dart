// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Components:
import 'package:clima/components/reusable_card.dart';
import 'package:clima/components/current_weather_summary_card.dart';
import 'package:clima/components/horizontal_hourly_forecast_card_child.dart';
import 'package:clima/components/horizontal_hourly_element.dart';

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
      final dateUtc = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000, isUtc: true);
      var newDateLocal = dateUtc.toLocal();
      DateTime now = new DateTime.now();
      DateTime currentUpToHourDateTime = new DateTime(now.year, now.month, now.day, now.hour);
      DateTime upToHourNewLocalDateTime = new DateTime(newDateLocal.year, newDateLocal.month, newDateLocal.day, newDateLocal.hour);

      // Sunrise datetime:
      var timeSinceEpochInSecSunrise = sunrise;
      final dateUtcSunrise = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSecSunrise * 1000, isUtc: true);
      var localDateTimeSunrise = dateUtcSunrise.toLocal();
      DateTime upToHourDateTimeSunrise = new DateTime(localDateTimeSunrise.year, localDateTimeSunrise.month, localDateTimeSunrise.day, localDateTimeSunrise.hour);

      // Sunset datetime
      var timeSinceEpochInSecSunset = sunset;
      final dateUtcSunset = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSecSunset * 1000, isUtc: true);
      var localDateTimeSunset = dateUtcSunset.toLocal();
      DateTime upToHourDateTimeSunset = new DateTime(localDateTimeSunset.year, localDateTimeSunset.month, localDateTimeSunset.day, localDateTimeSunset.hour);

      if (newDateLocal.isAfter(currentUpToHourDateTime)) {
        // var formattedDateTime = DateFormat('hh:mm a').format(newDateLocal);
        var formattedDateTime = DateFormat('ha').format(newDateLocal).toLowerCase();

        // Composing the element to insert
        Widget newtWeatherElement = HorizontalHourlyElement(
          upperText: formattedDateTime,
          weatherIcon: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
          lowerText: pick(hourlyForecast[i], 'temp').asDoubleOrNull().toStringAsFixed(1),
        );

        result.add(newtWeatherElement);

        // Checking the Sunrise datetime:
        if (upToHourDateTimeSunrise == upToHourNewLocalDateTime) {
          var formattedSunriseDateTime = DateFormat('h:mm a').format(localDateTimeSunrise).toLowerCase();

          // Composing the Sunrise element to insert
          Container newtSunriseElement = Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$formattedSunriseDateTime'),
                Image(
                  image: AssetImage('images/icons8-sunrise-32.png'),
                  width: 40,
                ),
                Text('Sunrise'),
              ],
            ),
          );

          result.add(newtSunriseElement);
        }

        // Checking the Sunset datetime:
        if (upToHourDateTimeSunset == upToHourNewLocalDateTime) {
          var formattedSunsetDateTime = DateFormat('h:mm a').format(localDateTimeSunset).toLowerCase();

          // Composing the Sunset element to insert
          Container newtSunsetElement = Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$formattedSunsetDateTime'),
                Image(
                  image: AssetImage('images/icons8-sunset-32.png'),
                  width: 40,
                ),
                Text('Sunset'),
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

// class HorizontalHourlyElement extends StatelessWidget {
//   const HorizontalHourlyElement({
//     Key key,
//     @required this.formattedDateTime,
//     @required this.weatherHelper,
//     @required this.hourlyForecast,
//     @required this.i,
//   }) : super(key: key);
//
//   final String formattedDateTime;
//   final WeatherModel weatherHelper;
//   final dynamic hourlyForecast;
//   final int i;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text('$formattedDateTime'),
//           Image(
//             image: weatherHelper.getOpenWeatherSmallIcon(iconCode: pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull()),
//             width: 40,
//           ),
//           Text('${pick(hourlyForecast[i], 'temp').asDoubleOrNull().toStringAsFixed(1) ?? 0} °'), // hourly[0].temp
//         ],
//       ),
//     );
//   }
// }
