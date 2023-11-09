import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/pages/edit_task.dart';

class Description extends StatefulWidget {
  final String title, description;
  final String? taskId;

  const Description(
      {super.key,
      required this.title,
      required this.description,
      required this.taskId});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Description',
          style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTask(
                          title: widget.title,
                          description: widget.description,
                          taskId: widget.taskId)),
                );
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.description,
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
