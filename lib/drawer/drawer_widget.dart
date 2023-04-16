import 'package:abo_initial/logout/logout_button.dart';
import 'package:abo_initial/theme/them_services.dart';
import 'package:flutter/material.dart';
import '../global/global_variable.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            accountName: Text(
              "${gfname.toString()} ${glname.toString()}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              gnumber.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/user.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
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
