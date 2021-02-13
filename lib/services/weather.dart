// Packages:
import 'dart:ui';
import 'package:flutter/material.dart';

// Services:
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

class WeatherModel {
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(double temp) {
    if (temp == -100) {
      return 'There is an error 🙅';
    } else if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  // Gets an official OpenWeather icon image based on a given icon code:
  NetworkImage getOpenWeatherIcon({String iconCode}) {
    return NetworkImage('http://openweathermap.org/img/wn/$iconCode@2x.png');
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    return await network.getDataByCoordinates(lat: location.latitude, long: location.longitude);
  }

  Future<dynamic> getCityWeather({String cityName}) async {
    NetworkHelper network = NetworkHelper();
    return await network.getDataByCity(cityName: cityName);
  }
}
