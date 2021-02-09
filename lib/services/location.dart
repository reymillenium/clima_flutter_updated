// Packages:
import 'package:geolocator/geolocator.dart';

class Location {
  // Properties:
  double latitude;
  double longitude;

  // Constructor:
  Location({this.latitude, this.longitude});

  // Public methods:
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      // print(position);
      this.latitude = position.latitude;
      this.longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  // Private methods:
}
