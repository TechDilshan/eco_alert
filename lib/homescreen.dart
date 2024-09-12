import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login.dart'; // Import your LoginScreen
import 'myaccount.dart'; // Import your MyAccountScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: WebView(
        initialUrl: Uri.dataFromString(
          '''
          <!DOCTYPE html>
          <html>
          <head>
              <title>Weather Map for Cities</title>
              <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
              <style>
                  #map {
                      height: 700px;
                      width: 100%;
                  }
                  .popup-content {
                      font-size: 14px;
                      font-family: Arial, sans-serif;
                  }
                  #search-form {
                      margin: 20px;
                      text-align: center;
                  }
                  #city-input {
                      width: 200px;
                      padding: 10px;
                      font-size: 16px;
                  }
                  #search-button {
                      padding: 10px 20px;
                      font-size: 16px;
                  }
              </style>
          </head>
          <body>
              <div id="search-form">
                  <input type="text" id="city-input" placeholder="Enter city name">
                  <button id="search-button">Search</button>
              </div>
              <div id="map"></div>
              <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
              <script>
                  // Initialize the map centered on Sri Lanka
                  const map = L.map('map').setView([7.8731, 80.7718], 8);

                  // Add OpenStreetMap tile layer
                  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  }).addTo(map);

                  // OpenWeatherMap API key
                  const apiKey = '15a89774b7e893533583e1f131dec3ba';

                  // List of major Sri Lankan cities with their coordinates
                  const cities = [
                      { name: 'Colombo', lat: 6.9271, lon: 79.8612 },
                      { name: 'Kandy', lat: 7.2906, lon: 80.6337 },
                      { name: 'Galle', lat: 6.0324, lon: 80.2197 },
                      { name: 'Jaffna', lat: 9.6615, lon: 80.0250 },
                      { name: 'Anuradhapura', lat: 8.3114, lon: 80.4037 },
                      { name: 'Batticaloa', lat: 7.7024, lon: 81.6944 },
                      { name: 'Matara', lat: 5.9559, lon: 80.5306 },
                      { name: 'Trincomalee', lat: 8.5654, lon: 81.2339 },
                      { name: 'Negombo', lat: 7.2084, lon: 79.9811 },
                      { name: 'Kurunegala', lat: 7.4826, lon: 80.3503 },
                      { name: 'Ratnapura', lat: 6.6896, lon: 80.3968 },
                      { name: 'Kalutara', lat: 6.5705, lon: 79.9584 },
                      { name: 'Gampaha', lat: 7.0609, lon: 80.2322 },
                      { name: 'Vavuniya', lat: 8.7592, lon: 80.5070 },
                      { name: 'Mannar', lat: 8.9781, lon: 79.9861 },
                      { name: 'Hambantota', lat: 6.1244, lon: 81.1260 },
                      { name: 'Polonnaruwa', lat: 7.9404, lon: 81.0155 },
                      { name: 'Ampara', lat: 7.3072, lon: 81.6817 },
                      { name: 'Dambulla', lat: 7.8553, lon: 80.6488 },
                      { name: 'Maharagama', lat: 6.8681, lon: 79.9860 },
                      { name: 'Nuwara Eliya', lat: 6.9675, lon: 80.7653 },
                      { name: 'Kegalle', lat: 7.2426, lon: 80.3317 },
                      { name: 'Balapitiya', lat: 6.2540, lon: 80.2070 }
                  ];

                  // Function to fetch weather data and add markers
                  function addWeatherMarkers(cities) {
                      cities.forEach(city => {
                          fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${city.lat}&lon=${city.lon}&appid=${apiKey}&units=metric`)
                          .then(response => response.json())
                          .then(data => {
                              const temp = data.main.temp;
                              const pressure = data.main.pressure;
                              const humidity = data.main.humidity;
                              const description = data.weather[0].description;
                              const popupContent = `
                                  <div class="popup-content">
                                      <h3>${city.name}</h3>
                                      <p>Temperature: ${temp}°C</p>
                                      <p>Pressure: ${pressure} hPa</p>
                                      <p>Humidity: ${humidity}%</p>
                                      <p>Weather: ${description}</p>
                                  </div>
                              `;
                              L.marker([city.lat, city.lon])
                                  .addTo(map)
                                  .bindPopup(popupContent);
                          })
                          .catch(error => console.error('Error fetching weather data:', error));
                      });
                  }

                  // Add initial weather markers for predefined cities
                  addWeatherMarkers(cities);

                  // Function to add weather for a user-entered city
                  function addUserCityWeather(cityName) {
                      fetch(`https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${apiKey}&units=metric`)
                      .then(response => response.json())
                      .then(data => {
                          const lat = data.coord.lat;
                          const lon = data.coord.lon;
                          const temp = data.main.temp;
                          const pressure = data.main.pressure;
                          const humidity = data.main.humidity;
                          const description = data.weather[0].description;
                          const popupContent = `
                              <div class="popup-content">
                                  <h3>${cityName}</h3>
                                  <p>Temperature: ${temp}°C</p>
                                  <p>Pressure: ${pressure} hPa</p>
                                  <p>Humidity: ${humidity}%</p>
                                  <p>Weather: ${description}</p>
                              </div>
                          `;
                          L.marker([lat, lon])
                              .addTo(map)
                              .bindPopup(popupContent);
                          map.setView([lat, lon], 10); // Zoom in on the user-entered city
                      })
                      .catch(error => console.error('Error fetching weather data:', error));
                  }

                  // Event listener for search button
                  document.getElementById('search-button').addEventListener('click', () => {
                      const cityInput = document.getElementById('city-input').value;
                      if (cityInput) {
                          addUserCityWeather(cityInput);
                      }
                  });
              </script>
          </body>
          </html>
          ''',
          mimeType: 'text/html',
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
