import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDonationPage extends StatefulWidget {
  const RequestDonationPage({super.key});

  @override
  _RequestDonationPageState createState() => _RequestDonationPageState();
}

class _RequestDonationPageState extends State<RequestDonationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _donationAmountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Donation'),
        backgroundColor: Colors.purple, // Set the AppBar background color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF91EAE4),
              Color(0xFF86A8E7),
              Color(0xFF7F7FD5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'assets/logo.png', // Replace with your logo asset path
                  height: 70,
                ),
                const SizedBox(height: 40),
                // Donation Container
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Donation Topic
                      const Text(
                        'Donation Form',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Name Input Field
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Name',
                          prefixIcon: const Icon(Icons.person, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // Email Input Field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      // Donation Amount Input Field
                      TextField(
                        controller: _donationAmountController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Requesting Amount',
                          prefixIcon: const Icon(Icons.money, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      // Purpose Input Field
                      TextField(
                        controller: _purposeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Reason for Requesting',
                          prefixIcon: const Icon(Icons.volunteer_activism, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // Additional Comments Input Field
                      TextField(
                        controller: _commentsController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Additional Comments (Optional)',
                          prefixIcon: const Icon(Icons.comment, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      // Submit Donation Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitDonation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 125, 44, 176),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Apply Donation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitDonation() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final donationAmount = _donationAmountController.text.trim();
    final purpose = _purposeController.text.trim();
    final comments = _commentsController.text.trim();

    if (name.isEmpty || email.isEmpty || donationAmount.isEmpty || purpose.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // Save donation information to Firestore
      await FirebaseFirestore.instance.collection('donations').add({
        'name': name,
        'email': email,
        'donationAmount': donationAmount,
        'purpose': purpose,
        'comments': comments,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the form fields
      _nameController.clear();
      _emailController.clear();
      _donationAmountController.clear();
      _purposeController.clear();
      _commentsController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation Submitted Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit donation: ${e.toString()}')),
      );
    }
  }
}
