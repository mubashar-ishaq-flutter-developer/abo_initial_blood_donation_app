import 'package:abo_initial/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../tostmessage/tost_message.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.logout_rounded,
        size: 25,
      ),
      title: const Text(
        "Logout",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: () {
        FirebaseAuth.instance.signOut().then((value) {
          TostMessage().tostMessage("Logout Successfully!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }).onError((FirebaseAuthException error, stackTrace) {
          TostMessage().tostMessage(error.message);
        });
      },
    );
  }
}
