import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherForecast extends StatefulWidget {
  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  final String apiKey = '15a89774b7e893533583e1f131dec3ba'; // Replace with your actual API key
  String city = 'Colombo';  // City name
  List<dynamic> forecastData = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherForecast();
  }

  // Function to fetch weather forecast
  Future<void> fetchWeatherForecast() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Parse the forecast data and keep only one entry per day (every 24 hours)
        List<dynamic> dailyData = [];
        Set<String> daysAdded = {};

        for (var item in data['list']) {
          String date = item['dt_txt'].split(' ')[0]; // Get only the date part
          if (!daysAdded.contains(date) && dailyData.length < 5) {
            dailyData.add(item);
            daysAdded.add(date);
          }
        }

        setState(() {
          forecastData = dailyData;
        });
      } else {
        print('Failed to fetch weather data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function to display styled weather cards with icons
  Widget buildWeatherCard(dynamic weather) {
  var date = DateTime.parse(weather['dt_txt']);
  double temperature = (weather['main']['temp'] as num).toDouble(); // Ensure double
  String weatherDescription = weather['weather'][0]['description'];
  int humidity = weather['main']['humidity'] as int; // Ensure int for humidity
  double windSpeed = (weather['wind']['speed'] as num).toDouble(); // Ensure double for wind speed

  return Container(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date in Small Box
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_getMonthName(date.month)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        // Temperature and Weather Icon Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${temperature.toStringAsFixed(1)} °C',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  weatherDescription,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            Icon(
              Icons.wb_cloudy,  // Weather icon
              size: 48,
              color: Colors.blueAccent,
            ),
          ],
        ),
        SizedBox(height: 16),

        // Weather Details Row (Humidity and Wind Speed)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('Humidity: $humidity%', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.air, color: Colors.greenAccent),
                SizedBox(width: 8),
                Text('Wind: ${windSpeed.toStringAsFixed(1)} km/h', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

// Helper function to get month name from month number
String _getMonthName(int month) {
  const monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return monthNames[month - 1];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('5 Days Weather Forecast'),
        backgroundColor: const Color.fromARGB(255, 37, 108, 166),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF91EAE4),
                  Color(0xFF86A8E7),
                  Color(0xFF7F7FD5),
                ],
              ),
            ),
          ),
          // Main Forecast List
          forecastData.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.only(top: 100),
                  itemCount: forecastData.length,
                  itemBuilder: (context, index) {
                    return buildWeatherCard(forecastData[index]);
                  },
                ),
        ],
      ),
    );
  }
}
