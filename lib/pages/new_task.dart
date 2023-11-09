import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class New_Task extends StatefulWidget {
  const New_Task({super.key});

  @override
  State<New_Task> createState() => _New_TaskState();
}

void removeKeyboardFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

class _New_TaskState extends State<New_Task> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> addTaskToFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        var time = DateTime.now();
        var hr = DateFormat.jms();

        CollectionReference tasksCollection =
            FirebaseFirestore.instance.collection('tasks');

        await tasksCollection
            .doc(uid)
            .collection('mytasks')
            .doc(time.toString())
            .set({
          'title': titleController.text,
          'description': descriptionController.text,
          "completed": false,
          'time': time.toString(),
          "timestamp": Timestamp.fromDate(DateTime.now()),
        });
        titleController.clear();
        descriptionController.clear();
        removeKeyboardFocus(context);
        Navigator.pop(context);

        // print('Data Added');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Task Added')),
        ));
      } else {
        // print('User is not logged in');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('User is not logged in')),
        ));
      }
    } catch (e) {
      print('Error adding data to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: Text(
          'N E W  T A S K',
          style:
              GoogleFonts.abel(color: Theme.of(context).colorScheme.secondary),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 120,
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              SizedBox(height: 30),
              Container(
                  width: double.infinity,
                  height: 50,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.purple.shade500;
                        return Theme.of(context).colorScheme.secondary;
                      }),
                    ),
                    child: Text(
                      'Add Task',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      addTaskToFirebase();
                    },
                  ))
            ],
          )),
    );
  }
}
