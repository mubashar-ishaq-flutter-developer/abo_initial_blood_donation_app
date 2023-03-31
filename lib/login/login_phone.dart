import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import '../tostmessage/tost_message.dart';
import '../login/otp_page.dart';

class LoginPhone extends StatefulWidget {
  static String varify = "";

  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  TextEditingController countrycode = TextEditingController();
  TextEditingController pNumber = TextEditingController();
  var phone = "";
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    countrycode.text = "+92";
    super.initState();
  }

  @override
  void dispose() {
    countrycode.dispose();
    pNumber.dispose();
    super.dispose();
  }

  void cd() {
    if (countryCode != null) {
      countryCode!.flagImage;
      countryCode!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: const Text("Number Varification"),
      //   centerTitle: true,
      // ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
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
                "Numbar Varification",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Join us by registring your mobile number to get started !",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),

              // Container(
              //   height: 55,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 2,
              //       color: Colors.blueGrey,
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Row(
              //     children: [
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       SizedBox(
              //         width: 40,
              //         child: TextField(
              //           controller: countrycode,
              //           decoration:
              //               const InputDecoration(border: InputBorder.none),
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       const Text(
              //         "|",
              //         style: TextStyle(
              //           fontSize: 34,
              //           color: Colors.grey,
              //         ),
              //       ),
              //       Expanded(
              //         child: TextField(
              //           keyboardType: TextInputType.phone,
              //           controller: pNumber,
              //           decoration: const InputDecoration(
              //             border: InputBorder.none,
              //             hintText: "Enter mobile number",
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(
              //   height: 20,
              // ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.blueGrey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final code =
                            await countryPicker.showPicker(context: context);
                        setState(() {
                          countryCode = code;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            child: countryCode != null
                                ? countryCode!.flagImage
                                : null,
                          ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Container(
                            width: 55,
                            height: 53,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(09),
                                bottomLeft: Radius.circular(09),
                              ),
                            ),
                            child: Text(
                              countryCode?.dialCode ?? "Select Country",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "|",
                      style: TextStyle(
                        fontSize: 34,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: pNumber,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter mobile number",
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return '';
                          //   } else {
                          //     return null;
                          //   }
                          // },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      if (countryCode != null) {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     });
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber:
                              countryCode!.dialCode + pNumber.text.toString(),
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) {
                            LoginPhone.varify = verificationId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpPage(),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } else {
                        TostMessage().tostMessage("Please Select Country");
                      }
                    } else {
                      TostMessage().tostMessage("Please Enter Number");
                    }
                    //  Navigator.of(context).pop();
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
                    "Send Code",
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
