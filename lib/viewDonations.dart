import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewDonationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('View Donations'),
        backgroundColor: Colors.transparent,
        elevation: 0, // Transparent AppBar similar to the safety places app
      ),
      body: Stack(
        children: [
          // Gradient background for View Donations
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
            stream: FirebaseFirestore.instance
                .collection('donations')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No donations available.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final donations = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.only(
                    top: 100), // Similar padding as the safety places app
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation =
                      donations[index].data() as Map<String, dynamic>;
                  final name = donation['name'] ?? 'N/A';
                  final email = donation['email'] ?? 'N/A';
                  final amount = donation['donationAmount'] ?? 'N/A';
                  final purpose = donation['purpose'] ?? 'N/A';
                  final comments = donation['comments'] ?? 'N/A';

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
                        // Name in bold
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Donation details with icons
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Email: $email',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text('Amount: \$${amount.toString()}',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.work,
                                color: Colors
                                    .greenAccent), // Updated icon for 'purpose'
                            SizedBox(width: 8),
                            Text('Purpose: $purpose',
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.comment, color: Colors.orangeAccent),
                            SizedBox(width: 8),
                            Text('Comments: $comments',
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
    );
  }
}
