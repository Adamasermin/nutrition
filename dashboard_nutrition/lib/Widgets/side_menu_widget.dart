import 'package:dashboard_nutrition/Const/constante.dart';
import 'package:dashboard_nutrition/Data/side_menu_data.dart';
import 'package:dashboard_nutrition/Pages/accueilPage.dart';
import 'package:dashboard_nutrition/Pages/conseilPage.dart';
import 'package:dashboard_nutrition/Pages/enfantPage.dart';
import 'package:dashboard_nutrition/Pages/nutritionistePage.dart';
import 'package:dashboard_nutrition/Pages/parentPage.dart';
import 'package:dashboard_nutrition/Pages/profilPage.dart';
import 'package:dashboard_nutrition/Pages/recettePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int _currentIndex = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deconnexion() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/');
      print('Déconnexion réussie');
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }

  final List<Widget> _pages = [
    const AccueilPage(),
    const Enfantpage(),
    const Conseilpage(),
    const Recettepage(),
    const Nutritionistepage(),
    const Parentpage(),
    const Profilpage()
  ];

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    // Récupérer l'utilisateur connecté
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: bgCouleur,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Couleur du fond
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // Position de l'ombre (x, y)
                      ),
                    ],
                    border: const Border(
                      right: BorderSide(
                        color: Colors.grey, // Couleur de la bordure droite
                        width: 1, // Largeur de la bordure droite
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/images/Logo.png',
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            itemCount: data.menu.length,
                            itemBuilder: (context, index) =>
                                buildMenuEntry(data, index),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        AssetImage('assets/images/profil.jpg'),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    user?.displayName ??
                                        "Utilisateur", // Si displayName est null, afficher "Utilisateur"
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showLogoutConfirmationDialog(
                                      context); // Appel de la fonction de popup
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Deconnexion',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le popup de confirmation
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous vraiment vous déconnecter ?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le popup
              },
            ),
            TextButton(
              child: const Text("Confirmer"),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le popup
                await deconnexion(); // Appel de la fonction de déconnexion
                // Rediriger vers la page de connexion
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = _currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? couleurPrimaire : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        onTap: () => setState(() {
          _currentIndex = index;
        }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: FaIcon(
                data.menu[index].icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].titre,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
