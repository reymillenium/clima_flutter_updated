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

class DailyForecastCardChild extends StatelessWidget {
  // Helpers:
  final WeatherModel weatherHelper = WeatherModel();
  final TimeHelper timeHelper = TimeHelper();

  // Properties:
  final dynamic dailyForecast; // From OneCall weather data (forecast)

  // Constructor:
  DailyForecastCardChild({
    this.dailyForecast,
  });

  List<TableRow> createDailyForecastColumnChildren() {
    List<TableRow> result = [];

    for (var i = 0; i <= dailyForecast.length - 1; i++) {
      int timeSinceEpochInSec = pick(dailyForecast[i], 'dt').asIntOrNull();
      DateTime newLocalDay = timeHelper.getLocalTimeFromSecondsSinceEpoch(timeSinceEpochInSec);
      // Values to use:
      String newWeekDay = timeHelper.getWeekDayFromDateTime(newLocalDay);
      String iconCode = pick(dailyForecast[i], 'weather', 0, 'icon').asStringOrNull();
      double pop = pick(dailyForecast[i], 'pop').asDoubleOrNull();
      String popToShow = (pop != null && pop >= 0.3) ? '${(pop * 100).toInt()}%' : '';
      String minTemp = pick(dailyForecast[i], 'temp', 'min').asDoubleOrNull().toStringAsFixed(1);
      String maxTemp = pick(dailyForecast[i], 'temp', 'max').asDoubleOrNull().toStringAsFixed(1);

      TableRow newDailyElement = TableRow(
        children: [
          Text(newWeekDay),
          Row(
            children: [
              Image(
                image: weatherHelper.getOpenWeatherSmallIcon(iconCode: iconCode),
                width: 40,
              ),
              Text(
                popToShow,
                style: kPopTextStyle,
              ),
            ],
          ),
          Text('$minTemp °'),
          Text('$maxTemp °'),
        ],
      );

      result.add(newDailyElement);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: createDailyForecastColumnChildren(),
      ),
    );
  }
}
