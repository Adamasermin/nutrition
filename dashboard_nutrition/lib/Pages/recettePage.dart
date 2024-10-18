import 'package:dashboard_nutrition/Models/recette.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Recettepage extends StatefulWidget {
  const Recettepage({super.key});

  @override
  State<Recettepage> createState() => _RecettepageState();
}

class _RecettepageState extends State<Recettepage> {

  final List<Recette> recettes = [
      Recette(id: 'id1', titre: 'titre', description: 'description', ingredients: 'ingredients', instructions: 'instructions', photo: 'photo'),
      Recette(id: 'id2', titre: 'titre', description: 'description', ingredients: 'ingredients', instructions: 'instructions', photo: 'photo'),
      Recette(id: 'id3', titre: 'titre', description: 'description', ingredients: 'ingredients', instructions: 'instructions', photo: 'photo'),
    ];

  // Fonction pour ouvrir un popup de confirmation de suppression
  Future<void> _showDeleteConfirmationDialog(Recette recette) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${recette.titre}?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Supprimer"),
              onPressed: () {
                setState(() {
                  recettes.remove(recette);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Recette? recette}) async {
    final TextEditingController titreController = TextEditingController(text: recette?.titre ?? '');
    final TextEditingController descriptionController = TextEditingController(text: recette?.description ?? '');
    final TextEditingController ingredientsController = TextEditingController(text: recette?.ingredients ?? '');
    final TextEditingController instructionsController = TextEditingController(text: recette?.instructions ?? '');
    final TextEditingController photoController = TextEditingController(text: recette?.photo ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(recette == null ? 'Ajouter une recette' : 'Modifier une recette'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller:titreController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                ),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                ),
                TextField(
                  controller: photoController,
                  decoration: const InputDecoration(labelText: 'Photo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Enregistrer"),
              onPressed: () {
                // Logique d'ajout ou de modification de l'enfant ici
                if (recette == null) {
                  // Ajouter un nouvel enfant
                  setState(() {
                    recettes.add(Recette(
                      id: 'E00${recettes.length + 1}',
                      titre: titreController.text,
                      description: descriptionController.text,
                      ingredients: ingredientsController.text,
                      instructions: instructionsController.text,
                      photo: photoController.text
                    ));
                  });
                } else {
                  // Modifier l'enfant existant
                  setState(() {
                    // enfant.nomPrenom = nomPrenomController.text;
                    // enfant.taille = tailleController.text;
                    // enfant.poids = poidsController.text;
                    // enfant.imc = imcController.text;
                  });
                }
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
        // Barre de recherche
        const Expanded(flex: 1, child: BarDeRechercheWidget()),

        // Contenu principal de la page
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header "Planifiez votre régime alimentaire"
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Planifiez votre régime alimentaire cette semaine',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recettes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _openFormPopup();
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Ajouter', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 1,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Titre')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Ingredients')),
                        DataColumn(label: Text('Instructions')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: recettes.map((recette) {
                        return DataRow(cells: [
                          DataCell(Text(recette.id)),
                          DataCell(Text(recette.titre)),
                          DataCell(Text(recette.description)),
                          DataCell(Text(recette.ingredients)),
                          DataCell(Text(recette.description)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _openFormPopup();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(recette);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
