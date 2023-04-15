// import 'dart:async';

import 'package:flutter/material.dart';
import '../splashscreencheck/splash_check.dart';
// import './login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashCheck splashcheck = SplashCheck();
  @override
//   void islogin(){
//  Timer(Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => LoginPage(),
//         ),
//       );
//     });
//   }
  void initState() {
    super.initState();
    splashcheck.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo_bg.png",
              width: 180,
              height: 180,
            ),
            const Text(
              "Abo Spotter Initial",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
