import 'package:dashboard_nutrition/Models/enfant.dart';
import 'package:dashboard_nutrition/Services/enfant_service.dart';
import 'package:flutter/material.dart';

class Enfantpage extends StatefulWidget {
  const Enfantpage({super.key});

  @override
  State<Enfantpage> createState() => _EnfantpageState();
}

class _EnfantpageState extends State<Enfantpage> {
  final EnfantService _enfantService = EnfantService();
  final TextEditingController _searchController = TextEditingController();

  List<Enfant> _enfants = [];
  List<Enfant> _filteredEnfants = [];

  @override
  void initState() {
    super.initState();
    _loadEnfants(); // Charger la liste des enfants au démarrage
  }

  // Fonction pour charger les enfants depuis le service
  Future<void> _loadEnfants() async {
    final enfants = await _enfantService.getEnfants().first;
    setState(() {
      _enfants = enfants;
      _filteredEnfants = enfants; // Par défaut, tous les enfants sont affichés
    });
  }

  // Fonction pour filtrer les enfants selon le nom ou l'âge
  void _filterEnfants(String query) {
    setState(() {
      _filteredEnfants = _enfants.where((enfant) {
        final nomPrenomLower = enfant.nomPrenom.toLowerCase();
        final ageStr = enfant.getAge().toString();
        final searchLower = query.toLowerCase();

        // Retourne vrai si le nom ou l'âge correspond à la recherche
        return nomPrenomLower.contains(searchLower) ||
            ageStr.contains(searchLower);
      }).toList();
    });
  }

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Enfant? enfant}) async {
    final TextEditingController nomPrenomController =
        TextEditingController(text: enfant?.nomPrenom ?? '');
    final TextEditingController tailleController =
        TextEditingController(text: enfant?.taille.toString() ?? '');
    final TextEditingController poidsController =
        TextEditingController(text: enfant?.poids.toString() ?? '');
    final TextEditingController imcController =
        TextEditingController(text: enfant?.imc?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(enfant == null ? 'Ajouter un enfant' : 'Modifier un enfant'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomPrenomController,
                  decoration: const InputDecoration(labelText: 'Nom et Prénom'),
                ),
                TextField(
                  controller: tailleController,
                  decoration: const InputDecoration(labelText: 'Taille (cm)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: poidsController,
                  decoration: const InputDecoration(labelText: 'Poids (kg)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imcController,
                  decoration: const InputDecoration(labelText: 'IMC'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Couleur d'arrière-plan
                foregroundColor: Colors.white, // Couleur du texte (optionnelle)
              ),
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, // Couleur d'arrière-plan
                foregroundColor: Colors.white, // Couleur du texte (optionnelle)
              ),
              child: const Text("Enregistrer"),
              onPressed: () async {
                if (enfant == null) {
                  // Ajouter un nouvel enfant dans la base de données
                  await _enfantService.ajouterEnfant(Enfant(
                    id: '', // Firebase génère l'ID
                    nomPrenom: nomPrenomController.text,
                    dateDeNaissance: DateTime.now(),
                    taille: double.parse(tailleController.text),
                    poids: double.parse(poidsController.text),
                    imc: double.parse(imcController.text),
                    userId:
                        '', // À remplacer par l'ID de l'utilisateur si nécessaire
                  ));
                } else {
                  // Modifier un enfant existant dans la base de données
                  await _enfantService.modifierEnfant(
                    enfant.id!,
                    Enfant(
                      id: enfant.id,
                      nomPrenom: nomPrenomController.text,
                      dateDeNaissance: enfant.dateDeNaissance,
                      taille: double.parse(tailleController.text),
                      poids: double.parse(poidsController.text),
                      imc: double.parse(imcController.text),
                      userId: enfant.userId,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour ouvrir un popup de confirmation de suppression
  Future<void> _showDeleteConfirmationDialog(Enfant enfant) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content:
              Text("Êtes-vous sûr de vouloir supprimer ${enfant.nomPrenom}?"),
          actions: [
            TextButton(
               style: TextButton.styleFrom(
                backgroundColor: Colors
                    .grey,
                foregroundColor:
                    Colors.white, 
              ),
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors
                    .red,
                foregroundColor:
                    Colors.white, 
              ),
              child: const Text("Supprimer"),
              onPressed: () async {
                // Supprimer l'enfant de Firebase
                await _enfantService.supprimerEnfant(enfant.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50, bottom: 50),
          child: const Text(
            'Liste des enfants',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Recherche',
              hintStyle:
                  TextStyle(color: Color.fromARGB(175, 149, 148, 148)),
              prefixIcon: Icon(
                Icons.search,
                size: 25,
                color: Color.fromARGB(175, 149, 148, 148),
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              _filterEnfants(value); // Filtrer les résultats en fonction de la saisie
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          flex: 10,
          child: StreamBuilder<List<Enfant>>(
            stream: _enfantService.getEnfants(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Erreur lors du chargement des enfants.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Mise à jour de la liste complète d'enfants quand les données sont chargées
              if (snapshot.hasData) {
                _enfants = snapshot.data ?? [];
                _filteredEnfants = _searchController.text.isEmpty ? _enfants : _filteredEnfants; // Utilisez la liste filtrée si une recherche est active
              }
    
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 90% de la largeur de l'écran
                    height: double.infinity,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nom et Prenom')),
                        DataColumn(label: Text('Age')),
                        DataColumn(label: Text('Taille')),
                        DataColumn(label: Text('Poids')),
                        DataColumn(label: Text('IMC')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows:
                          List<DataRow>.generate(_filteredEnfants.length, (index) {
                        final enfant = _filteredEnfants[index];
                        return DataRow(cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(enfant.nomPrenom)),
                          DataCell(Text(enfant.getAge().toString())), 
                          DataCell(Text((enfant.taille).toString())),
                          DataCell(Text((enfant.poids).toString())),
                          DataCell(Text((enfant.imc).toString())),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _openFormPopup(enfant: enfant),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _showDeleteConfirmationDialog( enfant),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
