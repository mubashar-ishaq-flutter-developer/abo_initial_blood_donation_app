import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {
    //1. Rerminated State when app is completely close
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display Seeker Request information who request for blood donation
      }
    });
    //2.Foreground State when app is open in view & in use
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {});
    //3.Background when app is running in the background
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? remoteMessage) {});
  }

  Future generateAndGetToken() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    String? registractionToken = await messaging.getToken();
    print("Fcm Registraction Token :");
    print(registractionToken);
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence.child(uid!).child("token").set(registractionToken);

    messaging.subscribeToTopic("allDonors");
    messaging.subscribeToTopic("allSeekers");
  }
}
