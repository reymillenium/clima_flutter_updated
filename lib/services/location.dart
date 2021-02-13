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
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return Future.error('Location permissions are denied (actual value: $permission).');
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      this.latitude = position.latitude;
      this.longitude = position.longitude;
    } catch (e) {
      print('Error: $e');
    }
  }

  // Private methods:
}
