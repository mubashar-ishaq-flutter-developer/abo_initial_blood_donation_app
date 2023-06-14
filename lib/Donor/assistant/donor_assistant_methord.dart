import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import '../../Common/global/global_variable.dart';

class DonorAssistantMethord {
  static pauseLiveLocationUpdates() {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    streamSubscriptionPosition?.pause();
    Geofire.removeLocation(uid!);
  }

  static resumeLiveLocationUpdates() {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
      uid!,
      donorCurrentPosition!.latitude,
      donorCurrentPosition!.longitude,
    );
  }
}
