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

class AirQualityCardChild extends StatelessWidget {
  // Helpers:
  final WeatherModel weatherHelper = WeatherModel();
  final TimeHelper timeHelper = TimeHelper();

  final int aqi;
  static const double minValue = 1;
  static const double maxValue = 500;

  // Constructor:
  AirQualityCardChild({
    this.aqi,
  });

  @override
  Widget build(BuildContext context) {
    double aqiValueToSlider = (aqi > maxValue ? maxValue : aqi).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              'Air Quality',
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
          ),
          Container(
            child: Text(
              '$aqi - ${weatherHelper.getAQICNQualificationMessage(aqi)}',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
              thumbColor: kBottomContainerColor,
              overlayColor: kTranslucentBottomContainerColor,
              trackHeight: 6,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6,
              ),
            ),
            child: Slider(
              // label: '${bmiCalculatorBrain.getHeight()}',
              // label: 'test',
              value: aqiValueToSlider,
              min: minValue,
              max: maxValue,
              onChanged: (double newValue) {
                // setState(() {
                //   bmiCalculatorBrain.setHeight(newValue.round());
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}

LinearGradient gradient = LinearGradient(colors: <Color>[Colors.green, Colors.yellow, Colors.orange, Colors.red, Colors.purple, Color(0xFF731426)]);
