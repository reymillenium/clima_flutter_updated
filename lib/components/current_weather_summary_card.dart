// Packages:
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Utilities:
import 'package:clima/utilities/constants.dart';

class CurrentWeatherSummaryCard extends StatelessWidget {
  const CurrentWeatherSummaryCard({
    Key key,
    @required this.cityName,
    @required this.currentDescription,
    @required this.currentTemperature,
    @required this.weatherBigIcon,
    @required this.currentIconCode,
    @required this.currentMaxTemperature,
    @required this.currentMinTemperature,
  }) : super(key: key);

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
        Text(
          // cityName.toUpperCase(),
          cityName,
          style: kNewCityNameTitleTextStyle,
          // style: kLabelTextStyle,
        ),
        Text(currentDescription),
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
            Text('H: ${currentMaxTemperature.toStringAsFixed(1)} °'),
            SizedBox(
              width: 10.0,
            ),
            Text('L: ${currentMinTemperature.toStringAsFixed(1)} °'),
          ],
        )
      ],
    );
  }
}
