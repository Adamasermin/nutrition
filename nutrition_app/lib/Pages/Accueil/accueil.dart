import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Pages/Accueil/Graphes/mongraph.dart';
import 'package:nutrition_app/Services/enfant_service.dart'; // Importer le service enfant
import 'package:nutrition_app/Models/enfant.dart'; // Importer le modèle enfant

class Accueil extends StatefulWidget {
   final String? enfantId;  // Recevoir l'ID de l'enfant
  const Accueil({super.key, this.enfantId,});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  User? userConnecte;
  Enfant? enfant;
  final EnfantService _enfantService = EnfantService();

  @override
  void initState() {
    super.initState();
    userConnecte = FirebaseAuth.instance.currentUser;

    // Écoute les changements d'utilisateur
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        userConnecte = user;
      });
    });

    // Récupérer les données de l'enfant
    recupererEnfant();
  }
  // Mettre à jour l'enfant lors du clic sur une carte
  void mettreAJourEnfant(Enfant enfantSelectionne) {
    setState(() {
      enfant = enfantSelectionne;  // Mettre à jour l'état avec l'enfant sélectionné
    });
  }

  // Méthode pour récupérer les données de l'enfant
  Future<void> recupererEnfant() async {
    if (userConnecte != null) {
      try {
        Enfant? enfantRecupere =
            await _enfantService.recupererEnfantPourUtilisateur();
        setState(() {
          enfant = enfantRecupere; // Mise à jour des données de l'enfant
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de la récupération des données : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = userConnecte?.displayName ??userConnecte?.email ??'Utilisateur anonyme';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Salut!!!',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
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
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: DonneeEnfant(enfant: enfant),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher les données de l'enfant
class DonneeEnfant extends StatelessWidget {
  final Enfant? enfant;

  const DonneeEnfant({
    super.key,
    required this.enfant,
  });

  @override
  Widget build(BuildContext context) {
    if (enfant == null) {
      return const Center(child: Text('Aucun enfant trouvé.'));
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Column(
            children: [
              Text('Données enfant : ${enfant!.nomPrenom}'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${enfant!.poids} kg',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const Text(
                          'Poids',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(179, 107, 105, 105)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${enfant!.taille} cm',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const Text(
                          'Taille',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(179, 107, 105, 105)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${enfant!.imc?.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const Text(
                          'IMC',
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
          const Expanded(
              child: Mongraph(donneHebdomadaire: [
            12.2,
            56.2,
            32.1,
            10.6,
            20.8,
            15.6,
            25.8
          ])),
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
          const SizedBox(height: 20), // Espace de 20 pixels sous le titre
          SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Permet de faire défiler horizontalement
            child: Row(
              children: [
                // Première carte
                Card(
                  elevation: 8, // Élévation de la carte pour l'ombre
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Coins arrondis
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
                    borderRadius: BorderRadius.circular(10), // Coins arrondis
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
                    borderRadius: BorderRadius.circular(10), // Coins arrondis
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
