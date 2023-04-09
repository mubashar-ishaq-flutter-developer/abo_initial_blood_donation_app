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
  var dbShowRefrence;
  var reference;

  @override
  void dispose() {
    super.dispose();
  }

  String? uid;
  String? numb;
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    numb = user?.phoneNumber;
    uid = user?.uid;
    dbShowRefrence = FirebaseDatabase.instance.ref().child("Data");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirebaseAnimatedList(
          query: dbShowRefrence,
          itemBuilder: (context, snapshot, animation, index) {
            final fname = snapshot.child("fname").value.toString();
            final lname = snapshot.child("lname").value.toString();
            final id = snapshot.child("id").value.toString();
            // final lname = snapshot.value['fname'];
            if (id.contains(uid!)) {
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
            } else {
              return Container();
            }
          }),
    );

    // return Text(uid!);
  }
}
