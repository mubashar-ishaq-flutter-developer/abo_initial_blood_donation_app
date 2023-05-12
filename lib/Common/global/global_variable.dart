import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String? gfname;
String? glname;
String? gnumber;
String? gbloodgroup;
// this is to hide $ show some widgets and also to switch between user
bool isvisible = true;
// getting donor position
Position? donorCurrentPosition;
// initializing map controller
GoogleMapController? newGoogleMapController;
// finding if donor is active or not
bool isDonorActive = false;
// for stream position
StreamSubscription<Position>? streamSubscriptionPosition;
