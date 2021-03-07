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

    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));
    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));
    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));
    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));
    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));
    result.add(createTableRow(leftLabel: 'SUNRISE', leftValue: '6:38am', rightLabel: 'SUNSET', rightValue: '6:26pm'));

    return result;
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
