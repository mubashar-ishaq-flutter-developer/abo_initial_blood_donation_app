import 'package:abo_initial/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut().then((value) {
        //           TostMessage().tostMessage("Logout Successfully!");
        //           Navigator.pushReplacement(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => const LoginPhone(),
        //             ),
        //           );
        //         }).onError((FirebaseAuthException error, stackTrace) {
        //           TostMessage().tostMessage(error.message);
        //         });
        //       },
        //       icon: const Icon(Icons.logout_rounded))
        // ],
      ),
      drawer: const DrawerWidget(),
      body: const Text("this is home page"),
    );
  }
}
