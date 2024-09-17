import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewsFeed extends StatefulWidget {
  const AddNewsFeed({super.key});

  @override
  State<AddNewsFeed> createState() => _AddNewsFeedState();
}

class _AddNewsFeedState extends State<AddNewsFeed> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _regionController = TextEditingController();
  final _dateController = TextEditingController();

  Future<void> _uploadNewsFeed() async {
    try {
      // Save news feed details in Firestore
      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'region': _regionController.text,
        'date': _dateController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News Feed Added Successfully')),
      );

      // Clear fields after successful upload
      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _regionController.clear();
      _dateController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Add News Feed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 142, 217),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add News ",
              style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Feed",
              style: TextStyle(
                 color: Color(0xFF1E3A8A),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body:  Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF91EAE4),
                  Color(0xFF86A8E7),
                  Color(0xFF7F7FD5),
                ],
              ),
            ),
          ),
          // Main content
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter News Title",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _titleController,
                  decoration:
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 15.0),
              Text("Enter News Description",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 15.0),
              Text("Enter News Category",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _categoryController,
                  decoration:
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 15.0),
              Text("Enter Region",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _regionController,
                  decoration:
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 15.0),
              Text("Enter Date",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _dateController,
                  decoration:
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 51, 142, 217),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), // Increase button size
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),   
    ),
                  onPressed: _uploadNewsFeed,
                  child: Text(
                    "Add News Feed",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Colors.black),
              ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
