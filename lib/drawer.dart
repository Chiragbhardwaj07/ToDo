import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context); // Close the drawer
      // Navigate to your login or landing page
      Navigator.pushNamed(
          context, '/auth'); // Replace with your login page route
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserData(), // Fetch user data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can show a loading indicator while data is fetched
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data;

            // Retrieve the user's name and email
            final String? userName = userData?['username'];
            final String? userEmail = userData?['email'];

            return SafeArea(
              child: Drawer(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: ListView(children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary),
                    accountName: Text(
                      userName ?? 'User Name',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      userEmail ?? 'user@example.com',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey[600]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.account_circle_rounded,
                          size: 40,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          'Profile',
                        ),
                        textColor: Theme.of(context).colorScheme.secondary,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.grid_view_rounded,
                          size: 40,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          'Categories',
                        ),
                        textColor: Theme.of(context).colorScheme.secondary,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          size: 40,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          'Settings',
                        ),
                        textColor: Theme.of(context).colorScheme.secondary,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          size: 40,
                          color: Colors.red,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          'Logout',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                        textColor: Theme.of(context).colorScheme.secondary,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          logout(context);
                        },
                      ),
                      Divider(),
                    ],
                  )
                ]),
              ),
            );
          }
        }
      },
    );
  }

  Future<DocumentSnapshot> getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        return await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
      }
      throw 'User not found';
    } catch (e) {
      print("Error fetching user data: $e");
      throw e;
    }
  }
}
