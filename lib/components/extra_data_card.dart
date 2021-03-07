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
import 'package:clima/components/gradient_rect_slider_track_shape.dart';

// Services:
import 'package:clima/services/weather.dart';
import 'package:clima/services/routes.dart';
import 'package:clima/services/time.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class ExtraDataCard extends StatelessWidget {
  // Helpers:
  // final WeatherModel weatherHelper = WeatherModel();
  final TimeHelper timeHelper = TimeHelper();

  // Properties:
  // From local weather forecast:
  final int humidity;
  final double windSpeed;
  final double feelsLike;

  // From OneCall weather data (forecast)
  final dynamic hourlyForecast;
  final dynamic dailyForecast;

  ExtraDataCard({
    this.hourlyForecast,
    this.dailyForecast,
    this.humidity,
    this.windSpeed,
    this.feelsLike,
  });

  List<TableRow> generateExtraDataTableRows() {
    List<TableRow> result = [];

    result.add(createSunriseSunsetTableRow());
    result.add(createChanceOfRainHumidityTableRow());
    result.add(createWindFeelsLikeTableRow());
    result.add(createPrecipitationPressureTableRow());
    result.add(createVisibilityUvIndexTableRow());

    return result;
  }

  TableRow createSunriseSunsetTableRow() {
    String sunsetToShow = '';
    String sunriseToShow = '';
    // var currentTime = timeHelper.getCurrentTime();
    var currentLocalTime = timeHelper.getCurrentLocalTime();
    // print('currentTime: $currentTime');
    // print('currentLocalTime: $currentLocalTime');

    // Gets the next Sunset datetime:
    for (int i = 0; i <= dailyForecast.length; i++) {
      int sunset = pick(dailyForecast[i], 'sunset').asIntOrNull();
      var localDateTimeSunset = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunset);

      // print('i = $i');
      if (localDateTimeSunset.isAfter(currentLocalTime)) {
        sunsetToShow = timeHelper.getFormattedExactDateTime(localDateTimeSunset);
        break;
      }
    }

    // Gets the next Sunrise datetime:
    for (int j = 0; j <= dailyForecast.length; j++) {
      int sunrise = pick(dailyForecast[j], 'sunrise').asIntOrNull();
      var localDateTimeSunrise = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunrise);

      // print('j = $j');
      if (localDateTimeSunrise.isAfter(currentLocalTime)) {
        sunriseToShow = timeHelper.getFormattedExactDateTime(localDateTimeSunrise);
        break;
      }
    }

    return createTableRow(leftLabel: 'SUNRISE', leftValue: sunriseToShow, rightLabel: 'SUNSET', rightValue: sunsetToShow);
  }

  TableRow createChanceOfRainHumidityTableRow() {
    double pop = pick(hourlyForecast[0], 'pop').asDoubleOrNull() ?? 0;
    String popToShow = '$pop%';
    int humidity = this.humidity ?? 0;
    String humidityToShow = '$humidity%';

    return createTableRow(leftLabel: 'CHANCE OF RAIN', leftValue: popToShow, rightLabel: 'HUMIDITY', rightValue: humidityToShow);
  }

  TableRow createWindFeelsLikeTableRow() {
    double windSpeed = this.windSpeed ?? 0;
    String windSpeedToShow = '$windSpeed m/s';
    double feelsLike = this.feelsLike ?? 0;
    String feelsLikeToShow = '${feelsLike.toStringAsFixed(1)}°';
    return createTableRow(leftLabel: 'WIND', leftValue: windSpeedToShow, rightLabel: 'FEELS LIKE', rightValue: feelsLikeToShow);
  }

  TableRow createPrecipitationPressureTableRow() {
    String leftValue = '0.5 in';
    String rightValue = '29.95 inHg';

    return createTableRow(leftLabel: 'PRECIPITATION', leftValue: leftValue, rightLabel: 'PRESSURE', rightValue: rightValue);
  }

  TableRow createVisibilityUvIndexTableRow() {
    String leftValue = '10 mi';
    String rightValue = '0';

    return createTableRow(leftLabel: 'VISIBILITY', leftValue: leftValue, rightLabel: 'UV INDEX', rightValue: rightValue);
  }

  TableRow createTableRow({String leftLabel, leftValue, rightLabel, rightValue}) {
    return TableRow(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              leftLabel,
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
            Text(
              leftValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              rightLabel,
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
            Text(
              rightValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Table(
        border: TableBorder(
          bottom: BorderSide(
            color: Colors.white,
            width: 1,
          ),
          horizontalInside: BorderSide(
            color: Colors.white,
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: generateExtraDataTableRows(),
      ),
    );
  }
}
