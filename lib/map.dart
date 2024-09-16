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
  MapController _mapController = MapController();

  List<Marker> _markers = [];
  LatLng _defaultCenter = LatLng(7.8731, 80.7718); // Default center in Sri Lanka

  // Function to search city weather and add a marker
  Future<void> _searchCityWeather() async {
    final cityName = _cityController.text;
    if (cityName.isNotEmpty) {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = data['coord']['lat'];
        final lon = data['coord']['lon'];
        final temp = data['main']['temp'];
        final pressure = data['main']['pressure'];
        final humidity = data['main']['humidity'];
        final description = data['weather'][0]['description'];

        // Add marker for searched city
        setState(() {
          _markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(lat, lon),
              builder: (ctx) => IconButton(
                icon: Icon(Icons.location_on, color: Colors.red, size: 40),
                onPressed: () {
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
                },
              ),
            ),
          );
          _mapController.move(LatLng(lat, lon), 10.0);
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    }
  }

  // Initial predefined cities in Sri Lanka
  List<Map<String, dynamic>> _cities = [
    {'name': 'Colombo', 'lat': 6.9271, 'lon': 79.8612},
    {'name': 'Kandy', 'lat': 7.2906, 'lon': 80.6337},
    {'name': 'Galle', 'lat': 6.0324, 'lon': 80.2197},
    {'name': 'Jaffna', 'lat': 9.6615, 'lon': 80.0250},
    {'name': 'Batticaloa', 'lat': 7.7292, 'lon': 81.7139},
    {'name': 'Puttalam', 'lat': 8.0336, 'lon': 79.8385},
    {'name': 'Anuradhapura', 'lat': 8.3114, 'lon': 80.4037},
    {'name': 'Badulla', 'lat': 6.9896, 'lon': 81.0556},
    {'name': 'Ratnapura', 'lat': 6.6828, 'lon': 80.3993},
    // Add more cities as needed
  ];

  @override
  void initState() {
    super.initState();
    _addPredefinedCityMarkers();
  }

  void _addPredefinedCityMarkers() {
    // Adding predefined markers for Sri Lanka's cities
    _cities.forEach((city) {
      setState(() {
        _markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(city['lat'], city['lon']),
            builder: (ctx) => IconButton(
              icon: Icon(Icons.location_on, color: Colors.blue, size: 40),
              onPressed: () {
                _fetchWeatherForCity(city['name'], city['lat'], city['lon']);
              },
            ),
          ),
        );
      });
    });
  }

  // Function to fetch weather data for predefined cities
  Future<void> _fetchWeatherForCity(String cityName, double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temp = data['main']['temp'];
      final pressure = data['main']['pressure'];
      final humidity = data['main']['humidity'];
      final description = data['weather'][0]['description'];

      // Show weather information in a dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Climate Map'),
        backgroundColor: const Color.fromARGB(255, 37, 108, 166),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 170, 215, 231),
      body: Column(
        children: [
          Padding(
            // padding: EdgeInsets.only(top: 100),
           padding: const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 10.0),
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
              mapController: _mapController,
              options: MapOptions(
                center: _defaultCenter,
                zoom: 7.0,
                minZoom: 2.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _markers, // Combining friend's markers with dynamic ones
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
