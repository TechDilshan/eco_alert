// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ClimateScreen extends StatefulWidget {
//   @override
//   _ClimateScreenState createState() => _ClimateScreenState();
// }

// class _ClimateScreenState extends State<ClimateScreen> {
//   String cityName = "Colombo";
//   String apiKey = "15a89774b7e893533583e1f131dec3ba";
//   Map<String, dynamic>? weatherData; // Make weatherData nullable

//   TextEditingController cityController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather(cityName);
//   }

//   Future<void> fetchWeather(String city) async {
//     var url =
//         'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
//     var response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         weatherData = json.decode(response.body);
//       });
//     } else {
//       // Handle error
//       setState(() {
//         weatherData = null; // Handle error case
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weather App'),
//       ),
//       body: weatherData != null
//           ? SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: TextField(
//                       controller: cityController,
//                       decoration: InputDecoration(
//                         labelText: "Enter City Name",
//                         suffixIcon: IconButton(
//                           icon: Icon(Icons.search),
//                           onPressed: () {
//                             setState(() {
//                               cityName = cityController.text;
//                               fetchWeather(cityName);
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           "${weatherData!['main']['temp']}°", // Use null check operator
//                           style: TextStyle(
//                             fontSize: 64,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           weatherData!['weather'][0]['description'],
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           "${weatherData!['name']}, ${weatherData!['sys']['country']}",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             WeatherInfoCard(
//                               icon: Icons.thermostat_outlined,
//                               label: "Feels Like",
//                               value: "${weatherData!['main']['feels_like']}°",
//                             ),
//                             WeatherInfoCard(
//                               icon: Icons.water_drop_outlined,
//                               label: "Humidity",
//                               value: "${weatherData!['main']['humidity']}%",
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             WeatherInfoCard(
//                               icon: Icons.remove_red_eye_outlined,
//                               label: "Visibility",
//                               value: "${weatherData!['visibility'] / 1000}km",
//                             ),
//                             WeatherInfoCard(
//                               icon: Icons.wb_sunny_outlined,
//                               label: "UV Index",
//                               value: "1 (L)", // OpenWeather API doesn’t provide UV in the same call, so this is a placeholder.
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             WeatherInfoCard(
//                               icon: Icons.air,
//                               label: "Wind",
//                               value: "${weatherData!['wind']['speed']} km/h",
//                             ),
//                             WeatherInfoCard(
//                               icon: Icons.speed_outlined,
//                               label: "Pressure",
//                               value: "${weatherData!['main']['pressure']} mb",
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class WeatherInfoCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   WeatherInfoCard({required this.icon, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.blueAccent.withOpacity(0.7),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Icon(icon, color: Colors.white),
//             SizedBox(height: 10),
//             Text(
//               label,
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(height: 5),
//             Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
