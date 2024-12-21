import 'package:flutter/material.dart';
import 'package:instructor_auto/screens/home_screen.dart';

//create statefullwidget class StartScreen
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  //create state class _StartScreenState
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //create a variable to store the current index
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    Center(),
    Center(),
    Center(),
  ];

  //create a function to change the current index
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //build the start screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //create a body with the current widget
      body: _children[_currentIndex],
      //create a bottom navigation bar with two items
      bottomNavigationBar: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildMenuItem(Icons.home, "Acasa", 0, _currentIndex, onTabTapped),
              _buildMenuItem(Icons.calendar_month, "Program", 1, _currentIndex, onTabTapped),
              _buildMenuItem(Icons.people_alt_outlined, "Elevi", 2, _currentIndex, onTabTapped),
              _buildMenuItem(Icons.settings, "Setari", 3, _currentIndex, onTabTapped),
            ],
          ),
        ),
      ),
    );
  }

  // Funcție pentru a crea elemente din meniu cu iconiță și text
  Widget _buildMenuItem(IconData icon, String label, int index, int selectedIndex, Function(int) onTap) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? Colors.red : Colors.black54;

    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
