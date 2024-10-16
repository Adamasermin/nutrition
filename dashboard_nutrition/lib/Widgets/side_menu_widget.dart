import 'package:dashboard_nutrition/Const/constante.dart';
import 'package:dashboard_nutrition/Data/side_menu_data.dart';
import 'package:dashboard_nutrition/Pages/accueilPage.dart';
import 'package:dashboard_nutrition/Pages/conseilPage.dart';
import 'package:dashboard_nutrition/Pages/enfantPage.dart';
import 'package:dashboard_nutrition/Pages/nutritionistePage.dart';
import 'package:dashboard_nutrition/Pages/parentPage.dart';
import 'package:dashboard_nutrition/Pages/profilPage.dart';
import 'package:dashboard_nutrition/Pages/recettePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int _currentIndex = 0;

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

    return Scaffold(
      backgroundColor: bgCouleur,
      body: SafeArea(
          child: Row(
        children: [
          Expanded(
              flex: 2,
              child: SizedBox(
                  child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 81, 80, 85), // Couleur de départ
                      Color.fromARGB(255, 64, 64, 64), // Couleur de fin
                    ],
                    begin: Alignment.bottomCenter, // Début du dégradé
                    end: Alignment.topCenter, // Fin du dégradé
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
                                buildMenuEntry(data, index)),
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'assets/images/profil.jpg'),
                                    ),
                                  ),
                                  const Text(
                                    "Adama SERMIN",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () {},
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
                        ))
                  ],
                ),
              ))),
          Expanded(
              flex: 9,
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              )),
        ],
      )),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = _currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: isSelected ? couleurPrimaire : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
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
                color: isSelected ? Colors.white : Colors.white,
              ),
            ),
            Text(
              data.menu[index].titre,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
