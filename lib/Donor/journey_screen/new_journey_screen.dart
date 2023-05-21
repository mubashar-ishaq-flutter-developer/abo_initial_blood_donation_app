import 'dart:async';
import 'package:abo_initial/Common/global/global_variable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Common/assistant/assistant_methord.dart';
import '../../Common/theme/map_theme.dart';
import '../../Common/widget/progress_dialog.dart';
import '../model/seeker_danate_request_information.dart';

class NewJourneyScreen extends StatefulWidget {
  final SeekerDonateRequestInformation? seekerDonateRequestDetails;
  const NewJourneyScreen({this.seekerDonateRequestDetails, super.key});

  @override
  State<NewJourneyScreen> createState() => _NewJourneyScreenState();
}

class _NewJourneyScreenState extends State<NewJourneyScreen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newJourneyGoogleMapController;
  Set<Marker> setOfMarker = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolynine = <Polyline>{};
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPadding = 0;

//draw poly line
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    //progress dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => const ProgressDialog(
        message: "Please wait...",
      ),
    );
//then call our method in assistant methods
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    Navigator.pop(context);
//polyline points
    PolylinePoints pPoints = PolylinePoints();
    //decoded polyline points

    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      //list accepts the polyline latlng
      for (var pointLatLng in decodedPolyLinePointsResultList) {
        //get the points
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setOfPolynine.clear();

    setState(() {
      Polyline polyline = Polyline(
        //color of polyline
        color: Colors.purpleAccent,
        //for same id
        polylineId: const PolylineId("PolylineID"),
        //joint the points
        jointType: JointType.round,
        //joint the points
        points: polyLinePositionCoordinates,
        //from destination position
        startCap: Cap.roundCap,
        //ended with round cap
        endCap: Cap.roundCap,
        geodesic: true,
      );
      //define the property polyline for each point
      setOfPolynine.add(polyline);
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
    newJourneyGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    //upgrating the origin marker
    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    //updating the destination marker
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    //setting the state
    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
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
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();
    saveAssignedDonorDetailstoSeekerDonationRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarker,
            circles: setOfCircle,
            polylines: setOfPolynine,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              // newGoogleMapController is importing from common global
              newJourneyGoogleMapController = controller;
              setState(() {
                mapPadding = 270;
              });
              //for black theme importring from theme common
              blackThemeGoogleMap(newJourneyGoogleMapController);
              var donorCurrentLatLng = LatLng(donorCurrentPosition!.latitude,
                  donorCurrentPosition!.longitude);
              var seekerOriginLatLng =
                  widget.seekerDonateRequestDetails!.originLatling;
              drawPolyLineFromOriginToDestination(
                  donorCurrentLatLng, seekerOriginLatLng!);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const Text(
                      "10 minuts",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreenAccent),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    //user name with Icon
                    Row(
                      children: [
                        Text(
                          "${widget.seekerDonateRequestDetails!.fName!} ${widget.seekerDonateRequestDetails!.lName!}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //user origin location with icage icon
                    Row(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      icon: const Icon(Icons.directions_walk_rounded),
                      label: const Text(
                        "Arrived",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  saveAssignedDonorDetailstoSeekerDonationRequest() {
    final dbRefrence = FirebaseDatabase.instance
        .ref()
        .child("All Seeker Donation Request")
        .child(widget.seekerDonateRequestDetails!.donateRequestId!);
    Map donorLocationDataMap = {
      "latitude": donorCurrentPosition!.latitude.toString(),
      "longitude": donorCurrentPosition!.longitude.toString(),
    };
    dbRefrence.child("donorLocation").set(donorLocationDataMap);
    dbRefrence.child("status").set("accepted");
    dbRefrence.child("donorId").set(onlineDonorData.id);
    dbRefrence.child("donorfName").set(onlineDonorData.fName);
    dbRefrence.child("donorlName").set(onlineDonorData.lName);
    dbRefrence.child("donorNumber").set(onlineDonorData.number);
    dbRefrence.child("donorBloodGroup").set(onlineDonorData.bloodGroup);
  }
}
