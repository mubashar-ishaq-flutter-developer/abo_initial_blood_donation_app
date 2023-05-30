import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Donor/model/donor_data.dart';

String? gfname;
String? glname;
String? gnumber;
String? gbloodgroup;
String? gid;
// this is to hide & show some widgets and also to switch between user
bool isvisible = true;
// getting donor position
Position? donorCurrentPosition;
// initializing map controller
GoogleMapController? newGoogleMapController;
//humanReadableAddress to get location readble for normal person
String? humanReadableAddress;
//for donor online and offline status
String statusText = "Now Offline";
// finding if donor is active or not
bool isDonorActive = false;
// for stream position
StreamSubscription<Position>? streamSubscriptionPosition;
//for resuming live position
StreamSubscription<Position>? streamSubscriptionDonorLivePosition;
//online/active donors info list
List dList = [];
//for audio file to play as notification
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
//donor chosen id
String? chosenDonorId = "";
//getting online donor data
DonorData onlineDonorData = DonorData();
//cloud messeging
String cloudMessagingServerToken =
    "key=AAAApknoyQY:APA91bGEL2qxE6rlhNycLRaGFbO6GeDmDuWvXnQlw4KK8pXdQw15Mdb6vsLMmmsCegN_ltLbx2hxPirrxfVuBrb3RIQS0FWbXnvevJeaY23hXkT39yBr5rrLsSr40N82Khl6XfQuPqdC";
String userPickUpLocation = "";
String donorFName = "";
String donorLName = "";
String donorBloodGroup = "";
String donorNumber = "";
