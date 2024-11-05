import 'package:flutter/material.dart';
import 'package:nutrition_app/Models/recette.dart';
import 'package:nutrition_app/Pages/Accueil/Graphes/mongraph.dart';
import 'package:nutrition_app/Services/enfant_service.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/Services/recette_service.dart';

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
  final RecetteService _recetteService = RecetteService();
  List<double> donneesMensuelles = List.filled(12, 0.0);
  List<Recette> recettesFavoris = [];

  @override
  void initState() {
    super.initState();
    userConnecte = FirebaseAuth.instance.currentUser;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        userConnecte = user;
      });
    });

    recupererEnfant();
    recupererRecettesFavorites();
  }

  Future<void> recupererEnfant() async {
    if (userConnecte != null) {
      try {
        if (widget.enfantId != null) {
          enfant = await _enfantService.getEnfantById(
              widget.enfantId!, userConnecte!.uid);
        } else {
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
          SnackBar(
              content: Text('Erreur lors de la récupération des données : $e')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> recupererRecettesFavorites() async {
    try {
      List<Recette> recettes =
          await _recetteService.recupererRecettesFavorites();
      setState(() {
        recettesFavoris = recettes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erreur lors de la récupération des recettes favorites : $e')),
      );
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
                    Text(
                      'Bienvenue, ${userConnecte?.displayName ?? ''}!',
                      style: const TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/notification'),
                      child: const Icon(Icons.notifications,
                          color: Color(0xFFFB7129)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (enfant != null
                      ? DonneeEnfant(
                          enfant: enfant,
                          donneesMensuelles: donneesMensuelles,
                          recettes: recettesFavoris,
                        )
                      : const Center(child: Text('Aucun enfant trouvé'))),
            ),
          ],
        ),
      ),
    );
  }
}

class DonneeEnfant extends StatelessWidget {
  final Enfant? enfant;
  final List<double> donneesMensuelles;
  final List<Recette> recettes;

  const DonneeEnfant(
      {super.key,
      required this.enfant,
      required this.donneesMensuelles,
      required this.recettes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text('Données enfant : ${enfant?.nomPrenom ?? 'Non disponible'}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 15,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.shade100,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Icon(Icons.monitor_weight, color: Colors.deepOrange),
                      const SizedBox(height: 4),
                      Text('${enfant?.poids ?? '-'} kg',
                          style: const TextStyle(fontSize: 20, color: Colors.black)),
                      const Text('Poids', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.shade100,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Icon(Icons.height, color: Colors.deepOrange),
                      const SizedBox(height: 4),
                      Text('${enfant?.taille ?? '-'} cm',
                          style: const TextStyle(fontSize: 20, color: Colors.black)),
                      const Text('Taille', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.shade100,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Icon(Icons.health_and_safety, color: Colors.deepOrange),
                      const SizedBox(height: 4),
                      Text('${enfant?.imc?.toStringAsFixed(2) ?? '-'}',
                          style: const TextStyle(fontSize: 20, color: Colors.black)),
                      const Text('IMC', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: Mongraph(mois: donneesMensuelles)),
          Expanded(
            flex: 2,
            child: RecetteFavoris(
              recettes: recettes,
              margeHaut: 10,
            ),
          ),
        ],
      ),
    );
  }
}


class RecetteFavoris extends StatefulWidget {
  final List<Recette> recettes;
  final double margeHaut;

  const RecetteFavoris({
    super.key,
    required this.recettes,
    this.margeHaut = 0,
  });

  @override
  State<RecetteFavoris> createState() => _RecetteFavorisState();
}

class _RecetteFavorisState extends State<RecetteFavoris> {
  late List<Recette> _recettesFavorites;

  @override
  void initState() {
    super.initState();
    _recettesFavorites =
        widget.recettes.where((recette) => recette.estFavori).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.margeHaut, left: widget.margeHaut),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recettes Favoris',
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          _recettesFavorites.isEmpty
              ? const Center(child: Text('Aucune recette favorite'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _recettesFavorites.length,
                      (index) => Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  _recettesFavorites[index].photo,
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _recettesFavorites[index].titre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _recettesFavorites[index].description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
