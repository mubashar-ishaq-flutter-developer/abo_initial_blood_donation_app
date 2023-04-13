import 'package:abo_initial/homepage/home_page.dart';
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
  void dbs() {
    final user = FirebaseAuth.instance.currentUser;
    String? numb = user?.phoneNumber;
    String? uid = user?.uid;
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    dbRefrence.child(uid!).set({
      'id': uid,
      'fname': fnameController.text.trim(),
      'lname': lnameController.text.trim(),
      'number': numb,
      'bloodgroup': selectedBloodGroup,
      // 'user': numb,
    }).then((value) {
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
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
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
                        // prefixIcon: const Icon(Icons.person),
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
                        // prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Last Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //drop down button to select
              DropdownButton(
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
              ),
              const SizedBox(
                height: 15,
              ),
              //button to save data
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      dbs();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
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
    );
  }
}
