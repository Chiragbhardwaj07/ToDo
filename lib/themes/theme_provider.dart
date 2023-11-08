import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _selectedTheme = ThemeMode.light;

  ThemeMode get selectedTheme => _selectedTheme; // Define the getter here

  void toggleTheme() {
    _selectedTheme =
        _selectedTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
