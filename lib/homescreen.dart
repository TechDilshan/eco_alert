import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myaccount.dart'; // Import your MyAccountScreen
import 'map.dart'; // Import your MapScreen
import 'placescreen.dart';
import 'impactMapScreen.dart';
import 'newsscreen.dart';
import 'donationscreen.dart';
import 'weatherforecast.dart'; // Import your WeatherForecastScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String cityName = "Colombo"; // Default city
  String apiKey = "15a89774b7e893533583e1f131dec3ba";
  Map<String, dynamic>? weatherData; // Make weatherData nullable
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['location'] != null) {
        setState(() {
          cityName = userDoc.data()!['location'];
        });
        fetchWeather(cityName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User location not available.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user location: $e')),
      );
    }
  }

  Future<void> fetchWeather(String city) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      // Handle error
      setState(() {
        weatherData = null; // Handle error case
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildClimateScreen(), // Display the climate screen for the home tab
      Impactmapscreen(), // Display the MapScreen for the places tab
      PlaceScreen(),
      NewsScreen(), // Display NewsScreen for the account tab
      DonationScreen(),
    ];

    String appBarTitle = '';
    switch (_selectedIndex) {
      case 0:
        appBarTitle = 'Home';
        break;
      case 1:
        appBarTitle = 'Impact map';
        break;
      case 2:
        appBarTitle = 'Places';
        break;
      case 3:
        appBarTitle = 'News';
        break;
      case 4:
        appBarTitle = 'Donation';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: const Color.fromARGB(255, 37, 108, 166),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAccountScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined),
            label: 'Climate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Donation',
          ),
        ],
        selectedItemColor: Colors.purple, // Change the active item color
        unselectedItemColor: Colors.grey, // Unselected item color
      ),
    );
  }

  Widget _buildClimateScreen() {
  return Container(
    constraints: BoxConstraints.expand(), // Make the container expand to cover the full screen
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 145, 234, 228),
          Color.fromARGB(255, 127, 127, 213),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: weatherData != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "${weatherData!['main']['temp']}°",
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        weatherData!['weather'][0]['description'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${weatherData!['name']}, ${weatherData!['sys']['country']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.thermostat_outlined,
                              label: "Feels Like",
                              value: "${weatherData!['main']['feels_like']}°",
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.water_drop_outlined,
                              label: "Humidity",
                              value: "${weatherData!['main']['humidity']}%",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.remove_red_eye_outlined,
                              label: "Visibility",
                              value: "${weatherData!['visibility'] / 1000}km",
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.wb_sunny_outlined,
                              label: "UV Index",
                              value: "1 (L)", // Placeholder for UV Index
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.air,
                              label: "Wind",
                              value: "${weatherData!['wind']['speed']} km/h",
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoCard(
                              icon: Icons.speed_outlined,
                              label: "Pressure",
                              value: "${weatherData!['main']['pressure']} mb",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Inline Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeatherForecast(),
                                ),
                              );
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text(
                              'Forecast',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 198, 193, 193),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 41, 12, 136), // Background color
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.map),
                            label: Text(
                              'View Map',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 198, 193, 193),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 41, 12, 136), // Background color
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator()),
  );
}




}

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  WeatherInfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 72, 177).withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
