import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/auth/authscreen.dart';
import 'package:to_do/firebase_options.dart';
import 'package:to_do/homepage.dart';
import 'package:to_do/pages/landing_page.dart';
import 'package:to_do/pages/new_task.dart';

import 'package:to_do/themes/dark_theme.dart';
import 'package:to_do/themes/light_theme.dart';
import 'package:to_do/themes/theme_provider.dart'; // Import the theme provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home_page();
          } else {
            return Landing_Page();
          }
        },
      ),
      theme: themeProvider.selectedTheme == ThemeMode.light
          ? lightTheme
          : darkTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home_page(),
        '/auth': (context) => AuthScreen(),
        '/newtask': (context) => New_Task(),
      },
    );
  }
}
