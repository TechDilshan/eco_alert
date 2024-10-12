import 'package:flutter/material.dart';
import 'adminAddImpactScreen.dart'; // Import the new screens
import 'adminAddSafetyPlace.dart';
import 'adminViewDonations.dart';
import 'adminLogin.dart'; // Import the LoginScreen
import 'newsscreen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        backgroundColor: const Color.fromARGB(255, 73, 95, 222),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 145, 234, 228),
              Color.fromARGB(255, 127, 127, 213),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // First box - Add Impact Details
                        _buildBox(
                          context,
                          'Add Impact Details',
                          Icons.add_chart,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminAddImpactScreen()),
                          ),
                        ),
                        // Second box - Add Safety Places
                        _buildBox(
                          context,
                          'Add Safety Places',
                          Icons.location_on,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminAddSafetyPlacePage()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Third box - Add Climate News
                        _buildBox(
                          context,
                          'Add Climate News',
                          Icons.article,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsScreen()),
                          ),
                        ),
                        // Fourth box - Display Donors Details
                        _buildBox(
                          context,
                          'Display Donors Details',
                          Icons.people,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminViewDonationsPage()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 51, 182).withOpacity(0.7), // Adjust color to match theme
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 202, 222, 240),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each box button
  Widget _buildBox(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 51, 182).withOpacity(0.4), // Adjust color to match theme
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 3, 22, 72), width: 4), // Adjust border color to match theme
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: const Color.fromARGB(255, 141, 191, 233)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 202, 222, 240),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
