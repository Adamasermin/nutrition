import 'package:flutter/material.dart';
import 'package:nutrition_app/Pages/Accueil/Graphes/mongraph.dart';
import 'package:nutrition_app/Services/enfant_service.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Accueil extends StatefulWidget {
  final String? enfantId;
  const Accueil({super.key, this.enfantId});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  User? userConnecte;
  Enfant? enfant;
  bool isLoading = true;
  final EnfantService _enfantService = EnfantService();
  List<double> donneesMensuelles = List.filled(12, 0.0);

  @override
  void initState() {
    super.initState();
    userConnecte = FirebaseAuth.instance.currentUser;

    // Debug : Affiche l'ID de l'enfant
    print('ID de l\'enfant passé à Accueil : ${widget.enfantId}');

    // Écoute les changements d'utilisateur
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        userConnecte = user;
      });
    });

    // Récupérer les données de l'enfant
    recupererEnfant();
  }

  Future<void> recupererEnfant() async {
    if (userConnecte != null) {
      try {
        if (widget.enfantId != null) {
          // Si un ID d'enfant est passé, récupérez cet enfant
          enfant = await _enfantService.getEnfantById(widget.enfantId!, userConnecte!.uid);
        } else {
          // Sinon, récupérez le premier enfant
          enfant = await _enfantService.getPremierEnfant(userConnecte!.uid);
        }
        setState(() {
          isLoading = false;
        });
        if (enfant != null) {
          _mettreAJourDonneesMensuelles();
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des données : $e')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mettreAJourDonneesMensuelles() {
    if (enfant != null) {
      setState(() {
        donneesMensuelles[DateTime.now().month - 1] = enfant!.poids;
        print('Données mensuelles mises à jour : $donneesMensuelles');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profil');
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: userConnecte?.photoURL != null
                            ? NetworkImage(userConnecte!.photoURL!)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: userConnecte?.photoURL == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/notification'),
                      child: const Icon(Icons.notifications, color: Color(0xFFFB7129)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (enfant != null
                      ? DonneeEnfant(
                          enfant: enfant,
                          donneesMensuelles: donneesMensuelles,
                        )
                      : const Center(child: Text('Aucun enfant trouvé'))),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher les données de l'enfant et le graphique mensuel
class DonneeEnfant extends StatelessWidget {
  final Enfant? enfant;
  final List<double> donneesMensuelles;

  const DonneeEnfant({super.key, required this.enfant, required this.donneesMensuelles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text('Données enfant : ${enfant?.nomPrenom ?? 'Non disponible'}'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${enfant?.poids ?? '-'} kg', style: const TextStyle(fontSize: 20, color: Colors.black)),
                    const Text('Poids', style: TextStyle(fontSize: 14, color: Color.fromARGB(179, 107, 105, 105))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${enfant?.taille ?? '-'} cm', style: const TextStyle(fontSize: 20, color: Colors.black)),
                    const Text('Taille', style: TextStyle(fontSize: 14, color: Color.fromARGB(179, 107, 105, 105))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${enfant?.imc?.toStringAsFixed(2) ?? '-'}', style: const TextStyle(fontSize: 20, color: Colors.black)),
                    const Text('IMC', style: TextStyle(fontSize: 14, color: Color.fromARGB(179, 107, 105, 105))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: Mongraph(mois: donneesMensuelles)),
          const Expanded(flex: 2, child: RecetteFavoris()),
        ],
      ),
    );
  }
}

class RecetteFavoris extends StatelessWidget {
  const RecetteFavoris({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favoris', style: TextStyle(fontSize: 20, color: Colors.black)),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                3,
                (index) => Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Image.asset('assets/images/plat2.png'),
                      const Text('Recettes'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
