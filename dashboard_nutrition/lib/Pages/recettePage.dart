import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:dashboard_nutrition/Models/recette.dart';
import 'package:dashboard_nutrition/Services/recette_service.dart';

class Recettepage extends StatefulWidget {
  const Recettepage({super.key});

  @override
  State<Recettepage> createState() => _RecettepageState();
}

class _RecettepageState extends State<Recettepage> {
  final RecetteService _recetteService = RecetteService();
  final TextEditingController _searchController = TextEditingController();

  List<Recette> _recettes = [];
  List<Recette> _filteredRecettes = [];
  Uint8List? _imageData;
  String? _imageUrl; // URL de l'image à sauvegarder

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((e) async {
        setState(() {
          _imageData = reader.result as Uint8List;
        });

        // Téléchargement de l'image vers Firebase Storage
        try {
          final String fileName =
              DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = FirebaseStorage.instance.ref('recettes/$fileName');
          await storageRef.putData(_imageData!);

          // Obtenir l'URL de l'image téléchargée
          String downloadUrl = await storageRef.getDownloadURL();
          setState(() {
            _imageUrl = downloadUrl;
          });
        } catch (error) {
          print("Erreur de téléchargement : $error");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecettes();
  }

  Future<void> _loadRecettes() async {
    final recettes = await _recetteService.getRecettes().first;
    setState(() {
      _recettes = recettes;
      _filteredRecettes = recettes;
    });
  }

  // Fonction pour filtrer les recettes
  void _filterRecettes(String query) {
    setState(() {
      _filteredRecettes = _recettes.where((recette) {
        final ingredientLower = recette.ingredients.toLowerCase();
        final titreLower = recette.titre.toLowerCase();
        final descriptionLower = recette.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return ingredientLower.contains(searchLower) ||
            titreLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    });
  }

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
                await _recetteService.supprimerRecette(recette.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openFormPopup({Recette? recette}) async {
    final TextEditingController titreController =
        TextEditingController(text: recette?.titre ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: recette?.description ?? '');
    final TextEditingController ingredientsController =
        TextEditingController(text: recette?.ingredients ?? '');
    final TextEditingController instructionsController =
        TextEditingController(text: recette?.instructions ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              recette == null ? 'Ajouter une recette' : 'Modifier une recette'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titreController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingrédients'),
                ),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.orange),
                      foregroundColor: WidgetStatePropertyAll(Colors.white)),
                  onPressed: _pickImage,
                  child: const Text('Sélectionner une image'),
                ),
                if (_imageData != null)
                  Image.memory(
                    _imageData!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
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
                final newRecette = Recette(
                  id: recette?.id ??
                      '', // Laisser Firebase générer l'ID si null
                  titre: titreController.text,
                  description: descriptionController.text,
                  ingredients: ingredientsController.text,
                  instructions: instructionsController.text,
                  photo: _imageUrl ?? recette?.photo ?? '', // URL de l'image
                );

                if (recette == null) {
                  await _recetteService.ajouterRecette(newRecette);
                } else {
                  await _recetteService.modifierRecette(recette.id, newRecette);
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
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.all(20),
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
        // Titre + Bouton Ajouter
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
                label: const Text(
                  'Ajouter',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
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
                hintStyle: TextStyle(color: Color.fromARGB(175, 149, 148, 148)),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: Color.fromARGB(175, 149, 148, 148),
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) => _filterRecettes(value)),
        ),
        Expanded(
          flex: 10,
          child: StreamBuilder<List<Recette>>(
            stream: _recetteService.getRecettes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Erreur lors du chargement des recettes.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Mise à jour de la liste complète des recettes
              if (snapshot.hasData) {
                _recettes = snapshot.data ?? [];
                _filteredRecettes = _searchController.text.isEmpty
                    ? _recettes
                    : _filteredRecettes; // Utilisez la liste filtrée si une recherche est active
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
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Titre')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Ingredients')),
                        DataColumn(label: Text('Instructions')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: List<DataRow>.generate(_filteredRecettes.length,
                          (index) {
                        final recette = _filteredRecettes[index];
                        return DataRow(cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(
                            recette.photo.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                        5.0), // Ajoutez la marge souhaitée
                                    child: ClipOval(
                                      child: Image.network(
                                        recette.photo,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Text('Pas d\'image'),
                          ),
                          DataCell(Text(recette.titre)),
                          DataCell(Text(recette.description)),
                          DataCell(Text(recette.ingredients)),
                          DataCell(Text(recette.instructions)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _openFormPopup(recette: recette),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _showDeleteConfirmationDialog(recette),
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
