import 'dart:async';
import 'package:abo_initial/Common/homepage/home_page.dart';
import 'package:abo_initial/Common/tostmessage/tost_message.dart';
import 'package:abo_initial/Seeker/map/select_nearest_active_donors_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Common/global/global_variable.dart';
import '../../Common/theme/map_theme.dart';
import '../../Common/assistant/assistant_methord.dart';
import '../../Common/infoHandler/app_info.dart';
import '../assistant/geofire_assistant.dart';
import '../assistant/seeker_assistant_method.dart';
import '../models/active_nearby_available_donors.dart';

class MapInitialization extends StatefulWidget {
  const MapInitialization({super.key});

  @override
  State<MapInitialization> createState() => _MapInitializationState();
}

class _MapInitializationState extends State<MapInitialization> {
  //from google_maps_flutter dcumentation
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  //default position is given or how much zoom we want on screen
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  //from google_maps_flutter
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 180;
  double waitingResponseFromDonorContainerHeight = 0;
  double assignedDonorInfoContainerHeight = 0;
  //from geo locator documentation
  Position? userCurrentPosition;
  //from geolocator
  var geoLocator = Geolocator();
  // LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;
  //for polyline points
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  //for polyline markers
  Set<Marker> markersSet = <Marker>{};
  Set<Circle> circlesSet = <Circle>{};

  BitmapDescriptor? activeNearbyIcon;
  List<ActiveNearbyAvailableDonors> onlineNearByAvailableDonorsList = [];
  bool activeNearbyDonorKeysLoaded = false;

  DatabaseReference? refrenceDonateRequest;

  String donorAcceptStatus = "Donor is Coming";

  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userDonateRequestStatus = "";
  bool requestPositionInfo = true;

