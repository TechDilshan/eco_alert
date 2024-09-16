import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import the AddSafetyPlacePage class
import 'addSafetyPlace.dart';

class SafetyPlacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Places'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('places').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No safety places found.', style: TextStyle(color: Colors.white)));
          }

          final safetyPlaces = snapshot.data!.docs;

          return ListView.builder(
            itemCount: safetyPlaces.length,
            itemBuilder: (context, index) {
              final place = safetyPlaces[index];
              final location = place['location'];
              final description = place['description'];
              final mobileNo = place['mobileNo'];
              final numberOfPeople = place['numPeople'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.black.withOpacity(0.75),
                child: ListTile(
                  title: Text(
                    location,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: $location', style: TextStyle(color: Colors.white)),
                      Text('Description: $description', style: TextStyle(color: Colors.white)),
                      Text('Mobile No: $mobileNo', style: TextStyle(color: Colors.white)),
                      Text('Capacity: $numberOfPeople people can stay', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
