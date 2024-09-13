// import 'package:flutter/material.dart';
// import 'homescreen.dart'; // Import your HomeScreen
// import 'myaccount.dart'; // Import your MyAccountScreen

// class BottomNavigationBarExample extends StatefulWidget {
//   @override
//   _BottomNavigationBarExampleState createState() => _BottomNavigationBarExampleState();
// }

// class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     HomeScreen(),
//     // ClimateScreen(), // Replace with your actual ClimateScreen
//     // NewsScreen(), // Replace with your actual NewsScreen
//     // PlaceScreen(), // Replace with your actual PlaceScreen
//     MyAccountScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cloud),
//             label: 'Climate',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.new_releases),
//             label: 'News',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.place),
//             label: 'Place',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Donation',
//           ),
//         ],
//         selectedItemColor: Color(0xFF2F4299),
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//       ),
//     );
//   }
// }
