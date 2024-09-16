import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewSafetyPlaces.dart';

class PlaceScreen extends StatefulWidget {
  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final String apiKey = 'YOUR_NOMINATIM_API_KEY'; // Not required for Nominatim API
  Map<String, LatLng> cityCoordinates = {};
  Map<LatLng, Map<String, String>> placeDetails = {}; // To store place details

  @override
  void initState() {
    super.initState();
    fetchCityCoordinates();
  }

  Future<void> fetchCityCoordinates() async {
    final snapshot = await FirebaseFirestore.instance.collection('places').get();
    final places = snapshot.docs;

    for (var place in places) {
      final cityName = place['location'];
      if (!cityCoordinates.containsKey(cityName)) {
        final coordinates = await getCoordinates(cityName);
        if (coordinates != null) {
          setState(() {
            cityCoordinates[cityName] = coordinates;
            placeDetails[coordinates] = {
              'location': place['location'],
              'description': place['description'],
              'mobileNo': place['mobileNo'],
              'capacity': place['numPeople'].toString(),
            };
          });
        }
      }
    }
  }

  Future<LatLng?> getCoordinates(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$cityName&format=json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final location = data[0];
        final lat = double.parse(location['lat']);
        final lng = double.parse(location['lon']);
        return LatLng(lat, lng);
      }
    } else {
      print('Failed to fetch coordinates: ${response.reasonPhrase}');
    }
    return null;
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
              Text('Mobile: ${details['mobileNo']}'),
              SizedBox(height: 8.0), // Add some space between lines
              Text('Capacity: ${details['capacity']} people can stay'),
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
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(7.8731, 80.7718), // Centering the map on Sri Lanka
                zoom: 7.0, // Zoom level for a decent view of Sri Lanka
                minZoom: 2.0, // Minimum zoom level
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: cityCoordinates.entries.map((entry) {
                    final cityName = entry.key;
                    final coordinates = entry.value;

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
          Container(
            width: double.infinity, // Full width of the screen
            color: Color.fromARGB(255, 170, 215, 231), // Background color of the container
            padding: EdgeInsets.all(20.0), // Padding around the button
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SafetyPlacesPage()),
                    );
                  },
                  child: Text('Go to Safety Places List'),
                ),
                SizedBox(height: 20.0), // Gap between the button and the footer
              ],
            ),
          ),
        ],
      ),
    );
  }
}
