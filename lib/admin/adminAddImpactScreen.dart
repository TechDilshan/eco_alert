import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddImpactScreen extends StatefulWidget {
  @override
  _AddImpactPlacePageState createState() => _AddImpactPlacePageState();
}

class _AddImpactPlacePageState extends State<AdminAddImpactScreen> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _numPeopleController = TextEditingController();

  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Impact Place'),
        backgroundColor: const Color.fromARGB(255, 73, 95, 222),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Input Field with Map Navigation
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Impact Location',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: _selectLocationOnMap,
                  ),
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
                  labelText: 'Impact End Date',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              
              // Number of People Input Field
              TextField(
                controller: _numPeopleController,
                decoration: InputDecoration(
                  labelText: 'Nearest city Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitImpactPlace,
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

  void _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationScreen(
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
              _locationController.text = 'Lat: ${location.latitude}, Lng: ${location.longitude}';
            });
          },
        ),
      ),
    );
  }

  Future<void> _submitImpactPlace() async {
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();
    final mobileNo = _mobileNoController.text.trim();
    final numPeople = _numPeopleController.text.trim();

    if (location.isEmpty || description.isEmpty || mobileNo.isEmpty || numPeople.isEmpty || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      // Save impact place information to Firestore
      await FirebaseFirestore.instance.collection('impact').add({
        'location': location,
        'description': description,
        'endDate': mobileNo,
        'city': numPeople,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });

      // Clear the form fields
      _locationController.clear();
      _descriptionController.clear();
      _mobileNoController.clear();
      _numPeopleController.clear();
      setState(() {
        _selectedLocation = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impact Place Added Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add impact place: ${e.toString()}')),
      );
    }
  }
}

class SelectLocationScreen extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const SelectLocationScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final LatLng _initialLocation = LatLng(7.8731, 80.7718); // Center of Sri Lanka
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = _initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: const Color.fromARGB(255, 73, 95, 222),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: _initialLocation,
              zoom: 8, // Zoom level focused on Sri Lanka
              onPositionChanged: (position, hasGesture) {
                // Update the current location based on the map center
                if (hasGesture) {
                  setState(() {
                    _currentLocation = position.center!;
                  });
                }
              },
            ),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    builder: (context) => Icon(
                      Icons.location_on,
                      color: Colors.blue, // Blue marker for center
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                widget.onLocationSelected(_currentLocation);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 19, 11, 165),
              ),
              child: Text('Choose Location'),
            ),
          ),
        ],
      ),
    );
  }
}
