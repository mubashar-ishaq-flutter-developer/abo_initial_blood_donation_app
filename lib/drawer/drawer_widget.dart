import 'package:abo_initial/logout/logout_button.dart';
import 'package:abo_initial/theme/them_services.dart';
import 'package:flutter/material.dart';

import '../display_user/displsy_user.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Row(
              children: const [
                DisplayUser(),
              ],
            ),
          ),
          // const DisplayUser(),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 25,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomePage(),
              //   ),
              // );
              Navigator.pop(context);
            },
          ),
          const LogoutButton(),
          const ThemeServices(),
        ],
      ),
    );
  }
}
