import 'package:abo_initial/Common/homepage/home_page.dart';
import 'package:abo_initial/Common/logout/logout_button.dart';
import 'package:abo_initial/Common/theme/them_services.dart';
import 'package:flutter/material.dart';
import '../global/global_variable.dart';
import '../update/update_button.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onPressed; //this VoidCallBack
  const DrawerWidget({required this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Displaying user name and its mobile number
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
          // clicking home button will push hime to home button
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          //calling update button file
          const UpdateButton(),
          //calling to change theme
          const ThemeServices(),
          // calling logoutbutton file
          const LogoutButton(),
          // i am using a button to shift between Donor & Seeker
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.red,
                ),
                child: isvisible == false
                    ? const Text("Switch To Seeker")
                    : const Text("Switch To Donor"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
