import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteNewsFeed extends StatelessWidget {
  final String documentId;

  const DeleteNewsFeed({Key? key, required this.documentId}) : super(key: key);

  // Method to delete the news feed from Firestore
  Future<void> _deleteNewsFeed(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('news').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News feed deleted successfully')),
      );
      Navigator.pop(context); // Close the delete confirmation screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete news feed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete News Feed"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Are you sure you want to delete this news feed?",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the confirmation dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text("Cancel"),
                ),
                // Confirm Delete Button
                ElevatedButton(
                  onPressed: () {
                    _deleteNewsFeed(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
