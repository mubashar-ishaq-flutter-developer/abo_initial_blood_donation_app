import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homepage/home_page.dart';
import '../login/login_page.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

// class Checkuser {
//   void checkuser() {
//     //Timer(Duration(seconds: 3), ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),),),);z
//     final auth = FirebaseAuth.instance;
//     final user = auth.currentUser;
//     if (user != null) {
//       return const HomePage();
//     } else {
//       return const LoginPage();
//     }
//   }
// }
