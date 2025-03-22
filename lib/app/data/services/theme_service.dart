import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Get the current theme based on the stored value (defaults to light)
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  // Load theme from storage
  bool _loadTheme() => _box.read(_key) ?? false;

  // Save the theme selection
  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Change the theme dynamically
  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  // Change theme mode (light/dark)
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}
