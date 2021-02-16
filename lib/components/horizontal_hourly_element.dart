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

class HorizontalHourlyElement extends StatelessWidget {
  const HorizontalHourlyElement({
    Key key,
    @required this.upperText,
    this.pop,
    @required this.weatherIcon,
    @required this.lowerText,
  }) : super(key: key);

  final String upperText;
  final String pop;
  final NetworkImage weatherIcon;
  final String lowerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$upperText'),
          Image(
            image: weatherIcon,
            width: 40,
          ),
          Text('$lowerText °'), // hourly[0].temp
        ],
      ),
    );
  }
}
