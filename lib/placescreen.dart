import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center:
                    LatLng(7.8731, 80.7718), // Centering the map on Sri Lanka
                zoom: 7.0, // Zoom level for a decent view of Sri Lanka
                minZoom: 2.0, // Minimum zoom level
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(6.9271,
                          79.8612), // Coordinates for Colombo, Sri Lanka
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                          7.2906, 80.6337), // Coordinates for Kandy, Sri Lanka
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity, // Full width of the screen
            color: Color.fromARGB(
                255, 170, 215, 231), // Background color of the container
            padding: EdgeInsets.all(20.0), // Padding around the button
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SafetyPlacesList()),
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

class SafetyPlacesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Places List'),
      ),
      body: Center(
        child: Text('This is the list of safety places.'),
      ),
    );
  }
}
