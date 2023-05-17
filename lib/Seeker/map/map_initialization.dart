import 'dart:async';
import 'package:abo_initial/Common/tostmessage/tost_message.dart';
import 'package:abo_initial/Seeker/map/select_nearest_active_donors_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../Common/global/global_variable.dart';
import '../../Common/theme/map_theme.dart';
import '../../Common/widget/progress_dialog.dart';
import '../assistantnt/assistant_methord.dart';
import '../assistantnt/geofire_assistant.dart';
import '../../Common/infoHandler/app_info.dart';
import '../map/search_places_screen.dart';
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
  double searchLocationContainerHeight = 220;
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
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  BitmapDescriptor? activeNearbyIcon;
  List<ActiveNearbyAvailableDonors> onlineNearByAvailableDonorsList = [];
  bool activeNearbyDonorKeysLoaded = false;

  DatabaseReference? refrenceRideRequest;

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
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinate(
            userCurrentPosition!, context);

    initializeGeoFireListener();
  }

  saveSeekerRequestInformation() {
    refrenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Seeker Request").push();
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

    refrenceRideRequest!.set(userInformationMap);
    //1. save the seeker request information
    onlineNearByAvailableDonorsList =
        GeoFireAssistant.activeNearbyAvailableDonorsList;
    searchNearestOnlineDonors();
  }

  searchNearestOnlineDonors() async {
    //2. cancel the seeker request
    //when no online donor available
    if (onlineNearByAvailableDonorsList.isEmpty) {
      //cancel/delete Ride Information
      refrenceRideRequest!.remove();
      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      TostMessage().tostMessage(
          "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), () {
        // MyApp.restartApp(context);
        SystemNavigator.pop();
      });

      return;
    }
    //passing the list of donors
    //active donor availabe
    await retrieveOnlineDonorsInformation(onlineNearByAvailableDonorsList);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => SelectNearestActiveDonorsScreen(
            refrenceRideRequest: refrenceRideRequest),
      ),
    );
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
              MapTheme.blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
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
                  color: Colors.black87,
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
                      //from
                      Row(
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
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
                      GestureDetector(
                        onTap: () async {
                          //go to search places screen
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropoff") {
                            //draw routes - draw polyline
                            await drawPolyLineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Text(
                                //   "To",
                                //   style: TextStyle(
                                //       color: Colors.grey, fontSize: 12),
                                // ),
                                Text(
                                  //display the seeker location in widget in human readable form
                                  Provider.of<AppInfo>(context)
                                              .userDropOffLocation !=
                                          null
                                      ? Provider.of<AppInfo>(context)
                                          .userDropOffLocation!
                                          .locationName!
                                      : "Where to go?",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

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
        ],
      ),
    );
  }

  //from assistant method file
  Future<void> drawPolyLineFromOriginToDestination() async {
    //getting the positions

    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);
    //progress dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );
//then call our method in assistant methods
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
//send it to next file
    Navigator.pop(context);
//polyline points
    PolylinePoints pPoints = PolylinePoints();
    //decoded polyline points

    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      //list accepts the polyline latlng
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        //get the points
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        //color of polyline
        color: const Color.fromARGB(255, 90, 148, 249),
        //for same id
        polylineId: const PolylineId("PolylineID"),
        //joint the points
        jointType: JointType.round,
        //joint the points
        points: pLineCoOrdinatesList,
        //from destination position
        startCap: Cap.roundCap,
        //ended with round cap
        endCap: Cap.roundCap,
        geodesic: true,
      );
      //define the property polyline for each point
      polyLineSet.add(polyline);
    });
    //adjust the maps according to the lines
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    //function call
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    //upgrating the origin marker
    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    //updating the destination marker
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    //setting the state
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
    //origin circle modification
    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );
    //destination circle modification
    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );
    //setting the state
    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

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
    Set<Marker> donorsMarkerSet = Set<Marker>();

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

  //for creating the image instead of marker
  createActiveNearByDonorIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/donor.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}
