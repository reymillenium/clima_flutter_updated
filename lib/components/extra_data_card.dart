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
  // From OneCall weather data (forecast)
  final dynamic hourlyForecast;
  final dynamic dailyForecast;

  ExtraDataCard({
    this.hourlyForecast,
    this.dailyForecast,
  });

  List<TableRow> generateExtraDataTableRows() {
    List<TableRow> result = [];

    result.add(createSunriseSunsetTableRow());
    result.add(createTableRow(leftLabel: 'CHANCE OF RAIN', leftValue: '10%', rightLabel: 'HUMIDITY', rightValue: '78%'));
    result.add(createTableRow(leftLabel: 'WIND', leftValue: 'n 7 mph', rightLabel: 'FEELS LIKE', rightValue: '66 °'));
    result.add(createTableRow(leftLabel: 'PRECIPITATION', leftValue: '0.5 in', rightLabel: 'PRESSURE', rightValue: '29.95 inHg'));
    result.add(createTableRow(leftLabel: 'VISIBILITY', leftValue: '10 mi', rightLabel: 'UV INDEX', rightValue: '0'));

    return result;
  }

  TableRow createSunriseSunsetTableRow() {
    String leftValue = '6:12am';
    String rightValue = '6:12pm';
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
        leftValue = timeHelper.getFormattedExactDateTime(localDateTimeSunset);
        break;
      }
    }

    // Gets the next Sunrise datetime:
    for (int j = 0; j <= dailyForecast.length; j++) {
      int sunrise = pick(dailyForecast[j], 'sunrise').asIntOrNull();
      var localDateTimeSunrise = timeHelper.getLocalTimeFromSecondsSinceEpoch(sunrise);

      // print('j = $j');
      if (localDateTimeSunrise.isAfter(currentLocalTime)) {
        rightValue = timeHelper.getFormattedExactDateTime(localDateTimeSunrise);
        break;
      }
    }

    return createTableRow(leftLabel: 'SUNRISE', leftValue: leftValue, rightLabel: 'SUNSET', rightValue: rightValue);
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
