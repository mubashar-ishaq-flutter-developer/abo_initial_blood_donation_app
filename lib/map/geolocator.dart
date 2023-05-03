import 'package:abo_initial/display_user/current_user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistantnt/assistant_methord.dart';
import '../global/global_variable.dart';
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
  humansReadableAddress =
      await AssistantMethods.searchAddressForGeographicCoOrdinate(
          userCurrentPosition!);
}
