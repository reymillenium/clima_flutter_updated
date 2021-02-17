// Packages:
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  String getAQICNQualificationMessage(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return 'Good';
    } else if (aqi >= 51 && aqi <= 100) {
      return 'Moderate';
    } else if (aqi >= 101 && aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi >= 151 && aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi >= 201 && aqi <= 300) {
      return 'Very Unhealthy';
    } else if (aqi > 300) {
      return 'Hazardous';
    } else {
      return 'Error';
    }
  }

  // Gets an official OpenWeather icon image based on a given icon code:
  ImageProvider getOpenWeatherBigIcon({String iconCode}) {
    return NetworkImage('http://openweathermap.org/img/wn/$iconCode@2x.png');
  }

  ImageProvider getOpenWeatherSmallIcon({String iconCode}) {
    return NetworkImage('http://openweathermap.org/img/wn/$iconCode.png');
  }

  // Current weather in current location - Open Weather (https://openweathermap.org/)
  Future<dynamic> getCurrentLocationCurrentWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    return await network.getCurrentDataByCoordinates(lat: location.latitude, long: location.longitude);
  }

  // Current Weather per city name - Open Weather (https://openweathermap.org/)
  Future<dynamic> getCityWeather({String cityName}) async {
    NetworkHelper network = NetworkHelper();
    return await network.getDataByCity(cityName: cityName);
  }

  // One Call - Open Weather (https://openweathermap.org/)
  Future<dynamic> getCurrentLocationOneCallWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    return await network.getOneCallDataByCoordinates(lat: location.latitude, long: location.longitude);
  }

  Future<dynamic> getOneCallWeatherByCoordinates({double latitude, double longitude}) async {
    NetworkHelper network = NetworkHelper();
    return await network.getOneCallDataByCoordinates(lat: latitude, long: longitude);
  }

  // Air Pollution - Open Weather (https://openweathermap.org/)
  Future<dynamic> getCurrentLocationAirPollutionData() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    return await network.getCurrentPollutionDataByCoordinates(lat: location.latitude, long: location.longitude);
  }

  Future<dynamic> getAirPollutionDataByCoordinates({double latitude, double longitude}) async {
    NetworkHelper network = NetworkHelper();
    return await network.getCurrentPollutionDataByCoordinates(lat: latitude, long: longitude);
  }

  // Air Pollution - AQICN (https://aqicn.org/)
  Future<dynamic> getCurrentLocationAirPollutionDataAQICN() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper network = NetworkHelper();
    return await network.getCurrentPollutionDataByCoordinatesAQICN(lat: location.latitude, long: location.longitude);
  }

  Future<dynamic> getAirPollutionDataByCoordinatesAQICN({double latitude, double longitude}) async {
    NetworkHelper network = NetworkHelper();
    return await network.getCurrentPollutionDataByCoordinatesAQICN(lat: latitude, long: longitude);
  }

  Alert createAlert(BuildContext context, String message) {
    return (Alert(
      context: context,
      style: AlertStyle(
        backgroundColor: Colors.white,
      ),
      type: AlertType.success,
      title: "Error",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.lightBlueAccent,
        )
      ],
    ));
  }
}
