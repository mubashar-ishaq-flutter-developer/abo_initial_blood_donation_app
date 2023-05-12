import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String? gfname;
String? glname;
String? gnumber;
String? gbloodgroup;
String? humansReadableAddress;
bool isvisible = true;
bool isvisibles = false;
// getting donor position
Position? donorCurrentPosition;

// initializing map controller
GoogleMapController? newGoogleMapController;
// finding if donor is active or not
bool isDonorActive = false;
//  for stream position
StreamSubscription<Position>? streamSubscriptionPosition;
