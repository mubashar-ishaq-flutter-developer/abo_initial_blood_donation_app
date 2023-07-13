import 'dart:async';

import 'package:abo_initial/Common/global/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DonorStatus {
  // this methord is checking is donor is online
  static donorIsOnlineNow() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    // getting donor current location through geolocator
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    donorCurrentPosition = pos;
    Geofire.initialize("activeDonors");
    Geofire.setLocation(
      uid!,
      donorCurrentPosition!.latitude,
      donorCurrentPosition!.longitude,
    );
    final dbRefrence = FirebaseDatabase.instance
        .ref()
        .child("Data")
        .child(uid)
        .child("donationStatus");
    dbRefrence.set("idle"); //waiting for seeker request
    dbRefrence.onValue.listen((event) {});
  }

// this methord is updating the donor location realtime in database
  void updateDonorLocationAtRealTime() {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      donorCurrentPosition = position;
      if (isDonorActive == true) {
        Geofire.setLocation(
          uid!,
          donorCurrentPosition!.latitude,
          donorCurrentPosition!.longitude,
        );
      }
      LatLng latLng = LatLng(
        donorCurrentPosition!.latitude,
        donorCurrentPosition!.longitude,
      );
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  //methord to delete activeDonor and its status if driver is offline
  driverIsOfflineNow() {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    Geofire.removeLocation(uid!);
    DatabaseReference? dbRefrence = FirebaseDatabase.instance
        .ref()
        .child("Data")
        .child(uid)
        .child("donationStatus");
    dbRefrence.onDisconnect();
    dbRefrence.remove();
    dbRefrence = null;
    Future.delayed(const Duration(milliseconds: 2000), () {
      final user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      final dbRefrence = FirebaseDatabase.instance.ref().child("activeDonors");
      dbRefrence.child(uid!).remove();
      //SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      SystemNavigator.pop();
    });
  }
}
