import 'package:abo_initial/drawer/drawer_widget.dart';
import 'package:abo_initial/map/map_initialization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../display_user/current_user.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      drawer: const DrawerWidget(),
      body: const MapInitialization(),
    );
  }
}
