import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSafetyPlacePage extends StatefulWidget {
  @override
  _AddSafetyPlacePageState createState() => _AddSafetyPlacePageState();
}

class _AddSafetyPlacePageState extends State<AddSafetyPlacePage> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _numPeopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Safety Place'),
        backgroundColor: const Color.fromARGB(255, 37, 108, 166),
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
                // App Logo (Optional)
                // Image.asset(
                //   'assets/logo.png', // Replace with your logo asset path
                //   height: 70,
                // ),
                // const SizedBox(height: 40),
                // Safety Place Container
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
                      // Page Title
                      const Text(
                        'Add Safety Place',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Safe Location Input Field
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Safe Location',
                          prefixIcon: const Icon(Icons.location_on,
                              color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLength: 100,
                      ),
                      const SizedBox(height: 20),
                      // Description Input Field
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Description',
                          prefixIcon: const Icon(Icons.description,
                              color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLength: 250,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      // Mobile Number Input Field
                      TextField(
                        controller: _mobileNoController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Mobile Number',
                          prefixIcon:
                              const Icon(Icons.phone, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      // Number of People Input Field
                      TextField(
                        controller: _numPeopleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintText: 'Number of People Who Can Stay',
                          prefixIcon:
                              const Icon(Icons.group, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitSafetyPlace,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 59, 53, 212), // Consistent button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Add',
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

  Future<void> _submitSafetyPlace() async {
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();
    final mobileNo = _mobileNoController.text.trim();
    final numPeople = _numPeopleController.text.trim();

    if (location.isEmpty ||
        description.isEmpty ||
        mobileNo.isEmpty ||
        numPeople.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      // Save safety place information to Firestore
      await FirebaseFirestore.instance.collection('places').add({
        'location': location,
        'description': description,
        'mobileNo': mobileNo,
        'numPeople': int.tryParse(numPeople) ?? 0,
      });

      // Clear the form fields
      _locationController.clear();
      _descriptionController.clear();
      _mobileNoController.clear();
      _numPeopleController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Safety Place Added Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add safety place: ${e.toString()}')),
      );
    }
  }
}
