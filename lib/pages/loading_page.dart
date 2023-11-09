import 'package:flutter/material.dart';

class Loading_Page extends StatelessWidget {
  const Loading_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
