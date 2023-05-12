import 'package:abo_initial/Seeker/infoHandler/app_info.dart';
import 'package:abo_initial/Common/splashscreencheck/splash_screen.dart';
import 'package:abo_initial/Common/theme/theme_config.dart';
import 'package:abo_initial/Common/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: GetMaterialApp(
        theme: Themes().lightTheme,
        darkTheme: Themes().darkTheme,
        themeMode: ThemeState().getThemeMode(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
