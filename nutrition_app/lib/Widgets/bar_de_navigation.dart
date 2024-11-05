import 'package:flutter/material.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:nutrition_app/Pages/Accueil/accueil.dart';
import 'package:nutrition_app/Pages/conseil.dart';
import 'package:nutrition_app/Pages/enfant.dart';
import 'package:nutrition_app/Pages/nutritioniste.dart';
import 'package:nutrition_app/Pages/recette.dart';

class BarDeNavigation extends StatefulWidget {
  final Enfant? enfantSelectionne;

  const BarDeNavigation({Key? key, this.enfantSelectionne}) : super(key: key);

  @override
  State<BarDeNavigation> createState() => _BarDeNavigationState();
}

class _BarDeNavigationState extends State<BarDeNavigation> {
  int _selectedIndex = 0;

  // Liste des pages associées à chaque onglet
  List<Widget> _pages() {
    return <Widget>[
      Accueil(enfantId: widget.enfantSelectionne?.id), // Passe l'ID de l'enfant sélectionné
      const Nutritioniste(),
      const RecettePage(),
      const EnfantPage(),
      const ConseilPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('ID de l\'enfant sélectionné : ${widget.enfantSelectionne?.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages()[_selectedIndex], // Affiche la page sélectionnée
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent, // Pas d'indicateur de sélection
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            _buildNavItem(Icons.home_filled, 'Accueil', 0),
            _buildNavItem(Icons.local_dining, 'Nutri', 1),
            _buildNavItem(Icons.receipt, 'Recette', 2),
            _buildNavItem(Icons.child_friendly, 'Enfant', 3),
            _buildNavItem(Icons.person, 'Conseil', 4),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return NavigationDestination(
      icon: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFFF7A73D),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFF7A73D),
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }
}
