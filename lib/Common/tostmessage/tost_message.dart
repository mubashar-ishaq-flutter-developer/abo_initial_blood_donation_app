import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TostMessage {
  void tostMessage(var message) {
    Fluttertoast.showToast(
        msg: message,
        //toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
