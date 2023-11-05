// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color(0xFFDB3022),
    secondary: Colors.black,
  ),
);

// how to write: Theme.of(context).colorScheme.background
// Color(0xff9B9B9B)