import 'package:flutter/material.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/views/common/exports.dart';

//import 'package:recycling_app/views/screens/auth/profilepage.dart';
import 'package:recycling_app/views/screens/awareness/awareness_page.dart';
import 'package:recycling_app/views/screens/home/homepage.dart';

import 'package:recycling_app/views/screens/map/recycling_points.dart';
import 'package:recycling_app/views/screens/notifications/notifications_page.dart';
import 'package:recycling_app/views/screens/scheduling/scheduling_page.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomePage(),
    const RecyclingPoints(),
    const SchedulingPage(),
    const AwarenessPage(),
    const NotificationsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(kDarkBlue.value),
        selectedItemColor: Color(KGreen.value),
        unselectedItemColor: Color(kDarkGrey.value),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Captura',
        ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Cronograma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Manual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificacion',
          ),
        ],
      ),
    );
  }
}
