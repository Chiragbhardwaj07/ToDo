// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.deepPurple,
      secondary: Colors.white,
    ));
