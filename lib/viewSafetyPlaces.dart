import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addSafetyPlace.dart'; // Import the AddSafetyPlacePage class

class SafetyPlacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Safety Places'),
        backgroundColor: Colors.transparent,
        elevation: 0, // Transparent AppBar similar to the weather forecast app
      ),
      body: Stack(
        children: [
          // Gradient background for Safety Places
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
          // StreamBuilder to fetch data from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('places').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white)));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text('No safety places found.',
                        style: TextStyle(color: Colors.white)));
              }

              final safetyPlaces = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.only(
                    top: 100), // Similar padding as in weather forecast app
                itemCount: safetyPlaces.length,
                itemBuilder: (context, index) {
                  final place = safetyPlaces[index];
                  final location = place['location'];
                  final description = place['description'];
                  final mobileNo = place['mobileNo'];
                  final numberOfPeople = place['numPeople'];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location title in bold
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Additional details with icons
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Location: $location',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text('Description: $description',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.greenAccent),
                            SizedBox(width: 8),
                            Text('Mobile No: $mobileNo',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.orangeAccent),
                            SizedBox(width: 8),
                            Text('Capacity: $numberOfPeople people can stay',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSafetyPlacePage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
