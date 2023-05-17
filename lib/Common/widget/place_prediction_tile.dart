import 'package:abo_initial/Common/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../model/directions.dart';
import '../../Seeker/models/predicted_places.dart';
import '../global/map_key.dart';
import '../requestAssistant/request_assistant.dart';

//https://developers.google.com/maps/documentation/places/web-service/autocomplete#:~:text=The%20Place%20Autocomplete%20service%20is,string%20and%20optional%20geographic%20bounds.
//https://developers.google.com/maps/documentation/places/web-service/place-id
class PlacePredictionTileDesign extends StatelessWidget {
  //from model class
  final PredictedPlaces? predictedPlaces;
  //constructor
  const PlacePredictionTileDesign({super.key, this.predictedPlaces});
  //method call and capture values
  getPlaceDirectionDetails(String? placeId, context) async {
    //dialog for location getting
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Up Drof-Off!",
      ),
    );
    //paste placeid api link
    String PlaceDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    //wait for api response
    var responceApi =
        await RequestAssistant.receiveRequest(PlaceDirectionDetailsUrl);

    Navigator.pop(context);

    if (responceApi == "Error Occurred, Failed. No Response.") {
      return;
    }
    if (responceApi["status"] == "OK") {
      //if we get the responce then move towards the direction class

      Directions directions = Directions();
      //https://developers.google.com/maps/documentation/places/web-service/details
      //now we get the location lat and longitude for draw a route
      directions.locationName = responceApi["result"]["name"];
      //place id
      directions.locationId = placeId;
      //place latitude
      directions.locationLatitude =
          responceApi["result"]["geometry"]["location"]["lat"];
      //places  longitude
      directions.locationLongitude =
          responceApi["result"]["geometry"]["location"]["lng"];
      //share live location
      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);
      //now sending the location to scrollable sheet page
      Navigator.pop(context, "obtainedDropoff");

      // print("\nlocation name = " + directions.locationName!);
      // print("\nlocation lat = " + directions.locationLatitude!.toString());
      // print("\nlocation lng = " + directions.locationLongitude!.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //user select any address
    return ElevatedButton(
      onPressed: () {
        //get user's selected address
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 14.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    //null checks
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    //null checks
                    predictedPlaces!.secondary_text!,
                    //if text to much long it converted into dotted form
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
