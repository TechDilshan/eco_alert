import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminViewDonationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Donations'),
        backgroundColor: const Color.fromARGB(255, 73, 95, 222),
      ),
      backgroundColor: const Color(0xFFF5F5F5), // Adding background color
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donate').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No donations available.'));
          }

          final donations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index].data() as Map<String, dynamic>;
              final name = donation['name'] ?? 'N/A';
              final email = donation['email'] ?? 'N/A';
              final amount = donation['donationAmount'] ?? 'N/A';
              final comments = donation['comments'] ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increased font size for name
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: $name',
                        style: const TextStyle(fontSize: 16), // Increased font size for details
                      ),
                      Text(
                        'Email: $email',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Amount: \$${amount.toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Comments: $comments',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
