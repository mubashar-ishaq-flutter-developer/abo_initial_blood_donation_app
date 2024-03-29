import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeState {
  final getStorage = GetStorage();
  final storageKey = 'isThemeMode';

  ThemeMode getThemeMode() {
    return isSaveDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSaveDarkMode() {
    return getStorage.read(storageKey) ?? false;
  }

  void saveThemeMode(bool isDarkMode) {
    getStorage.write(storageKey, isDarkMode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(isSaveDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(
      !isSaveDarkMode(),
    );
  }
}
