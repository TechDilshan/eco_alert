import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateNewsFeed extends StatefulWidget {
  final String documentId;

  const UpdateNewsFeed({Key? key, required this.documentId}) : super(key: key);

  @override
  State<UpdateNewsFeed> createState() => _UpdateNewsFeedState();
}

class _UpdateNewsFeedState extends State<UpdateNewsFeed> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  bool _isLoading = true;

  // Fetch current news feed details from Firestore
  Future<void> _loadNewsFeedDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('news')
          .doc(widget.documentId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          _titleController.text = data['title'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _categoryController.text = data['category'] ?? '';
          _regionController.text = data['region'] ?? '';
          _dateController.text = data['date'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news feed: $e')),
      );
    }
  }

  // Update news feed in Firestore
  Future<void> _updateNewsFeed() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('news').doc(widget.documentId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _categoryController.text,
          'region': _regionController.text,
          'date': _dateController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News Feed Updated Successfully')),
        );
        Navigator.pop(context); // Close the update screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update News Feed: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNewsFeedDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 142, 217),
        title: const Text("Update News Feed",
         style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  )
                  ),
      ),
      body: Stack(
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
        _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Category
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Region
                      TextFormField(
                        controller: _regionController,
                        decoration: const InputDecoration(labelText: 'Region'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a region';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Date
                      TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(labelText: 'Date'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),

                      // Submit Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 51, 142, 217),
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), // Increase button size
                       shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0),
        ),   
    ),

                        onPressed: _updateNewsFeed,
                        child: const Text('Update News Feed',
                         style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
