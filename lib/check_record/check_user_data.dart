import 'dart:async';

import 'package:abo_initial/add/enter_data.dart';
import 'package:abo_initial/homepage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// class CheckUserDate extends StatefulWidget {
//   const CheckUserDate({super.key});

//   @override
//   State<CheckUserDate> createState() => _CheckUserDateState();
// }

// class _CheckUserDateState extends State<CheckUserDate> {
//       final user = FirebaseAuth.instance.currentUser;
//      var dbShowRefrence = FirebaseDatabase.instance.ref("Data").child('id');
//     String? num ;
    

//     @override
//   void initState() {
//     num = user?.phoneNumber;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
// return Scaffold( 
  
//   body: if (snapshot.value != null) {
//         // User data already exists
//         return const HomePage();
//       } else {
//         // User data doesn't exist
//         return const EnterData();
//       }
// );
    
//   }
// }

// class CheckUserDate{
//   final user = FirebaseAuth.instance.currentUser;
//      var dbShowRefrence = FirebaseDatabase.instance.ref("Data").child('id');
//     // String? num = user!.phoneNumber;
//   Future<DatabaseEvent> snapshot =  dbShowRefrence.once();
//   if( snapshot.value == null ){
//     print("Item doesn't exist in the db");
//   }else{
//     print("Item exists in the db");
//   }


// }