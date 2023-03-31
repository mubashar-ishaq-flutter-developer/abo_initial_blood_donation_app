import 'package:abo_initial/splashscreencheck/splash_screen.dart';
import 'package:abo_initial/theme/theme_config.dart';
import 'package:abo_initial/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeState().getThemeMode(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
