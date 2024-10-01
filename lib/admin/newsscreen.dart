import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_newsfeed.dart'; // Import for adding news feed
import 'delete_newsfeed.dart'; // Import for deleting news feed
import 'update_newsfeed.dart'; // Import for updating news feed

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Method to open detailed view of news feed
  void _openNewsFeed(String documentId, String title, String description, String category, String region, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(description),
                SizedBox(height: 10),
                Text('Category: $category'),
                SizedBox(height: 10),
                Text('Region: $region'),
                SizedBox(height: 10),
                Text('Date: $date'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteNewsFeed(documentId: documentId),
                      ),
                    );
                  },
                  child: const Text("Delete News Feed"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to Delete News Feed
  Future<void> _deleteNewsFeed(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('news').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News Feed Deleted Successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to Delete News Feed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewsFeed()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 37, 108, 166),
        child: const Icon(Icons.add),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // Move FAB to the left side
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 142, 217), // Blue theme color for the AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "News ",
              style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Alerts",
              style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 24.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
        
      
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
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
           // StreamBuilder wrapped inside a transparent Container to allow the background to show
          Container(
            color: Colors.transparent,  // Ensure transparency to see gradient
           child:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No News Feeds available"));
          }

          final newsFeeds = snapshot.data!.docs;

          return ListView.builder(
            itemCount: newsFeeds.length,
            itemBuilder: (context, index) {
              final newsFeed = newsFeeds[index];
              final title = newsFeed['title'] ?? 'No Title';
              final description = newsFeed['description'] ?? 'No Description';
              final category = newsFeed['category'] ?? 'No Category';
              final region = newsFeed['region'] ?? 'No Region';
              final date = newsFeed['date'] ?? 'No Date';

              return Card(
              color: Color(0xFF86A8E7), // Blue background color for the card
                margin: const EdgeInsets.all(10.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.black, width: 2.0), // Black outline
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 8.0),
                      Row(
                              children: [
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    description,
                                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 8.0),
                        Row(
                              children: [
                                const Icon(Icons.category, color: Color(0xFF1D3557)), 
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Category: $category',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    SizedBox(height: 8.0),
                    Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF1D3557)),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Region: $region',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    SizedBox(height: 8.0),
                      Row(
                              children: [
                                const Icon(Icons.date_range, color: Color(0xFF1D3557)),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Date: $date',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Update Button
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateNewsFeed(documentId: newsFeed.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.black), // Icon color
                            label: const SizedBox.shrink(), 
                                 
                        
                          ),
                          const SizedBox(width: 8.0),
                          // Delete Button (Trash icon)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () => _deleteNewsFeed(newsFeed.id),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
