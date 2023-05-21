import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Donor/model/donor_data.dart';

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
//online/active donors info list
List dList = [];
//for audio file to play as notification
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
//donor chosen id
String? chosenDonorId = "";
//getting online donor data
DonorData onlineDonorData = DonorData();
