import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../global/global_variable.dart';

/*
In this file we are getting data from database
and findinging current user and storing record
of current user in gloal variable
 */

class CurrentUser {
  static readRecords() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    final dbRefrence =
        FirebaseDatabase.instance.ref().child("Data").child(uid!);
    dbRefrence.once().then((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        return null;
      } else {
        Map cust = event.snapshot.value as Map;
        cust[Key] = event.snapshot.key;
        gfname = cust["fname"];
        glname = cust["lname"];
        gnumber = cust["number"];
        gbloodgroup = cust["bloodgroup"];
      }
    });
  }
}
