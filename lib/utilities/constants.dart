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
  fontFamily: 'Spartan MB',
  fontSize: 24.0,
);
