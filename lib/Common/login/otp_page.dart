import 'package:abo_initial/Common/add/enter_data.dart';
import 'package:abo_initial/Common/homepage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../tostmessage/tost_message.dart';
import 'login_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});
  static String code = "";

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  //auth variable
  final FirebaseAuth auth = FirebaseAuth.instance;

  varifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginPage.varify, smsCode: OtpPage.code);
    await auth.signInWithCredential(credential).then((value) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const EnterData(),
      //   ),
      // );
      //checking if login user hase a recod
      final user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
      dbRefrence.child(uid!).child("bloodgroup").once().then((recodKey) {
        final snap = recodKey.snapshot;
        if (snap.value != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EnterData(),
            ),
          );
        }
      });
    }).onError((FirebaseAuthException error, stackTrace) {
      TostMessage().tostMessage(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_bg.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "OTP Varification",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Enter OTP that is send at your number !",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  OtpPage.code = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    varifyOTP();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    "Verify OTP",
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TostMessage().tostMessage("Login Successfully!");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false);
                },
                child: const Text(
                  "Edit Phone Number?",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
