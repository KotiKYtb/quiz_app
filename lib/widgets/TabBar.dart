import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavBar({required this.currentRoute});

  void _onItemTapped(BuildContext context, int index) {
    String newRoute;
    switch (index) {
      case 0:
        newRoute = '/home';
        break;
      case 1:
        newRoute = '/profile';
        break;
      default:
        newRoute = '/home';
    }

    if (newRoute != currentRoute) {
      Navigator.pushReplacementNamed(context, newRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = currentRoute == '/profile' ? 1 : 0;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profil"),
      ],
    );
  }
}