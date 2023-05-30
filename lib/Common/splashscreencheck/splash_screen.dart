// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global_variable.dart';
import 'check_user.dart';
// import './login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckUser(),
        ),
      );
    });
    getVisibilityState().then((value) {
      setState(() {
        isvisible =
            value; // update the visibility state with the retrieved value
      });
    });
  }

  Future<bool> getVisibilityState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isVisible') ?? true;
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
              "ABO Spotter",
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
