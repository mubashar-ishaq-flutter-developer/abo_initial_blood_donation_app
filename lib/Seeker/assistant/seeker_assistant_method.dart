import 'dart:convert';
import 'package:abo_initial/Common/global/global_variable.dart';

import 'package:http/http.dart' as http;

class SeekerAssistantMethod {
  static sendNotificationToDonorNow(
      String deviceRegistrationToken, String donateRequestId, context) async {
    String destinationAddress = userPickUpLocation;
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };
    Map bodyNotification = {
      "body": "Please Donate Blood! It is Urgent for Patient..",
      "title": "ABO Spotter"
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "donateRequestID": donateRequestId
    };
    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var reponseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
