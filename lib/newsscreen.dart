import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
    String? selectedCategory;
    List<String> categories = ['All', 'Climate Policy', 'Breaking News', 'Environmental Events', 'Scientific Report'];
  // Method to open detailed view of news feed
  void _openNewsFeed(String documentId, String title, String description, String category, String region, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title,
             style: TextStyle(color: Color(0xFF1E3A8A),
              fontSize: 26.0, 
              fontWeight: FontWeight.bold,
               fontFamily: 'Roboto',
              ),
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
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left for better readability
              children: [
                SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                     color: Color(0xFF1D3557),
                      fontFamily: 'Montserrat', 
                     )
                ),
                SizedBox(height: 10),
                Text(description,
                 style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                ),
                ),
                SizedBox(height: 15),
                 Row(
                      children: [
                        Icon(Icons.category, color: Color(0xFF1D3557)), // Yellow-orange icon for contrast
                        SizedBox(width: 10),
                        Text(
                          'Category: $category',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 10),
                Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF1D3557)), // Yellow-orange icon for contrast
                        SizedBox(width: 10),
                        Text(
                          'Region: $region',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                Row(
                      children: [
                        Icon(Icons.date_range, color: Color(0xFF1D3557)), // Yellow-orange icon for contrast
                        SizedBox(width: 10),
                        Text(
                          'Date: $date',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
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
     actions: [
          DropdownButton<String>(
            value: selectedCategory,
            hint: const Text('Category'),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
          ),
        ],
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

          // Filter news feeds based on selected category
                final newsFeeds = snapshot.data!.docs.where((newsFeed) {
                  final category = newsFeed['category'] ?? 'No Category';

                  final matchesCategory = selectedCategory == null || selectedCategory == 'All' || category == selectedCategory;

                  return matchesCategory;
                }).toList();

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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
              children: [
                SizedBox(width: 8.0),
               Expanded(
               child :Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF1D3557), 
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                      ),
                       overflow: TextOverflow.ellipsis, // Prevent overflow
                    maxLines: 2, // Limit to 2 lines
                ),
               ),
              ],
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
              children: [
                Icon(Icons.category, color: Color(0xFF1D3557)), 
                SizedBox(width: 8.0),
                Text(
                  'Category: $category',
                  style: const TextStyle(
                      fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
              ],
            ),
                        SizedBox(height: 8.0),
                                Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1D3557)), 
                Text(
                  'Region: $region',
                  style: const TextStyle(
                      fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
              ],
            ),
                        SizedBox(height: 8.0),
                         Row(
              children: [
                Icon(Icons.date_range, color: Color(0xFF1D3557)),
                SizedBox(width: 8.0),
                Text(
                  'Date: $date',
                  style: const TextStyle(
                      fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
                            
              ],
                    
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
