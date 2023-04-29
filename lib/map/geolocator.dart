import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_initialization.dart';

Position? userCurrentPosition;
var geoLocator = Geolocator();
locateUserPosition() async {
  Position cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  userCurrentPosition = cPosition;

  LatLng latLngPosition =
      LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

  CameraPosition cameraPosition =
      CameraPosition(target: latLngPosition, zoom: 14);

  MapInitialization.newGoogleMapController!
      .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
}
