import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String? selectedCategory;
  List<String> categories = [
    'All', 'Climate Policy', 'Heatwave', 'Extreme Weather', 'Glacier/Ice Melt', 
    'Deforestation', 'Wildfires', 'Flooding', 'Coral Bleaching', 'Sea-Level Rise',
    'Marine Ecosystems', 'Drought', 'Other'
  ];

  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedLocation;
  String? selectedDate;

  // Method to open detailed view of news feed
  void _openNewsFeed(String documentId, String title, String description, String category, String region, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E3A8A),
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
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Icons.category, color: Color(0xFF1D3557)),
                            const SizedBox(width: 10),
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF1D3557)),
                            const SizedBox(width: 10),
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.date_range, color: Color(0xFF1D3557)),
                            const SizedBox(width: 10),
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
                        const SizedBox(height: 20),
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

 // Method to filter news based on location and date (case-insensitive)
void _searchNews() {
  setState(() {
    // Reset selectedCategory to 'All' on search
    selectedCategory = 'All'; 
    selectedLocation = locationController.text.trim().isNotEmpty ? locationController.text.trim().toLowerCase() : null;
    selectedDate = dateController.text.trim().isNotEmpty ? dateController.text.trim() : null;
  });
}

  // Method to reset search filters when a new category is selected
  void _resetFilters() {
    locationController.clear();
    dateController.clear();
    selectedLocation = null;
    selectedDate = null;
  }

  @override
void initState() {
  super.initState();
  selectedCategory = 'All';  // Default value for category
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 142, 217),
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
                _resetFilters(); // Clear previous search filters
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Search by Location',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Search by Date (YYYY-MM-DD)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            dateController.text = formattedDate;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _searchNews,
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('news').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No news feeds available"));
                    }

                   // Filter news feeds based on selected category, location (case-insensitive), and date
                    final newsFeeds = snapshot.data!.docs.where((newsFeed) {
                   final category = (newsFeed['category'] ?? 'No Category').toLowerCase(); // Convert to lowercase
  final region = (newsFeed['region'] ?? 'No Region').toLowerCase(); // Convert to lowercase
  final date = newsFeed['date'] ?? 'No Date';  // Date remains case-sensitive as it's a format

  final matchesCategory = selectedCategory == null || selectedCategory == 'All' || category == selectedCategory!.toLowerCase();
  final matchesLocation = selectedLocation == null || region.contains(selectedLocation!); // Already lowercase
  final matchesDate = selectedDate == null || date.contains(selectedDate!); // Direct comparison

  return matchesCategory && matchesLocation && matchesDate;
}).toList();


                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: newsFeeds.length,
                      itemBuilder: (context, index) {
                        final newsFeed = newsFeeds[index];
                        return Card(
                          color: Color(0xFF86A8E7), // Blue background color for the card
                          elevation: 3.0,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                           shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.black, width: 2.0), // Black outline
                ),
                          child: ListTile(
                            title: Text(newsFeed['title'] ?? 'No Title', style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),),
                         
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Row(
      children: [
    const Icon(Icons.category, color: Color(0xFF1D3557)),
    const SizedBox(width: 8.0),
    Expanded(
          child: Text(
      'Category: ${newsFeed['category'] ?? 'No Category'}',
      style: const TextStyle(
        fontSize: 15.0,
        fontStyle: FontStyle.italic,
        color: Colors.black,
          ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8.0), // Add space between category and region
    Row(
      children: [
        const Icon(Icons.location_on, color: Color(0xFF1D3557)),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            'Region: ${newsFeed['region'] ?? 'No Region'}',
            style: const TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8.0), // Add space between region and date
    Row(
      children: [
        const Icon(Icons.date_range, color: Color(0xFF1D3557)),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            'Date: ${newsFeed['date'] ?? 'No Date'}',
            style: const TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),

        
      ],
    ),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () => _openNewsFeed(
                              newsFeed.id,
                              newsFeed['title'] ?? 'No Title',
                              newsFeed['description'] ?? 'No Description',
                              newsFeed['category'] ?? 'No Category',
                              newsFeed['region'] ?? 'No Region',
                              newsFeed['date'] ?? 'No Date',
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
        ],
      ),
    );
  }
}
