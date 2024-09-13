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
        print("API response: $data"); // Print the full response

        // Parse the forecast data
        List<dynamic> weatherData = [];
        for (var item in data['list']) {
          weatherData.add(item);
        }

        setState(() {
          forecastData = weatherData;
        });
      } else {
        print('Failed to fetch weather data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function to display weather cards
  Widget buildWeatherCard(dynamic weather) {
    var date = DateTime.parse(weather['dt_txt']);
    double temperature = weather['main']['temp'];
    String weatherDescription = weather['weather'][0]['description'];
    int humidity = weather['main']['humidity'];
    double windSpeed = weather['wind']['speed'];

    return Card(
      color: Colors.white.withOpacity(0.8),
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Text(
          '${date.day}-${date.month}',
          style: TextStyle(fontSize: 24, color: Colors.redAccent),
        ),
        title: Text(
          '${temperature.toStringAsFixed(1)} °C',
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weather: $weatherDescription'),
            Text('Humidity: $humidity%'),
            Text('Wind: ${windSpeed.toStringAsFixed(1)} km/h'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5 Days Weather Forecast'),
        backgroundColor: const Color.fromARGB(255, 125, 44, 176),
      ),
      body: forecastData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                // Display forecast for the next 5 days, 3-hour intervals
                return buildWeatherCard(forecastData[index]);
              },
            ),
    );
  }
}
