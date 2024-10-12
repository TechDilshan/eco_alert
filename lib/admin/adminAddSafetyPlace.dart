import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddSafetyPlacePage extends StatefulWidget {
  @override
  _AddSafetyPlacePageState createState() => _AddSafetyPlacePageState();
}

class _AddSafetyPlacePageState extends State<AdminAddSafetyPlacePage> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _numPeopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Safety Place'),
        backgroundColor: const Color.fromARGB(255, 73, 95, 222),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Safe Location Input Field
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Safe Location',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              
              // Description Input Field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLength: 250,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Mobile Number Input Field
              TextField(
                controller: _mobileNoController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // Number of People Input Field
              TextField(
                controller: _numPeopleController,
                decoration: InputDecoration(
                  labelText: 'Number of People Who Can Stay',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitSafetyPlace,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 3, 163),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
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

    if (location.isEmpty || description.isEmpty || mobileNo.isEmpty || numPeople.isEmpty) {
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
