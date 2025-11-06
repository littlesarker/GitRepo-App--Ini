import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Add to theme_controller.dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs();
  }

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(themeMode);
    saveThemeToPrefs();
  }

  void setTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(themeMode);
    saveThemeToPrefs();
  }

  // Load theme from shared preferences
  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(themeMode);
  }

  // Save theme to shared preferences
  Future<void> saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }
}