import 'package:abo_initial/Common/drawer/drawer_widget.dart';
import 'package:abo_initial/Seeker/map/map_initialization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../display_user/current_user.dart';
import '../../Donor/donormap/donor_map.dart';
import '../global/global_variable.dart';
import '../location_permission/locetion_permission.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    user != null ? CurrentUser.readRecords() : null;
    checkIfLocationPermissionAllowed();
    getVisibilityState().then((value) {
      setState(() {
        isvisible =
            value; // update the visibility state with the retrieved value
      });
    });
  }

  Future<void> saveVisibilityState(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVisible', isVisible);
  }

  Future<bool> getVisibilityState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isVisible') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      drawer: DrawerWidget(
        onPressed: () {
          setState(() {
            isvisible = !isvisible;
          });
          saveVisibilityState(isvisible);
          final user = FirebaseAuth.instance.currentUser;
          String? uid = user?.uid;
          final dbRefrence =
              FirebaseDatabase.instance.ref().child("activeDonors");
          dbRefrence.child(uid!).remove();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !isvisible,
            child: const MapInitialization(),
          ),
          Visibility(
            visible: isvisible,
            child: const DonorMap(),
          ),
        ],
      ),
    );
  }
}