  locateUserPosition() async {
    //for getting current location of seeker
    Position cPosition = await Geolocator.getCurrentPosition(
        //for setting the accuracy of location
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    //for getting the longitude and latitude of seeker
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    //current position of camera
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    //convert the latlng into the human readable form using provider
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //then go to the assistants method class to get humanReadableAddress
    humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinate(
            userCurrentPosition!, context);

    initializeGeoFireListener();
  }

  saveSeekerRequestInformation() {
    refrenceDonateRequest = FirebaseDatabase.instance
        .ref()
        .child("All Seeker Donation Request")
        .push();
    var originLocation = Provider.of<AppInfo>(
      context,
      listen: false,
    ).userPickUpLocation;
    Map originLocationMap = {
      //"Key" : value
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString(),
    };
    Map userInformationMap = {
      "origin": originLocationMap,
      "time": DateTime.now().toString(),
      "fname": gfname.toString(),
      "lname": glname.toString(),
      "number": gnumber.toString(),
      "originaddress": originLocation.locationName,
      "donorid": "waiting",
    };

    refrenceDonateRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        refrenceDonateRequest!.onValue.listen((eventSnap) {
      if (eventSnap.snapshot.value == null) {
        return;
      }
      if ((eventSnap.snapshot.value as Map)["donorfName"] != null) {
        setState(() {
          donorFName = (eventSnap.snapshot.value as Map)["donorfName"];
        });
      }
      if ((eventSnap.snapshot.value as Map)["donorlName"] != null) {
        setState(() {
          donorLName = (eventSnap.snapshot.value as Map)["donorlName"];
        });
      }
      if ((eventSnap.snapshot.value as Map)["donorNumber"] != null) {
        setState(() {
          donorNumber = (eventSnap.snapshot.value as Map)["donorNumber"];
        });
      }
      if ((eventSnap.snapshot.value as Map)["donorBloodGroup"] != null) {
        setState(() {
          donorBloodGroup =
              (eventSnap.snapshot.value as Map)["donorBloodGroup"];
        });
      }
      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userDonateRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }
      if ((eventSnap.snapshot.value as Map)["donorLocation"] != null) {
        double donorCurrentPositionLatitude = double.parse(
            (eventSnap.snapshot.value as Map)["donorLocation"]["latitude"]
                .toString());
        double donorCurrentPositionLongitude = double.parse(
            (eventSnap.snapshot.value as Map)["donorLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(donorCurrentPositionLatitude, donorCurrentPositionLongitude);

        //status = accepted
        if (userDonateRequestStatus == "accepted") {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
          //for testing
          // TostMessage().tostMessage("testing");
        }

        //status = arrived
        if (userDonateRequestStatus == "ended") {
          setState(() {
            donorAcceptStatus = "Donor has Arrived";
          });
        }
      }
    });

    //1. save the seeker request information
    onlineNearByAvailableDonorsList =
        GeoFireAssistant.activeNearbyAvailableDonorsList;
    searchNearestOnlineDonors();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        donorAcceptStatus =
            "Donor is Coming in :: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDonors() async {
    //cancel/delete Ride Information
    // refrenceDonateRequest!.remove();
    //when no online donor available
    if (onlineNearByAvailableDonorsList.isEmpty) {
      // setState(() {
      //   polyLineSet.clear();
      //   markersSet.clear();
      //   circlesSet.clear();
      //   pLineCoOrdinatesList.clear();
      // });

      TostMessage().tostMessage(
          "No Online Nearest Driver Available. Search Again after some time.");
      //cancel/delete Ride Information
      refrenceDonateRequest!.remove().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        return;
      }).onError((FirebaseException exception, stackTrace) {
        TostMessage().tostMessage(exception.message);
      });

      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   // MyApp.restartApp(context);
      //   // SystemNavigator.pop();
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const HomePage(),
      //     ),
      //   );
      // });

      return;
    }
    //passing the list of donors
    //active donor availabe
    await retrieveOnlineDonorsInformation(onlineNearByAvailableDonorsList);
    var response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => SelectNearestActiveDonorsScreen(
            refrenceRideRequest: refrenceDonateRequest),
      ),
    );
    if (response == "selectedDonor") {
      final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
      dbRefrence.child(chosenDonorId!).once().then((snap) {
        if (snap.snapshot.value != null) {
          //send notification to specific donor
          sendNotificationToDonorNow(chosenDonorId!);

          //Display Waiting Response from a Donor UI
          showWaitingResponceFromDonorUI();

          //Response from a Driver

          final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
          dbRefrence
              .child(chosenDonorId!)
              .child("donationStatus")
              .onValue
              .listen((eventSnapshot) {
            //1.donor has cancel the rideRequest :: Push Notification
            //(donationStatus = idle)
            if (eventSnapshot.snapshot.value == "idle") {
              TostMessage().tostMessage(
                  "The donor has cancelled your request. Please choose another donor.");
              Future.delayed(const Duration(milliseconds: 2000), () {
                // TostMessage().tostMessage("Please Restart App Now.");
                // SystemNavigator.pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              });
            }
            //2.donor has accept the rideRequest :: Push Notification
            //(donationStatus = accepted)
            if (eventSnapshot.snapshot.value == "accepted") {
              //design and display ui for displaying assigned donor information
              showUIForAssignedDonorInfo();
            }
          });
        } else {
          TostMessage().tostMessage("Donor Doesnot exist. Try again.");
        }
      });
    }
  }

  showUIForAssignedDonorInfo() {
    setState(() {
      waitingResponseFromDonorContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDonorInfoContainerHeight = 220;
    });
  }

  showWaitingResponceFromDonorUI() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDonorContainerHeight = 220;
    });
  }

  sendNotificationToDonorNow(String choosenDonorId) {
    //assign/set chosenDonorId to donationStatus in data parent node for
    //specific choosen donor
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence
        .child(chosenDonorId!)
        .child("donationStatus")
        .set(refrenceDonateRequest!.key);
    //automate push notification
    final dbRefrence2 = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence2
        .child(chosenDonorId!)
        //captures it from db
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();
        //send notification now
        SeekerAssistantMethod.sendNotificationToDonorNow(
          deviceRegistrationToken,
          refrenceDonateRequest!.key.toString(),
          context,
        );
        TostMessage().tostMessage("Notification Sends Successfully");
        // Fluttertoast.showToast(msg: "Notification Sends Successfully");
      } else {
        // Fluttertoast.showToast(msg: "Please Choose Another Donor.");
        TostMessage().tostMessage("Please Choose Another Donor.");
        return;
      }
    });
  }

  //display the list of online donors
  retrieveOnlineDonorsInformation(List onlineNearestDonorsList) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref().child("data")
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    //loop for all donors
    for (int i = 0; i < onlineNearestDonorsList.length; i++) {
      await dbRefrence
          .child(onlineNearestDonorsList[i].donorId.toString())
          .once()
          .then((dataSnapshot) {
        var donorKeyInfo = dataSnapshot.snapshot.value;
        dList.add(donorKeyInfo);
      });
    }
  }

  //for creating the image instead of marker
  createActiveNearByDonorIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/origin.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDonorIconMarker();
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
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map function call
              blackThemeGoogleMap(newGoogleMapController);

              setState(() {
                bottomPaddingOfMap = 225;
              });
              locateUserPosition();
            },
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      //from
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   "From",
                              //   style:
                              //       TextStyle(color: Colors.grey, fontSize: 12),
                              // ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24)}..."
                                    : "not getting address",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

                      //to
                      // GestureDetector(
                      //   onTap: () async {
                      //     //go to search places screen
                      //     var responseFromSearchScreen = await Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (c) => const SearchPlacesScreen()));

                      //     if (responseFromSearchScreen == "obtainedDropoff") {
                      //       //draw routes - draw polyline
                      //       await drawPolyLineFromOriginToDestination();
                      //     }
                      //   },
                      //   child: Row(
                      //     children: [
                      //       const Icon(
                      //         Icons.add_location_alt_outlined,
                      //         color: Colors.grey,
                      //       ),
                      //       const SizedBox(
                      //         width: 12.0,
                      //       ),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           // const Text(
                      //           //   "To",
                      //           //   style: TextStyle(
                      //           //       color: Colors.grey, fontSize: 12),
                      //           // ),
                      //           Text(
                      //             //display the seeker location in widget in human readable form
                      //             Provider.of<AppInfo>(context)
                      //                         .userDropOffLocation !=
                      //                     null
                      //                 ? Provider.of<AppInfo>(context)
                      //                     .userDropOffLocation!
                      //                     .locationName!
                      //                 : "Where to go?",
                      //             style: const TextStyle(
                      //                 color: Colors.grey, fontSize: 14),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(height: 10.0),

                      // const Divider(
                      //   height: 1,
                      //   thickness: 1,
                      //   color: Colors.grey,
                      // ),

                      // const SizedBox(height: 16.0),

                      ElevatedButton(
                          onPressed: () {
                            // if (Provider.of<AppInfo>(context, listen: false)
                            //         .userDropOffLocation !=
                            //     null) {
                            //   saveSeekerRequestInformation();
                            // }
                            // //if dropoff location is eqaul to null
                            // else {
                            //   Fluttertoast.showToast(
                            //       msg: "Please select destination position");
                            // }
                            saveSeekerRequestInformation();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Search for Donor")),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //UI for waiting response from donor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDonorContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting for Response\nfrom Donor',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      ScaleAnimatedText(
                        'Please wait...',
                        duration: const Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      "$donorFName $donorLName",
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
                      donorBloodGroup,
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
                            final call = 'tel://$donorNumber';
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
                            refrenceDonateRequest!.remove();
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

//   //from assistant method file
//   Future<void> drawPolyLineFromOriginToDestination() async {
//     //getting the positions

//     var originPosition =
//         Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
//     var destinationPosition =
//         Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

//     var originLatLng = LatLng(
//         originPosition!.locationLatitude!, originPosition.locationLongitude!);
//     var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
//         destinationPosition.locationLongitude!);
//     //progress dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => const ProgressDialog(
//         message: "Please wait...",
//       ),
//     );
// //then call our method in assistant methods
//     var directionDetailsInfo =
//         await AssistantMethods.obtainOriginToDestinationDirectionDetails(
//             originLatLng, destinationLatLng);
// //send it to next file
//     Navigator.pop(context);
// //polyline points
//     PolylinePoints pPoints = PolylinePoints();
//     //decoded polyline points

//     List<PointLatLng> decodedPolyLinePointsResultList =
//         pPoints.decodePolyline(directionDetailsInfo!.e_points!);

//     pLineCoOrdinatesList.clear();

//     if (decodedPolyLinePointsResultList.isNotEmpty) {
//       //list accepts the polyline latlng
//       for (var pointLatLng in decodedPolyLinePointsResultList) {
//         //get the points
//         pLineCoOrdinatesList
//             .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//       }
//     }

//     polyLineSet.clear();

//     setState(() {
//       Polyline polyline = Polyline(
//         //color of polyline
//         color: const Color.fromARGB(255, 90, 148, 249),
//         //for same id
//         polylineId: const PolylineId("PolylineID"),
//         //joint the points
//         jointType: JointType.round,
//         //joint the points
//         points: pLineCoOrdinatesList,
//         //from destination position
//         startCap: Cap.roundCap,
//         //ended with round cap
//         endCap: Cap.roundCap,
//         geodesic: true,
//       );
//       //define the property polyline for each point
//       polyLineSet.add(polyline);
//     });
//     //adjust the maps according to the lines
//     LatLngBounds boundsLatLng;
//     if (originLatLng.latitude > destinationLatLng.latitude &&
//         originLatLng.longitude > destinationLatLng.longitude) {
//       boundsLatLng =
//           LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
//     } else if (originLatLng.longitude > destinationLatLng.longitude) {
//       boundsLatLng = LatLngBounds(
//         southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
//         northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
//       );
//     } else if (originLatLng.latitude > destinationLatLng.latitude) {
//       boundsLatLng = LatLngBounds(
//         southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
//         northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
//       );
//     } else {
//       boundsLatLng =
//           LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
//     }
//     //function call
//     newGoogleMapController!
//         .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
//     //upgrating the origin marker
//     Marker originMarker = Marker(
//       markerId: const MarkerId("originID"),
//       infoWindow:
//           InfoWindow(title: originPosition.locationName, snippet: "Origin"),
//       position: originLatLng,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     );
//     //updating the destination marker
//     Marker destinationMarker = Marker(
//       markerId: const MarkerId("destinationID"),
//       infoWindow: InfoWindow(
//           title: destinationPosition.locationName, snippet: "Destination"),
//       position: destinationLatLng,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     );
//     //setting the state
//     setState(() {
//       markersSet.add(originMarker);
//       markersSet.add(destinationMarker);
//     });
//     //origin circle modification
//     Circle originCircle = Circle(
//       circleId: const CircleId("originID"),
//       fillColor: Colors.green,
//       radius: 12,
//       strokeWidth: 3,
//       strokeColor: Colors.white,
//       center: originLatLng,
//     );
//     //destination circle modification
//     Circle destinationCircle = Circle(
//       circleId: const CircleId("destinationID"),
//       fillColor: Colors.red,
//       radius: 12,
//       strokeWidth: 3,
//       strokeColor: Colors.white,
//       center: destinationLatLng,
//     );
//     //setting the state
//     setState(() {
//       circlesSet.add(originCircle);
//       circlesSet.add(destinationCircle);
//     });
//   }

  //creating the method of geo_fire documentation
  initializeGeoFireListener() {
    Geofire.initialize("activeDonors");
    //seeker current position
    //10 means kilometer range
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 100)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered: //whenever any donor become active/online
            //using the active_neaby_available_donor class
            ActiveNearbyAvailableDonors activeNearbyAvailableDonor =
                ActiveNearbyAvailableDonors();
            //finds the active nearby donor
            activeNearbyAvailableDonor.locationLatitude = map['latitude'];
            activeNearbyAvailableDonor.locationLongitude = map['longitude'];
            activeNearbyAvailableDonor.donorId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDonorsList
                .add(activeNearbyAvailableDonor);
            if (activeNearbyDonorKeysLoaded == true) {
              displayActiveDonorsOnSeekersMap();
            }
            break;

          case Geofire
                .onKeyExited: //whenever any donor become non active/offline
            GeoFireAssistant.deleteOfflineDonorFromList(map[Key]);
            displayActiveDonorsOnSeekersMap();
            break;
          //whenever donor moves  update donor
          case Geofire.onKeyMoved:
            //using the active_neaby_available_donor class
            ActiveNearbyAvailableDonors activeNearbyAvailableDonor =
                ActiveNearbyAvailableDonors();
            //finds the active nearby donor
            activeNearbyAvailableDonor.locationLatitude = map['latitude'];
            activeNearbyAvailableDonor.locationLongitude = map['longitude'];
            activeNearbyAvailableDonor.donorId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDonorLocation(
                activeNearbyAvailableDonor);
            displayActiveDonorsOnSeekersMap();
            break;

          //display those online active donor on seeker's app
          case Geofire.onGeoQueryReady:
            activeNearbyDonorKeysLoaded = true;
            displayActiveDonorsOnSeekersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDonorsOnSeekersMap() {
    //firstly clear all markers
    setState(() {
      markersSet.clear();
      circlesSet.clear();
    });
    Set<Marker> donorsMarkerSet = <Marker>{};

    //contains the all near available donor
    for (ActiveNearbyAvailableDonors eachDonor
        in GeoFireAssistant.activeNearbyAvailableDonorsList) {
      //position of each donor assign to that variable
      LatLng eachDonorActivePosition =
          LatLng(eachDonor.locationLatitude!, eachDonor.locationLongitude!);
      //marker to the specific donor
      //display the marker
      Marker marker = Marker(
        markerId: MarkerId(eachDonor.donorId!),
        position: eachDonorActivePosition,
        //assign the image
        icon: activeNearbyIcon!,
        rotation: 360,
      );
      //all available donor
      donorsMarkerSet.add(marker);
      //set the state of donor
      setState(() {
        markersSet = donorsMarkerSet;
      });
    }
  }
}
