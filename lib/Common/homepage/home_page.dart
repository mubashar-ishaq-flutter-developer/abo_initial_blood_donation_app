import 'package:abo_initial/Common/drawer/drawer_widget.dart';
import 'package:abo_initial/Common/tostmessage/tost_message.dart';
import 'package:abo_initial/Donor/donormap/donor_status.dart';
import 'package:abo_initial/map/map_initialization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    getVisibilityStates().then((value) {
      setState(() {
        isvisibles =
            value; // update the visibility state with the retrieved value
      });
    });
  }

  Future<void> saveVisibilityState(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVisible', isVisible);
  }

  Future<void> saveVisibilityStates(bool isVisibles) async {
    final prefss = await SharedPreferences.getInstance();
    await prefss.setBool('isVisibles', isVisibles);
  }

  Future<bool> getVisibilityState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isVisible') ?? true;
  }

  Future<bool> getVisibilityStates() async {
    final prefss = await SharedPreferences.getInstance();
    return prefss.getBool('isVisibles') ?? false;
  }

  final DonorStatus donorStatus = DonorStatus();
  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: const Text("Home Page"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isvisible = !isvisible;
                    isvisibles = !isvisibles;
                  });
                  saveVisibilityState(isvisible);
                  saveVisibilityStates(isvisibles);
                },
                icon: const Icon(Icons.hide_source))
          ]),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          Visibility(
            visible: isvisible,
            child: const MapInitialization(),
          ),
          Visibility(
            visible: isvisibles,
            child: const DonorMap(),
          ),
          //ui for online offline driver
          statusText != "Now Online"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black87,
                )
              : Container(),

          //button for online offline driver
          Positioned(
            top: statusText != "Now Online" ? 0 : 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      //if driver is offline and make it online
                      if (isDonorActive != true) {
                        DonorStatus.donorIsOnlineNow();
                        donorStatus.updateDonorLocationAtRealTime();
                        setState(() {
                          statusText = "Now Online";
                          isDonorActive = true;
                        });
                        TostMessage().tostMessage("You are Online Now");
                      } //if donor is offline Now
                      else {
                        donorStatus.driverIsOfflineNow();
                        setState(() {
                          statusText = "Now Offline";
                          isDonorActive = false;
                        });
                        TostMessage().tostMessage("You are Offline Now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: statusText != "Now Online"
                        ? Text(
                            statusText,
                          )
                        : const Icon(Icons.phonelink_ring_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
