import 'package:flutter/cupertino.dart';
import '../model/donor_direction.dart';

class DonorInfo extends ChangeNotifier {
  DonorDirections? donorPickUpLocation, userDropOffLocation;

  void updatePickUpLocationAddress(DonorDirections donorPickUpAddress) {
    donorPickUpLocation = donorPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(DonorDirections dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
