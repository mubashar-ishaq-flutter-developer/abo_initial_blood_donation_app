import 'package:geolocator/geolocator.dart';

LocationPermission? _locationPermission;

checkIfLocationPermissionAllowed() async {
  _locationPermission = await Geolocator.requestPermission();

  if (_locationPermission == LocationPermission.denied) {
    _locationPermission = await Geolocator.requestPermission();
  }
}
