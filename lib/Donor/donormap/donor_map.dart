import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Common/global/global_variable.dart';
import '../../Common/theme/map_theme.dart';
import '../../Common/tostmessage/tost_message.dart';
import '../donorassistant/donor_assistant_methord.dart';
import 'donor_status.dart';

class DonorMap extends StatefulWidget {
  const DonorMap({super.key});

  @override
  State<DonorMap> createState() => _DonorMapState();
}

class _DonorMapState extends State<DonorMap> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();
  locateDonorPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    donorCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(donorCurrentPosition!.latitude, donorCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humansReadableAddress =
        await DonorAssistantMethods.searchAddressForGeographicCoOrdinate(
            donorCurrentPosition!, context);
  }

  final DonorStatus donorStatus = DonorStatus();
  String statusText = "Now Offline";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              // newGoogleMapController is importing from common global
              newGoogleMapController = controller;
              //for black theme importring from theme common
              MapTheme.blackThemeGoogleMap();

              locateDonorPosition();
            },
          ),
          //ui for online offline driver
          statusText != "Now Online"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black87,
                )
              : Container(),

          //button for online offline driver
          Positioned(
            top: statusText != "Now Online" ? 0 : 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //if driver is offline and make it online
                    if (isDonorActive != true) {
                      DonorStatus.donorIsOnlineNow();
                      donorStatus.updateDonorLocationAtRealTime();
                      setState(() {
                        statusText = "Now Online";
                        isDonorActive = true;
                      });
                      TostMessage().tostMessage("You are Online Now");
                    } //if donor is online and make him offline
                    else {
                      donorStatus.driverIsOfflineNow();
                      setState(() {
                        statusText = "Now Offline";
                        isDonorActive = false;
                      });
                      TostMessage().tostMessage("You are Offline Now");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: statusText != "Now Online"
                      ? Text(
                          statusText,
                        )
                      : const Icon(Icons.phonelink_ring_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
