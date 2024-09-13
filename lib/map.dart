import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _cityController = TextEditingController();
  final String _apiKey = '15a89774b7e893533583e1f131dec3ba';
  int _selectedIndex = 2; // To keep track of the selected tab

  Future<void> _searchCityWeather() async {
    final cityName = _cityController.text;
    if (cityName.isNotEmpty) {
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric')
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = data['coord']['lat'];
        final lon = data['coord']['lon'];
        final temp = data['main']['temp'];
        final pressure = data['main']['pressure'];
        final humidity = data['main']['humidity'];
        final description = data['weather'][0]['description'];

        // Display weather information
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(cityName),
            content: Text(
              'Temperature: $temp°C\nPressure: $pressure hPa\nHumidity: $humidity%\nWeather: $description',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load weather data');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // You can navigate to different screens based on the selected index
    // For example:
    // if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => ClimateScreen()));
    // if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccountScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter city name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchCityWeather,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                minZoom: 8.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                // MarkerLayer has been removed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
