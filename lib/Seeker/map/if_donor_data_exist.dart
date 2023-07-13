import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Common/global/global_variable.dart';
import '../../Common/theme/map_theme.dart';

class IfDonorDataExist extends StatefulWidget {
  const IfDonorDataExist({super.key});

  @override
  State<IfDonorDataExist> createState() => _IfDonorDataExistState();
}

class _IfDonorDataExistState extends State<IfDonorDataExist> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  //default position is given or how much zoom we want on screen
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  //from google_maps_flutter
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double bottomPaddingOfMap = 0;
  double assignedDonorInfoContainerHeight = 220;
  String donorAcceptStatus = "Donor has Arrived";
  String donorFNames = "mu ";
  String donorLNames = "bs";
  String donorNumbers = " ";
  String donorBloodGroups = " ";

  final dbRefrence = FirebaseDatabase.instance
      .ref()
      .child("All Seeker Donation Request")
      .child(gid!);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      body: Stack(
        children: [
          //modifies google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map function call
              blackThemeGoogleMap(newGoogleMapController);

              setState(() {
                bottomPaddingOfMap = 225;
              });
            },
          ),
          //UI for displaying assigned donor information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDonorInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        donorAcceptStatus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 13.0,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 13.0,
                    ),

                    //driver vehicle details
                    Text(
                      "$donorFNames $donorLNames",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    Text(
                      donorBloodGroups,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 13,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 13.0,
                    ),

                    // call donor
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final call = 'tel://$donorNumbers';
                            // ignore: deprecated_member_use
                            if (await canLaunch(call)) {
                              // ignore: deprecated_member_use
                              await launch(call);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          icon: const Icon(
                            Icons.call,
                            color: Colors.black54,
                            size: 22,
                          ),
                          label: const Text(
                            "Call Donor",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        //end location
                        ElevatedButton.icon(
                          onPressed: () {
                            dbRefrence.remove();
                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              SystemNavigator.pop();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.black54,
                            size: 22,
                          ),
                          label: const Text(
                            "End Location",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
