// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DisplayUser extends StatefulWidget {
  const DisplayUser({super.key});
  // final Function aduser;
  // HomePage(this.aduser);

  @override
  State<DisplayUser> createState() => _DisplayUserState();
}

class _DisplayUserState extends State<DisplayUser> {
  final user = FirebaseAuth.instance.currentUser;

  var dbShowRefrence;
  var reference;
  String? num;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    num = user?.phoneNumber;
    dbShowRefrence = FirebaseDatabase.instance.ref("Data");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirebaseAnimatedList(
          query: dbShowRefrence,
          itemBuilder: (context, snapshot, animation, index) {
            final fname = snapshot.child("fname").value.toString();
            final lname = snapshot.child("lname").value.toString();
            // final lname = snapshot.value['fname'];
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 70,
                  ),
                  Text(
                    '$fname $lname',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
