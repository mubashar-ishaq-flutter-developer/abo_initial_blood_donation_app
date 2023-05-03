import 'package:abo_initial/assistantnt/request_assistant.dart';
import 'package:abo_initial/global/map_key.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinate(
      Position position) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
    }

    return humanReadableAddress;
  }
}
