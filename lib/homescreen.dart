import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import your LoginScreen
import 'myaccount.dart'; // Import your MyAccountScreen
import 'map.dart'; // Import your MapScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String cityName = "Colombo";
  String apiKey = "15a89774b7e893533583e1f131dec3ba";
  Map<String, dynamic>? weatherData; // Make weatherData nullable
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeather(cityName);
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

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _selectedIndex == 0
          ? _buildClimateScreen() // Home screen content (Separate widget)
          : _selectedIndex == 1
              ? _buildClimateScreen()
              : _selectedIndex == 2
                  ? MapScreen()
                  : MyAccountScreen(), // Other screens
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 125, 44, 176),
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
            icon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
        selectedItemColor: Colors.purple, // Change the active item color
        unselectedItemColor: Colors.grey, // Unselected item color
      ),
    );
  }

  Widget _buildClimateScreen() {
    return weatherData != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: "Enter City Name",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            cityName = cityController.text;
                            fetchWeather(cityName);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "${weatherData!['main']['temp']}°", // Use null check operator
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weatherData!['weather'][0]['description'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${weatherData!['name']}, ${weatherData!['sys']['country']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherInfoCard(
                            icon: Icons.thermostat_outlined,
                            label: "Feels Like",
                            value: "${weatherData!['main']['feels_like']}°",
                          ),
                          WeatherInfoCard(
                            icon: Icons.water_drop_outlined,
                            label: "Humidity",
                            value: "${weatherData!['main']['humidity']}%",
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherInfoCard(
                            icon: Icons.remove_red_eye_outlined,
                            label: "Visibility",
                            value: "${weatherData!['visibility'] / 1000}km",
                          ),
                          WeatherInfoCard(
                            icon: Icons.wb_sunny_outlined,
                            label: "UV Index",
                            value: "1 (L)", // Placeholder for UV Index
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherInfoCard(
                            icon: Icons.air,
                            label: "Wind",
                            value: "${weatherData!['wind']['speed']} km/h",
                          ),
                          WeatherInfoCard(
                            icon: Icons.speed_outlined,
                            label: "Pressure",
                            value: "${weatherData!['main']['pressure']} mb",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
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
      color: Colors.blueAccent.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for home screen content
class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Home Screen Content"),
    );
  }
}
