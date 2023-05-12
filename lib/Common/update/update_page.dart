import 'package:abo_initial/Common/global/global_variable.dart';
import 'package:abo_initial/Common/homepage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../drawer/drawer_widget.dart';
import '../tostmessage/tost_message.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  //controller
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    fnameController.text = gfname.toString();
    lnameController.text = glname.toString();
    selectedBloodGroup = gbloodgroup.toString();
  }

//methors to update data
  void updateRecord() async {
    final user = FirebaseAuth.instance.currentUser;
    String? numb = user?.phoneNumber;
    //uid contain current user id
    String? uid = user?.uid;
    final dbRefrence = FirebaseDatabase.instance.ref().child("Data");
    await dbRefrence.child(uid!).update({
      'id': uid,
      'fname': fnameController.text.trim(),
      'lname': lnameController.text.trim(),
      'number': numb,
      'bloodgroup': selectedBloodGroup,
      // if update is successfull then it push hime to homePage
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      //displaying tost message that update is successfull
      TostMessage().tostMessage("Record Uodated Successfully!");
      // if some error arrive then
    }).onError((FirebaseException error, stackTrace) {
      TostMessage().tostMessage(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Page'),
        centerTitle: true,
      ),
      drawer: DrawerWidget(
        onPressed: () {},
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
                  ],
                ),
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
                      updateRecord();
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
                  child: const Text("Update Data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
