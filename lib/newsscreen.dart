import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          appBar: AppBar(
            title: Text(title,
             style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 24.0, fontWeight: FontWeight.bold),
             ),
             backgroundColor: const Color.fromARGB(255, 51, 142, 217),
            ),
          body: Container(
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
         
          height: double.infinity, // Ensures container fills entire screen height
          width: double.infinity, // Ensures container fills entire screen width

          child: Column(
            children: [
              Expanded(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D3557),)
                ),
                SizedBox(height: 10),
                Text(description,
                 style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  
                ),),
                SizedBox(height: 10),
                Text('Category: $category',
                 style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),),
                Text('Region: $region',
                 style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333), 
                  ),),
                Text('Date: $date',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),),
                SizedBox(height: 20),
              ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body:Stack(
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
            return const Center(child: Text("No news feeds available"));
          }

          final newsFeeds = snapshot.data!.docs;

          return ListView.builder(
            physics: const BouncingScrollPhysics(), // Allows the list to smoothly scroll
            itemCount: newsFeeds.length,
            itemBuilder: (context, index) {
              final newsFeed = newsFeeds[index];
              final title = newsFeed['title'] ?? 'No Title';
              final description = newsFeed['description'] ?? 'No Description';
              final category = newsFeed['category'] ?? 'No Category';
              final region = newsFeed['region'] ?? 'No Region';
              final date = newsFeed['date'] ?? 'No Date';

              return GestureDetector(
                onTap: () => _openNewsFeed(
                  newsFeed.id,
                  title,
                  description,
                  category,
                  region,
                  date,
                ),
                child: Card(
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
                        Text(
                          title,
                          style: const TextStyle(
                              color: Color(0xFF1D3557), 
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 8.0),
                        // Text(
                        //   description.length > 50
                        //       ? '${description.substring(0, 50)}...'
                        //       : description,
                        //   style: const TextStyle(fontSize: 14.0, color: Colors.black),
                        // ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category: $category',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            Text(
                              'Region: $region',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Date: $date',
                          style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                                 ),
                            ],
                          ),
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
