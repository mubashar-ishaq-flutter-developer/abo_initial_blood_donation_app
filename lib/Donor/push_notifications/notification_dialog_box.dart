import "package:abo_initial/Common/global/global_variable.dart";
import "package:abo_initial/Common/tostmessage/tost_message.dart";
import "package:abo_initial/Donor/assistant/donor_assistant_methord.dart";
import 'package:abo_initial/Donor/journey_screen/new_journey_screen.dart';
import "package:assets_audio_player/assets_audio_player.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../model/seeker_danate_request_information.dart";

class NotificationDialogBox extends StatefulWidget {
  final SeekerDonateRequestInformation? seekerDonateRequestDetails;
  const NotificationDialogBox({
    super.key,
    this.seekerDonateRequestDetails,
  });

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            //title
            const Text(
              "Donation Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //displaying seeker oriin location address
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/origin.png",
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.seekerDonateRequestDetails!.originAddress!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
              height: 3,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //button to reject seeker request if donor want
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();
                    Navigator.pop(context);
                    final user = FirebaseAuth.instance.currentUser;
                    String? uid = user?.uid;
                    final dbRefrence =
                        FirebaseDatabase.instance.ref().child("Data");
                    final databaseReference = FirebaseDatabase.instance
                        .ref()
                        .child("All Seeker Donation Request")
                        .child(widget
                            .seekerDonateRequestDetails!.donateRequestId!);
                    databaseReference.remove().then((value) {
                      dbRefrence
                          .child(uid!)
                          .child("donationStatus")
                          .set("idle");
                      TostMessage().tostMessage(
                          "Donate Request has been Cancelled Successfully!");
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const HomePage(),
                        //   ),
                        // );
                        SystemNavigator.pop();
                      });
                    }).onError((FirebaseAuthException error, stackTrace) {
                      TostMessage().tostMessage(error.message);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Reject"),
                ),
                const SizedBox(
                  width: 15,
                ),
                //button to accept seeker request if donor want
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();

                    acceptDonationRequest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Accept"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  acceptDonationRequest(BuildContext context) {
    String? getDonationRequestId;
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence.child(uid!).child("donationStatus").once().then((snap) {
      if (snap.snapshot.value != null) {
        getDonationRequestId = snap.snapshot.value.toString();
      } else {
        TostMessage().tostMessage("Donation request ID do not exist.");
      }
      if (getDonationRequestId ==
          widget.seekerDonateRequestDetails!.donateRequestId) {
        final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
        dbRefrence.child(uid).child("donationStatus").set("accepted");
        //we are pause live location updates so that user get
        //its current location not changing location
        DonorAssistantMethord.pauseLiveLocationUpdates();
        //Journey started and send donor to journey screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewJourneyScreen(
                seekerDonateRequestDetails: widget.seekerDonateRequestDetails),
          ),
        );
      } else {
        TostMessage().tostMessage("Donation Request donot exist");
      }
    });
  }
}
