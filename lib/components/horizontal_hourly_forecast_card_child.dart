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

    // Current element:
    Widget currentWeatherElement = HorizontalHourlyElement(
      upperText: 'Now',
      weatherIcon: weatherHelper.getOpenWeatherSmallIcon(iconCode: currentIconCode),
      lowerText: currentTemperature.toStringAsFixed(1) ?? 0,
    );
    result.add(currentWeatherElement);

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

        // Sunrise datetime:
        var localDateTimeSunrise = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunrise);
        DateTime upToHourDateTimeSunrise = timeHelper.getTimeUpToHour(time: localDateTimeSunrise);

        // Checking the Sunrise datetime:
        if (upToHourDateTimeSunrise == upToHourNewLocalDateTime) {
          var formattedSunriseDateTime = timeHelper.getFormattedExactDateTime(localDateTimeSunrise);

          // Composing the Sunrise element to insert
          Widget newSunriseElement = HorizontalHourlyElement(
            upperText: formattedSunriseDateTime,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunrise-32.png'),
            lowerText: 'Sunrise',
          );

          result.add(newSunriseElement);
        }

        // Sunset datetime:
        var localDateTimeSunset = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunset);
        DateTime upToHourDateTimeSunset = timeHelper.getTimeUpToHour(time: localDateTimeSunset);

        // Checking the Sunset datetime:
        if (upToHourDateTimeSunset == upToHourNewLocalDateTime) {
          var formattedSunsetDateTime = timeHelper.getFormattedExactDateTime(localDateTimeSunset);

          Widget newSunsetElement = HorizontalHourlyElement(
            upperText: formattedSunsetDateTime,
            pop: pop,
            weatherIcon: AssetImage('images/icons8-sunset-32.png'),
            lowerText: 'Sunset',
          );

          result.add(newSunsetElement);
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
