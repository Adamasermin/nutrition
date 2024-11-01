import 'dart:typed_data';
import 'package:dashboard_nutrition/Models/nutritioniste.dart';
import 'package:dashboard_nutrition/Services/nutritioniste_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class Nutritionistepage extends StatefulWidget {
  const Nutritionistepage({super.key});

  @override
  State<Nutritionistepage> createState() => _NutritionistepageState();
}

class _NutritionistepageState extends State<Nutritionistepage> {
  final NutritionisteService _nutritionisteService = NutritionisteService();
  final TextEditingController _searchController = TextEditingController();

  List<Nutritioniste> _nutritionistes = [];
  List<Nutritioniste> _filteredNutritioniste = [];
  Uint8List? _imageData;
  String? _imageUrl;

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
    _loadNutritioniste();
  }

  Future<void> _loadNutritioniste() async {
    final nutritionistes =
        await _nutritionisteService.getNutritionistes().first;
    setState(() {
      _nutritionistes = nutritionistes;
      _filteredNutritioniste = nutritionistes;
    });
  }

  void _filterNutritioniste(String query) {
    setState(() {
      _filteredNutritioniste = _nutritionistes.where((nutritioniste) {
        final nomPrenomLower = nutritioniste.nomPrenom.toLowerCase();
        final emailLower = nutritioniste.email.toLowerCase();
        final searchLower = query.toLowerCase();

        return nomPrenomLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();
    });
  }

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Nutritioniste? nutritioniste}) async {
    final TextEditingController nomPrenomController =
        TextEditingController(text: nutritioniste?.nomPrenom ?? '');
    final TextEditingController emailController =
        TextEditingController(text: nutritioniste?.email ?? '');
    final TextEditingController passwordController =
        TextEditingController(text: nutritioniste?.password ?? '');
    final TextEditingController telephoneController =
        TextEditingController(text: nutritioniste?.telephone ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(nutritioniste == null
              ? 'Ajouter un nutritioniste'
              : 'Modifier un nutritioniste'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomPrenomController,
                  decoration: const InputDecoration(labelText: 'Nom et Prénom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Telephone'),
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
                // Logique d'ajout ou de modification
                if (nutritioniste == null) {
                  await _nutritionisteService.ajouterNutri(Nutritioniste(
                    id: '', // Firebase génère l'ID
                    nomPrenom: nomPrenomController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    telephone: telephoneController.text,
                    photo: _imageUrl ??
                        nutritioniste?.photo ??
                        '', // URL de l'image
                  )); // Enregistrer le chemin de l'image sélectionnée
                } else {
                  await _nutritionisteService.modifierNutri(
                    nutritioniste.id,
                    Nutritioniste(
                      id: nutritioniste.id,
                      nomPrenom: nomPrenomController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      telephone: telephoneController.text,
                      photo: _imageUrl ?? nutritioniste.photo ,
                    ), // Si une nouvelle image est sélectionnée, l'enregistrer
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
  Future<void> _showDeleteConfirmationDialog(
      Nutritioniste nutritioniste) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text(
              "Êtes-vous sûr de vouloir supprimer ${nutritioniste.nomPrenom}?"),
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
                backgroundColor: Colors.red, // Couleur d'arrière-plan
                foregroundColor: Colors.white, // Couleur du texte (optionnelle)
              ),
              child: const Text("Supprimer"),
              onPressed: () async {
                await _nutritionisteService.supprimerNutri(nutritioniste.id);
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
        Expanded(
          flex: 10,
          child: Column(
            children: [
              // Titre + Bouton Ajouter
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nutritionistes',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(175, 149, 148, 148)),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25,
                      color: Color.fromARGB(175, 149, 148, 148),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _filterNutritioniste(value),
                ),
              ),
              Expanded(
                flex: 10,
                child: StreamBuilder<List<Nutritioniste>>(
                  stream: _nutritionisteService.getNutritionistes(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Nutritioniste>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                              'Erreur lors du chargement des nutritionistes.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      _nutritionistes = snapshot.data ?? [];
                      _filteredNutritioniste = _searchController.text.isEmpty
                          ? _nutritionistes
                          : _filteredNutritioniste;
                    }

                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
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
                                    DataColumn(label: Text('Photo')),
                                    DataColumn(label: Text('Nom et Prenom')),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Telephone')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    _filteredNutritioniste.length,
                                    (index) {
                                      final nutritioniste =
                                          _filteredNutritioniste[index];

                                      return DataRow(cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          nutritioniste.photo.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      5.0), // Ajoutez la marge souhaitée
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      nutritioniste.photo,
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : const Text('Pas d\'image'),
                                        ),
                                        DataCell(Text(nutritioniste
                                            .nomPrenom)), // Nom et Prénom
                                        DataCell(
                                            Text(nutritioniste.email)), // Email
                                        DataCell(Text(nutritioniste
                                            .telephone)), // Téléphone
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  _openFormPopup(
                                                      nutritioniste:
                                                          nutritioniste);
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  _showDeleteConfirmationDialog(
                                                      nutritioniste);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    },
                                  ),
                                )),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
