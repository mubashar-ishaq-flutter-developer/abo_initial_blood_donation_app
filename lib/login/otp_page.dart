import 'package:abo_initial/add/enter_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../login/login_phone.dart';
import '../tostmessage/tost_message.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  //auth variable
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var code = "";
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
                height: 180,
                width: 180,
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
                "Enter otp that is send at your number !",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              //Pinput(
              // defaultPinTheme: defaultPinTheme,
              // focusedPinTheme: focusedPinTheme,
              // submittedPinTheme: submittedPinTheme,
              // validator: (s) {
              //   return s == '2222' ? null : 'Pin is incorrect';
              // },
              //pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              //showCursor: true,
              //onCompleted: (pin) => print(pin),
              //),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: LoginPhone.varify, smsCode: code);
                    await auth.signInWithCredential(credential).then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterData(),
                        ),
                      );
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const AddData(),
                      //   ),
                      // );
                    }).onError((FirebaseAuthException error, stackTrace) {
                      TostMessage().tostMessage(error.message);
                    });
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
                    "Varify OTP",
                  ),
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text("Want to change Number ?"),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pushAndRemoveUntil(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const LoginPage(),
              //             ),
              //             (route) => false);
              //       },
              //       child: const Text('Edit'),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      TostMessage().tostMessage("Login Successfully!");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPhone(),
                          ),
                          (route) => false);
                    },
                    child: const Text(
                      "Edit Phone Number?",
                    ),
                  ),
                ],
              ),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       SizedBox(
              //         height: 45,
              //         width: 150,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, "otp_page");
              //           },
              //           child: Text(
              //             "Send Code",
              //           ),
              //           style: ElevatedButton.styleFrom(
              //             primary: Colors.blue,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             textStyle: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       SizedBox(
              //         height: 45,
              //         width: 150,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, "otp_page");
              //           },
              //           child: Text(
              //             "Send Code",
              //           ),
              //           style: ElevatedButton.styleFrom(
              //             primary: Colors.blue,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             textStyle: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
