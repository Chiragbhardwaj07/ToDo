import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do/pages/description.dart';
import 'package:to_do/themes/theme_provider.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  List<DocumentSnapshot> docs = [];
  String uid = '';
  bool isUidAvailable = false;

  List<bool> taskDoneList = [];
  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  @override
  void initState() {
    super.initState();
    getUid();
    // Initialize with 'false' for each task

    _resetSelectedDate();
  }

  void _handleTodoChange(String taskId, bool taskDone) {
    tasksCollection
        .doc(uid)
        .collection('mytasks')
        .doc(taskId)
        .update({'completed': !taskDone});
  }

  Future<void> getUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          uid = user.uid;
          isUidAvailable = true;
        });
      }
    } catch (e) {
      print("Error getting UID: $e");
    }
  }

  late DateTime _selectedDate;

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (!isUidAvailable) {
      // Handle the case where uid is not available yet
      print('UID absent');
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'T O - D O',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: signOut,
              icon: Icon(Icons.logout),
              color: Theme.of(context).colorScheme.secondary),
          IconButton(
            icon: Icon(
              themeProvider.selectedTheme == ThemeMode.light
                  ? Icons.dark_mode // Light bulb icon when light theme
                  : Icons.light_mode,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              themeProvider.toggleTheme(); // Toggle the theme
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CalendarTimeline(
            initialDate: _selectedDate,
            firstDate: DateTime(2020, 4, 20),
            lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
            onDateSelected: (date) => setState(() => _selectedDate = date),
            leftMargin: 20,
            monthColor: Colors.grey,
            dayColor: Colors.blueGrey,
            dayNameColor: Theme.of(context).colorScheme.background,
            activeDayColor: Theme.of(context).colorScheme.background,
            activeBackgroundDayColor: Theme.of(context).colorScheme.secondary,
            dotsColor: Theme.of(context).colorScheme.background,
            // locale: 'en',
          ),
          const SizedBox(height: 20),
          Text(
            'Tasks',
            style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.secondary, fontSize: 30),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: tasksCollection.doc(uid).collection('mytasks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final docs = snapshot.data!.docs;
                if (taskDoneList.isEmpty) {
                  taskDoneList = List.generate(docs.length, (index) => false);
                }
                final selectedDateTasks = docs.where((doc) {
                  final taskDate = (doc['timestamp'] as Timestamp).toDate();
                  return taskDate.year == _selectedDate.year &&
                      taskDate.month == _selectedDate.month &&
                      taskDate.day == _selectedDate.day;
                }).toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: selectedDateTasks.length,
                    itemBuilder: (context, index) {
                      bool taskDone = docs[index]['completed'] ?? false;
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                title: docs?[index]['title'],
                                description: docs?[index]['description'],
                              ),
                            ),
                          );
                        },
                        title: Text(
                          docs?[index]['title'],
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              decoration:
                                  taskDone ? TextDecoration.lineThrough : null),
                        ),
                        subtitle: Text(
                          docs?[index]['description'],
                          style: GoogleFonts.roboto(),
                        ),
                        leading: IconButton(
                            onPressed: () {
                              _handleTodoChange(docs[index].id, taskDone);
                            },
                            icon: Icon(
                              taskDone
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                        trailing: IconButton(
                            onPressed: () {
                              tasksCollection
                                  .doc(uid)
                                  .collection('mytasks')
                                  .doc(docs?[index]['time'])
                                  .delete();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newtask');
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).colorScheme.background,
          )),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
