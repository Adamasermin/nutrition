import 'package:dashboard_nutrition/Models/conseil.dart';
import 'package:dashboard_nutrition/Services/conseil_service.dart';

import 'package:flutter/material.dart';

class Conseilpage extends StatefulWidget {
  const Conseilpage({super.key});

  @override
  State<Conseilpage> createState() => _ConseilpageState();
}

class _ConseilpageState extends State<Conseilpage> {
  final ConseilService _conseilService = ConseilService();

  // Fonction pour ouvrir un popup de confirmation de suppression
  Future<void> _showDeleteConfirmationDialog(Conseil conseil) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${conseil.titre}?"),
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
                // Supprimer le conseil de Firebase
                await _conseilService.supprimerConseil(conseil.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Conseil? conseil}) async {
    final TextEditingController titreController =
        TextEditingController(text: conseil?.titre ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: conseil?.description ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              conseil == null ? 'Ajouter un conseil' : 'Modifier un conseil'),
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
                  keyboardType: TextInputType.number,
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
                if (conseil == null) {
                  // Ajouter un nouveau conseil dans la base de données
                  await _conseilService.ajouterConseil(Conseil(
                      id: '', // Firebase génère l'ID
                      titre: titreController.text,
                      description: descriptionController.text));
                } else {
                  // Modifier un enfant existant dans la base de données
                  await _conseilService.modifierConseil(
                    conseil.id,
                    Conseil(
                        id: conseil.id,
                        titre: titreController.text,
                        description: descriptionController.text),
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
                      'Conseils',
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
                child: StreamBuilder<List<Conseil>>(
                  stream: _conseilService.getConseils(),
                  builder: (BuildContext context, AsyncSnapshot<List<Conseil>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erreur lors du chargement des conseils.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final conseils = snapshot.data ?? [];

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
                                  DataColumn(label: Text('Titre')),
                                  DataColumn(label: Text('Description')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: List<DataRow>.generate(conseils.length,(index) {
                                  final conseil = conseils[index];

                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(conseil.titre)),
                                    DataCell(Text(conseil.description)),
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
                                                  conseil);
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
