import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http; // Import needed for HTTP requests
import 'dart:convert'; // Import needed for JSON decoding
import 'viewSafetyPlaces.dart';

class Impactmapscreen extends StatefulWidget {
  @override
  _ImpactmapscreenState createState() => _ImpactmapscreenState();
}

class _ImpactmapscreenState extends State<Impactmapscreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = '15a89774b7e893533583e1f131dec3ba';
  final MapController _mapController = MapController(); // MapController to control the map
  Map<LatLng, Map<String, String>> placeDetails = {}; // To store place details
  LatLng _mapCenter = LatLng(7.8731, 80.7718); // Default center (Sri Lanka)
  double _mapZoom = 7.0; // Default zoom level

  @override
  void initState() {
    super.initState();
    fetchCityCoordinates();
  }

  Future<void> fetchCityCoordinates() async {
    final snapshot = await FirebaseFirestore.instance.collection('impact').get();
    final places = snapshot.docs;

    for (var place in places) {
      final lat = place['latitude'];
      final lng = place['longitude'];
      final coordinates = LatLng(lat, lng);

      setState(() {
        placeDetails[coordinates] = {
          'location': place['location'],
          'description': place['description'],
          'endDate': place['endDate'],
          'city': place['city'],
        };
      });
    }
  }

  Future<void> _searchCity() async {
    final cityName = _searchController.text;
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lat = data['coord']['lat'];
      final lon = data['coord']['lon'];
      final coordinates = LatLng(lat, lon);

      setState(() {
        _mapCenter = coordinates;
        _mapZoom = 11.0; // Adjust zoom level to focus on the searched city
      });

      // Use the MapController to update the map's center and zoom
      _mapController.move(coordinates, _mapZoom);
    } else {
      // Handle case where city is not found or API request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City not found')),
      );
    }
  }

  void _showPlaceDetails(LatLng coordinates) {
    final details = placeDetails[coordinates];
    if (details != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Place Details',
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Left align content
              children: [
                Text('Location: ${details['location']}'),
                SizedBox(height: 8.0), // Add some space between lines
                Text('Description: ${details['description']}'),
                SizedBox(height: 8.0), // Add some space between lines
                Text('Impact End Date: ${details['endDate']}'),
                SizedBox(height: 8.0), // Add some space between lines
                Text('Nearest City: ${details['city']}'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 215, 231),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchCity,
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController, // Pass the MapController to FlutterMap
              options: MapOptions(
                center: _mapCenter,
                zoom: _mapZoom,
                minZoom: 2.0, // Minimum zoom level
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: placeDetails.keys.map((coordinates) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: coordinates,
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          _showPlaceDetails(coordinates);
                        },
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
