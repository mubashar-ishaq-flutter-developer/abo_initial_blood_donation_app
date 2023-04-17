import 'package:abo_initial/update/update_page.dart';
import 'package:flutter/material.dart';

class UpdateButton extends StatefulWidget {
  const UpdateButton({super.key});

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.edit,
        size: 25,
      ),
      title: const Text(
        "Update",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdatePage(),
          ),
        );
      },
    );
  }
}
