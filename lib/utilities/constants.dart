// Packages:
import 'package:flutter/material.dart';

const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const openWeatherOneCallURL = 'https://api.openweathermap.org/data/2.5/onecall';
const openWeatherApiKey = '888e3a5d9c71ad9496ae5659aaf9bcc0';

// Text Styles:
const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 65.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 55.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const kTextFieldHintStyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'Spartan MB',
);

const kTextFieldInputStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Spartan MB',
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
    size: 40.0,
  ),
  hintText: 'Type the city',
  hintStyle: kTextFieldHintStyle,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide.none,
  ),
);

// New Styles for New Design:
const kNewCityNameTitleTextStyle = TextStyle(
  color: Colors.white,
  // color: kLabelTextColor,
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kNewHugeTemperatureValueTextStyle = TextStyle(
  // color: kLabelTextColor,
  // fontFamily: 'Spartan MB',
  fontSize: 60.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// * * * * * * * * * * * * * * * * * * * * * * * *
// *                 Colors:                     *
// * * * * * * * * * * * * * * * * * * * * * * * *
const Color kActiveCardColor = Color(0xFF1D1E33);
const Color kInactiveCardColor = Color(0xFF111328);
const Color kTranslucentBottomContainerColor = Color(0x29EB1555);
const Color kBottomContainerColor = Color(0xFFEB1555);
const Color kLabelTextColor = Color(0xFF8D8E98);
const Color kLightButtonColor = Color(0xFF4C4F5E);
const Color kGreenResultsColor = Color(0xFF24D876);

// * * * * * * * * * * * * * * * * * * * * * * * *
// *              Text Styles:                   *
// * * * * * * * * * * * * * * * * * * * * * * * *
const kLabelTextStyle = TextStyle(
  fontSize: 18,
  color: kLabelTextColor,
);
