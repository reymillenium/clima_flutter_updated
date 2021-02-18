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
import 'package:clima/services/time.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class HorizontalHourlyForecastCardChild extends StatelessWidget {
  // Properties:
  final WeatherModel weatherHelper = WeatherModel();
  final TimeHelper timeHelper = TimeHelper();

  // From current weather data
  final double currentTemperature;
  final String currentIconCode;
  final int sunrise;
  final int sunset;

  // From OneCall weather data (forecast)

  final dynamic hourlyForecast;
  final dynamic dailyForecast;

  // Constructor:
  HorizontalHourlyForecastCardChild({
    this.currentTemperature,
    this.currentIconCode,
    this.sunrise,
    this.sunset,
    this.hourlyForecast,
    this.dailyForecast,
  });

  List<Widget> createForecastListViewChildren() {
    List<Widget> result = [];

    // Current element:
    Widget currentWeatherElement = HorizontalHourlyElement(
      upperText: 'Now',
      weatherIcon: weatherHelper.getOpenWeatherSmallIcon(iconCode: currentIconCode),
      lowerText: currentTemperature.toStringAsFixed(1) ?? 0,
    );
    result.add(currentWeatherElement);

    // Sunrise datetime # 1:
    int sunrise1 = pick(dailyForecast[0], 'sunrise').asIntOrNull();
    var localDateTimeSunrise1 = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunrise1);
    DateTime upToHourDateTimeSunrise1 = timeHelper.getTimeUpToHour(time: localDateTimeSunrise1);

    // Sunrise datetime # 2:
    int sunrise2 = pick(dailyForecast[1], 'sunrise').asIntOrNull();
    var localDateTimeSunrise2 = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunrise2);
    DateTime upToHourDateTimeSunrise2 = timeHelper.getTimeUpToHour(time: localDateTimeSunrise2);

    // Sunset datetime # 1:
    int sunset1 = pick(dailyForecast[0], 'sunset').asIntOrNull();
    var localDateTimeSunset1 = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunset1);
    DateTime upToHourDateTimeSunset1 = timeHelper.getTimeUpToHour(time: localDateTimeSunset1);

    // Sunset datetime # 2:
    int sunset2 = pick(dailyForecast[1], 'sunset').asIntOrNull();
    var localDateTimeSunset2 = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunset2);
    DateTime upToHourDateTimeSunset2 = timeHelper.getTimeUpToHour(time: localDateTimeSunset2);

    // The next 24 weather elements:
    for (var i = 0; i <= 24; i++) {
      String iconCode = pick(hourlyForecast[i], 'weather', 0, 'icon').asStringOrNull();
      double pop = pick(hourlyForecast[i], 'pop').asDoubleOrNull();
      var timeSinceEpochInSec = pick(hourlyForecast[i], 'dt').asIntOrNull();
      var newDateLocal = timeHelper.getLocalTimeFromSecondsSinceEpoch(timeSinceEpochInSec);
      DateTime upToHourNewLocalDateTime = timeHelper.getTimeUpToHour(time: newDateLocal);
      DateTime currentUpToHourDateTime = timeHelper.getCurrentTimeUpToHour();
      double newTemperature = pick(hourlyForecast[i], 'temp').asDoubleOrNull();

      if (newDateLocal.isAfter(currentUpToHourDateTime)) {
        var formattedDateTime = timeHelper.getFormattedDateTime(newDateLocal);

        // Composing the new hourly element to insert
        Widget newWeatherElement = HorizontalHourlyElement(
          upperText: formattedDateTime,
          pop: pop,
          weatherIcon: weatherHelper.getOpenWeatherSmallIcon(iconCode: iconCode),
          lowerText: newTemperature.toStringAsFixed(1) ?? 0,
        );

        result.add(newWeatherElement);

        // Checking the Sunrise datetime # 1:
        if (upToHourDateTimeSunrise1 == upToHourNewLocalDateTime) {
          var formattedSunriseDateTime1 = timeHelper.getFormattedExactDateTime(localDateTimeSunrise1);

          // Composing the Sunrise element to insert
          Widget newSunriseElement1 = HorizontalHourlyElement(
            upperText: formattedSunriseDateTime1,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunrise-32.png'),
            lowerText: 'Sunrise',
          );

          result.add(newSunriseElement1);
        }

        // Checking the Sunrise datetime # 2:
        if (upToHourDateTimeSunrise2 == upToHourNewLocalDateTime) {
          var formattedSunriseDateTime2 = timeHelper.getFormattedExactDateTime(localDateTimeSunrise2);

          // Composing the Sunrise element to insert
          Widget newSunriseElement2 = HorizontalHourlyElement(
            upperText: formattedSunriseDateTime2,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunrise-32.png'),
            lowerText: 'Sunrise',
          );

          result.add(newSunriseElement2);
        }

        // Checking the Sunset datetime # 1:
        if (upToHourDateTimeSunset1 == upToHourNewLocalDateTime) {
          var formattedSunsetDateTime1 = timeHelper.getFormattedExactDateTime(localDateTimeSunset1);

          Widget newSunsetElement1 = HorizontalHourlyElement(
            upperText: formattedSunsetDateTime1,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunset-32.png'),
            lowerText: 'Sunset',
          );

          result.add(newSunsetElement1);
        }

        // Checking the Sunset datetime # 2:
        if (upToHourDateTimeSunset2 == upToHourNewLocalDateTime) {
          var formattedSunsetDateTime2 = timeHelper.getFormattedExactDateTime(localDateTimeSunset2);

          Widget newSunsetElement2 = HorizontalHourlyElement(
            upperText: formattedSunsetDateTime2,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunset-32.png'),
            lowerText: 'Sunset',
          );

          result.add(newSunsetElement2);
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
