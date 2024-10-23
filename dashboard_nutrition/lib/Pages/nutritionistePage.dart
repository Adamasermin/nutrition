import 'package:dashboard_nutrition/Models/nutritioniste.dart';
import 'package:dashboard_nutrition/Services/nutritioniste_service.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Nutritionistepage extends StatefulWidget {
  const Nutritionistepage({super.key});

  @override
  State<Nutritionistepage> createState() => _NutritionistepageState();
}

class _NutritionistepageState extends State<Nutritionistepage> {

  final NutritionisteService _nutritionisteService = NutritionisteService();

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Nutritioniste? nutritioniste}) async {
    final TextEditingController nomPrenomController = TextEditingController(text: nutritioniste?.nomPrenom ?? '');
    final TextEditingController emailController = TextEditingController(text: nutritioniste?.email ?? '');
    final TextEditingController passwordController = TextEditingController(text: nutritioniste?.password ?? '');
    final TextEditingController telephoneController = TextEditingController(text: nutritioniste?.telephone ?? '');
    final TextEditingController photoController = TextEditingController(text: nutritioniste?.photo ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(nutritioniste == null ? 'Ajouter un nutritioniste' : 'Modifier un nutritioniste'),
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
              onPressed: () async {
                // Logique d'ajout ou de modification
                if (nutritioniste == null) {
                  await _nutritionisteService.ajouterNutri(Nutritioniste(
                      id: '', // Firebase génère l'ID
                      nomPrenom: nomPrenomController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      telephone: telephoneController.text,
                      photo: photoController.text
                      ));
                } else {
                  await _nutritionisteService.modifierNutri(
                    nutritioniste.id!,
                    Nutritioniste(
                        id: nutritioniste.id,
                        nomPrenom: nomPrenomController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        telephone: telephoneController.text,
                        photo: photoController.text
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
  Future<void> _showDeleteConfirmationDialog(Nutritioniste nutritioniste) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${nutritioniste.nomPrenom}?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Supprimer"),
              onPressed: () async {
                await _nutritionisteService.supprimerNutri(nutritioniste.id!);
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
              Expanded(
                flex: 10,
                child: StreamBuilder<List<Nutritioniste>>(
                  stream: _nutritionisteService.getNutritionistes(),
                  builder: (BuildContext context, AsyncSnapshot<List<Nutritioniste>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erreur lors du chargement des nutritionistes.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final nutritionistes = snapshot.data ?? [];

                    return Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
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
                        ),
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
                                  DataColumn(label: Text('Nom et Prenom')),
                                  DataColumn(label: Text('Email')),
                                  DataColumn(label: Text('Telephone')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: List<DataRow>.generate(nutritionistes.length,(index) {
                                  final nutritioniste = nutritionistes[index];

                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(nutritioniste.nomPrenom)),
                                    DataCell(Text(nutritioniste.email)),
                                    DataCell(Text(nutritioniste.telephone)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () {
                                              _openFormPopup();
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
                                }),
                              ),
                            ),
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