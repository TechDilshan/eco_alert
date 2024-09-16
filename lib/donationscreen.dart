import 'package:flutter/material.dart';
import 'applyDonation.dart';
import 'requestDonation.dart';
import 'viewDonations.dart';

class DonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Donation Screen',
              style: TextStyle(
                color: Colors.white, // Set the text color to white
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40), // Space between the title and buttons
            // Request Donation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the RequestDonationPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestDonationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Request Donation',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Text style
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Apply Donation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApplyDonationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Donate',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Text style
                ),
              ),
            ),
            const SizedBox(height: 20),
            // View Donations Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDonationsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'View Requested Donations',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Text style
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
