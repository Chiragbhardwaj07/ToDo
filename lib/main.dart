import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth/authscreen.dart';
import 'package:to_do/firebase_options.dart';
import 'package:to_do/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(MaterialApp(
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          return Home_page();
        } else {
          return AuthScreen();
        }
      },
    ),
    // initialRoute: '/home',
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => AuthScreen(),
    },
  ));
}
