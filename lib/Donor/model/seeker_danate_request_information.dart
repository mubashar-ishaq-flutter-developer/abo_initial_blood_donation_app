import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeekerDonateRequestInformation {
  LatLng? originLatling;
  String? originAddress;
  String? donateRequestId;
  String? fName;
  String? lName;
  String? number;
  SeekerDonateRequestInformation({
    this.originLatling,
    this.originAddress,
    this.donateRequestId,
    this.fName,
    this.lName,
    this.number,
  });
}
