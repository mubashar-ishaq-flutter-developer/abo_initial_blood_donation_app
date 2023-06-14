import 'package:abo_initial/Common/global/global_variable.dart';
import 'package:abo_initial/Common/tostmessage/tost_message.dart';
import 'package:abo_initial/Donor/push_notifications/notification_dialog_box.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/seeker_danate_request_information.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1. Rerminated State when app is completely close
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      // if (remoteMessage != null) {
      //display Seeker Request information who request for blood donation
      readSeekerDonateRequestInformation(
          remoteMessage!.data["donateRequestID"], context);
      // }
    });
    //2.Foreground State when app is open in view & in use
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readSeekerDonateRequestInformation(
          remoteMessage!.data["donateRequestID"], context);
    });
    //3.Background when app is running in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readSeekerDonateRequestInformation(
          remoteMessage!.data["donateRequestID"], context);
    });
  }

  readSeekerDonateRequestInformation(
      String seekerDonateRequestId, BuildContext context) {
    final dbRefrence =
        FirebaseDatabase.instance.ref().child("All Seeker Donation Request");
    dbRefrence.child(seekerDonateRequestId).once().then((snapData) {
      if (snapData.snapshot.value != null) {
        assetsAudioPlayer.open(
          Audio("assets/music_notification.mp3"),
        );
        assetsAudioPlayer.play();
        double originLatitude = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLongitude = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originaddress"];
        String fName = (snapData.snapshot.value! as Map)["fname"];
        String lName = (snapData.snapshot.value! as Map)["lname"];
        String number = (snapData.snapshot.value! as Map)["number"];
        String? donateRequestId = snapData.snapshot.key;
        //storing data in seekerdonaterequestinformation for future use
        SeekerDonateRequestInformation seekerDonateRequestDetails =
            SeekerDonateRequestInformation();
        seekerDonateRequestDetails.originLatling =
            LatLng(originLatitude, originLongitude);
        seekerDonateRequestDetails.originAddress = originAddress;
        seekerDonateRequestDetails.fName = fName;
        seekerDonateRequestDetails.lName = lName;
        seekerDonateRequestDetails.number = number;
        seekerDonateRequestDetails.donateRequestId = donateRequestId;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            seekerDonateRequestDetails: seekerDonateRequestDetails,
          ),
        );
      } else {
        TostMessage().tostMessage("Donate Request Id Doesnot exists.");
      }
    });
  }

  Future generateAndGetToken() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    String? registractionToken = await messaging.getToken();
    // print("Fcm Registraction Token :");
    // print(registractionToken);
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence.child(uid!).child("token").set(registractionToken);

    messaging.subscribeToTopic("allDonors");
    messaging.subscribeToTopic("allSeekers");
  }
}
