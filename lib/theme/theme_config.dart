import 'package:flutter/material.dart';

class Themes {
  ThemeData lightTheme = ThemeData(
    primaryColor: Colors.red,
    appBarTheme: const AppBarTheme(
      color: Colors.red,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.red,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.red,
    ),
    brightness: Brightness.light,
  );
  ThemeData darkTheme = ThemeData(
    primaryColor: Colors.red,
    appBarTheme: const AppBarTheme(
      color: Colors.red,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.red,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.red,
    ),
    brightness: Brightness.dark,
  );
}

// class Themes {
//   ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: Colors.red,
//     colorScheme: ColorScheme.fromSwatch()
//         .copyWith(secondary: Colors.orange)
//         .copyWith(background: Colors.white),
//   );

//   ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: Colors.teal,
//     colorScheme: ColorScheme.fromSwatch()
//         .copyWith(secondary: Colors.pink)
//         .copyWith(background: Colors.black),
//   );
// }
