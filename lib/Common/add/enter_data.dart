import 'package:abo_initial/Common/homepage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../tostmessage/tost_message.dart';

class EnterData extends StatefulWidget {
  const EnterData({super.key});

  @override
  State<EnterData> createState() => _EnterDataState();
}

class _EnterDataState extends State<EnterData> {
  //controller
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  //to generate random id
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  //form key for form validation
  final formkey = GlobalKey<FormState>();
  //list for dropdown button
  List<String> bloodGroupType = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];
  //here we get value of selected bloodgrop
  String? selectedBloodGroup;

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

//methors to save data
  void dbs() async {
    final user = FirebaseAuth.instance.currentUser;
    String? numb = user?.phoneNumber;
    String? uid = user?.uid;
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    await dbRefrence.child(uid!).set({
      'id': uid,
      'fname': fnameController.text.trim(),
      'lname': lnameController.text.trim(),
      'number': numb,
      'bloodgroup': selectedBloodGroup,
      // 'user': numb,
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      TostMessage().tostMessage("Record Added");
    }).onError((FirebaseException error, stackTrace) {
      TostMessage().tostMessage(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180.0,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(320.0),
                  bottomRight: Radius.circular(320.0),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  // Increase the radius to increase the size
                  radius: 60.0,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 33,
            // ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red, //New
                    blurRadius: 20.0,
                  )
                ],
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0,
              ),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    //first name
                    TextFormField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Enter First Name',
                        labelText: "First Name",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your First Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //last name
                    TextFormField(
                      controller: lnameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Enter your Last Name',
                        labelText: "Last Name",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Last Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //drop down button to select
                    DropdownButtonFormField(
                      hint: const Text('Chose Your Bloor Group'),
                      value: selectedBloodGroup,
                      onChanged: (newValue) {
                        setState(() {
                          selectedBloodGroup = newValue.toString();
                        });
                      },
                      items: bloodGroupType.map((bloodGroup) {
                        return DropdownMenuItem(
                          value: bloodGroup,
                          child: Text(bloodGroup),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //button to save data
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            dbs();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Save Data"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
