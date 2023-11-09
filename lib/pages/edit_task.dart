import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final String? title;
  final String? description;
  final String? taskId;

  EditTask({
    super.key,
    required this.title,
    required this.description,
    required this.taskId,
  });

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController titleController;
  late TextEditingController EditTaskController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    EditTaskController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: GoogleFonts.abel(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                minLines: null,
                expands: true,
                controller: EditTaskController,
                decoration: InputDecoration(
                  labelText: 'EditTask',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                onPressed: () {
                  updateTaskInFirebase();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTaskInFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        CollectionReference tasksCollection =
            FirebaseFirestore.instance.collection('tasks');

        await tasksCollection
            .doc(uid)
            .collection('mytasks')
            .doc(widget.taskId)
            .update({
          'title': titleController.text,
          'description': EditTaskController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Task Updated')),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('User is not logged in')),
        ));
      }
    } catch (e) {
      print('Error updating data in Firebase: $e');
    }
  }
}
