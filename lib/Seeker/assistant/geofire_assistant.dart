import '../models/active_nearby_available_donors.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvailableDonors> activeNearbyAvailableDonorsList = [];
  //remove offline donor from list
  static void deleteOfflineDonorFromList(String donorId) {
    //specific donor who become offline
    int indexNumber = activeNearbyAvailableDonorsList
        .indexWhere((element) => element.donorId == donorId);
    activeNearbyAvailableDonorsList.removeAt(indexNumber);
  }

  //update active donor location
  static void updateActiveNearbyAvailableDonorLocation(
      ActiveNearbyAvailableDonors donorWhoMove) {
    //equals to the donor id who moves
    int indexNumber = activeNearbyAvailableDonorsList
        .indexWhere((element) => element.donorId == donorWhoMove.donorId);
    //update latlng who moves
    activeNearbyAvailableDonorsList[indexNumber].locationLatitude =
        donorWhoMove.locationLatitude;
    activeNearbyAvailableDonorsList[indexNumber].locationLongitude =
        donorWhoMove.locationLongitude;
  }
}
