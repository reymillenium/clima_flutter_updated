// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class CurrentWeatherSummaryCard extends StatelessWidget {
  const CurrentWeatherSummaryCard({
    Key key,
    @required this.onPressedTopLeft,
    @required this.onPressedTopRight,
    @required this.cityName,
    @required this.currentDescription,
    @required this.currentTemperature,
    @required this.weatherBigIcon,
    @required this.currentIconCode,
    @required this.currentMaxTemperature,
    @required this.currentMinTemperature,
  }) : super(key: key);

  final Function onPressedTopLeft;
  final Function onPressedTopRight;
  final String cityName;
  final String currentDescription;
  final double currentTemperature;
  final NetworkImage weatherBigIcon;
  final String currentIconCode;
  final double currentMaxTemperature;
  final double currentMinTemperature;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Buttons with City name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Near button
            FlatButton(
              onPressed: onPressedTopLeft,
              child: Icon(
                Icons.near_me,
                size: 20.0,
              ),
            ),

            Text(
              cityName,
              style: kNewCityNameTitleTextStyle,
              // style: kLabelTextStyle,
            ),

            // City locator button
            FlatButton(
              onPressed: onPressedTopRight,
              child: Icon(
                Icons.location_city,
                size: 20.0,
              ),
            ),
          ],
        ),

        // Description:
        Text(currentDescription),

        // Current temperature with
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${currentTemperature.toStringAsFixed(1)} °',
              style: kNewHugeTemperatureValueTextStyle,
            ),
            Image(
              image: weatherBigIcon,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '↑ ${currentMaxTemperature.toStringAsFixed(1)} °',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              '↓ ${currentMinTemperature.toStringAsFixed(1)} °',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        )
      ],
    );
  }
}
