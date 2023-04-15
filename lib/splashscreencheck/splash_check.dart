import 'dart:async';
import '../splashscreencheck/check_user.dart';
import 'package:flutter/material.dart';

class SplashCheck {
  void islogin(BuildContext context) {
    //Timer(Duration(seconds: 3), ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),),),);z
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckUser(),
        ),
      ),
    );
  }
}
