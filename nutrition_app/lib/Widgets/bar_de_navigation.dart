import 'package:flutter/material.dart';
import 'package:nutrition_app/Pages/Accueil/accueil.dart';
import 'package:nutrition_app/Pages/enfant.dart';
import 'package:nutrition_app/Pages/nutritioniste.dart';
import 'package:nutrition_app/Pages/profil.dart';
import 'package:nutrition_app/Pages/recette.dart';
import 'package:nutrition_app/Models/enfant.dart'; // Import du modèle Enfant

class BarDeNavigation extends StatefulWidget {
  const BarDeNavigation({super.key});

  @override
  State<BarDeNavigation> createState() => _BarDeNavigationState();
}

class _BarDeNavigationState extends State<BarDeNavigation> {
  int _selectedIndex = 0;
  Enfant? _selectedEnfant;

  // Liste des pages associées à chaque onglet
  List<Widget> _pages(Enfant? enfantSelectionne) {
    return <Widget>[
      Accueil(), // Passer l'enfant sélectionné à l'accueil
      const Nutritioniste(),
      const Recette(),
      EnfantPage(),
      const Profil(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Afficher la page correspondant à l'index sélectionné, en passant l'enfant sélectionné
      body: _pages(_selectedEnfant)[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent, // Pas d'indicateur de sélection
        ),
        child: NavigationBar(
          height: 60, // Ajuster la hauteur de la barre de navigation
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            _buildNavItem(Icons.home_filled, 'Accueil', 0),
            _buildNavItem(Icons.local_dining, 'Nutri', 1),
            _buildNavItem(Icons.receipt, 'Recette', 2),
            _buildNavItem(Icons.child_friendly, 'Enfant', 3),
            _buildNavItem(Icons.person, 'Profil', 4),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire chaque destination avec fond personnalisé
  NavigationDestination _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return NavigationDestination(
      icon: Container(
        width: double.infinity, // Largeur fixe pour occuper tout l'espace disponible
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent, // Couleur de fond si sélectionné ou non
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFFF7A73D), // Couleur de l'icône sélectionnée et non sélectionnée
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFFF7A73D), // Couleur du texte sélectionné et non sélectionné
              ),
            ),
          ],
        ),
      ),
      label: '', // Supprimer le label par défaut, géré dans le Container
    );
  }
}
