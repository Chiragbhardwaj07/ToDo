import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home_page extends StatelessWidget {
  const Home_page({super.key});
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T O - D O'),
        centerTitle: true,
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text('Home')),
    );
  }
}
