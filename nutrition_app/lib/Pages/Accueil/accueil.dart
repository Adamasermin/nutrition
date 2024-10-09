import 'package:flutter/material.dart';
import 'package:nutrition_app/Pages/Accueil/Graphes/mongraph.dart';



class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  // Liste pour stocker les données hebdomadaires à afficher dans le graphique
  List<double> donneHebdomadaire = [
    12.2,
    56.2,
    32.1,
    10.6,
    20.8,
    15.6,
    25.8,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Assure que le contenu est bien affiché sans chevauchement avec les bords de l'écran
        child: Column(
          children: [
            SingleChildScrollView(
                child: Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 40, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Salut!!!',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'userName', // Utiliser le nom de l'utilisateur récupéré
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/notification'),
                          child: const Icon(
                            Icons.notifications,
                            color: Color(0xFFFB7129),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(175, 149, 148, 148)),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 25,
                              color: Color.fromARGB(175, 149, 148, 148),
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Expanded(
              flex: 2,
              child: DonneeEnfant(donneHebdomadaire: donneHebdomadaire),
            ),
          ],
        ),
      ),
    );
  }
}


class DonneeEnfant extends StatelessWidget {
  const DonneeEnfant({
    super.key,
    required this.donneHebdomadaire,
  });

  final List<double> donneHebdomadaire;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Column(
            children: [
              Text('Données enfant : Salwa SERMIN'),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  // Affichage du poids
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '25 kg', // Affichage du poids
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          'Poids', // Étiquette du poids
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(179, 107, 105, 105)),
                        ),
                      ],
                    ),
                  ),
                  // Affichage de la taille
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '123 cm', // Affichage de la taille
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          'Taille', // Étiquette de la taille
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(179, 107, 105, 105)),
                        ),
                      ],
                    ),
                  ),
                  // Affichage de l'IMC
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '123',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          'IMC', // Étiquette de l'IMC
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(179, 107, 105, 105)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: Mongraph(donneHebdomadaire: donneHebdomadaire)),
          const Expanded(
            flex: 2,
            child: RecetteFavoris(),
          ),
        ],
      ),
    );
  }
}


class RecetteFavoris extends StatelessWidget {
  const RecetteFavoris({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Alignement des enfants sur le début de la colonne
        children: [
          const Text(
            'Favoris', // Titre de la section
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
              height: 20), // Espace de 20 pixels sous le titre
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Permet de faire défiler horizontalement
            child: Row(
              children: [
                // Première carte
                Card(
                  elevation: 8, // Élévation de la carte pour l'ombre
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Coins arrondis
                  ),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/plat2.png', // Image affichée sur la carte
                    ),
                    const Text('Recettes'), // Texte sous l'image
                  ]),
                ),
                // Deuxième carte (identique à la première)
                Card(
                  elevation: 8, // Élévation de la carte pour l'ombre
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Coins arrondis
                  ),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/plat2.png', // Image affichée sur la carte
                    ),
                    const Text('Recettes'), // Texte sous l'image
                  ]),
                ),
                // Troisième carte (identique à la première et deuxième)
                Card(
                  elevation: 8, // Élévation de la carte pour l'ombre
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Coins arrondis
                  ),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/plat2.png', // Image affichée sur la carte
                    ),
                    const Text('Recettes'), // Texte sous l'image
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
