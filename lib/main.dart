import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth/authscreen.dart';
import 'package:to_do/firebase_options.dart';
import 'package:to_do/homepage.dart';
import 'package:to_do/pages/landing_page.dart';
import 'package:to_do/pages/new_task.dart';
import 'package:to_do/themes/dark_theme.dart';
import 'package:to_do/themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(MaterialApp(
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, Snapshot) {
        if (Snapshot.hasData) {
          return Home_page();
        } else {
          return Landing_Page();
        }
      },
    ),
    theme: lightTheme,
    darkTheme: darkTheme,
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => Home_page(),
      '/auth': (context) => AuthScreen(),
      '/newtask': (context) => New_Task(),
    },
  ));
}
