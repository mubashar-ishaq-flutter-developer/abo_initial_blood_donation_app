import 'package:abo_initial/theme/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeServices extends StatefulWidget {
  const ThemeServices({super.key});

  @override
  State<ThemeServices> createState() => _ThemeServicesState();
}

bool iconBool = false;
IconData iconLight = Icons.wb_sunny_rounded;
IconData iconDark = Icons.nights_stay_rounded;
// ThemeData lightTheme = ThemeData(
//   primaryColor: Colors.red,
//   brightness: Brightness.light,
// );
// ThemeData darkTheme = ThemeData(
//   primaryColor: Colors.red,
//   brightness: Brightness.dark,
// );

class _ThemeServicesState extends State<ThemeServices> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.brightness_6_rounded,
        size: 25,
      ),
      title: const Text(
        "Theme",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: () {
        // Get.changeThemeMode(
        //   Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        // );
        ThemeState().changeThemeMode();
      },
    );
  }
}
