import 'package:dashboard_nutrition/Models/conseil.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Conseilpage extends StatefulWidget {
  const Conseilpage({super.key});

  @override
  State<Conseilpage> createState() => _ConseilpageState();
}

class _ConseilpageState extends State<Conseilpage> {

  final List<Conseil> conseils = [
      Conseil(id: 'id1', titre: 'Conseil 1', description: 'Description du conseil 1'),
      Conseil(id: 'id2', titre: 'Conseil 2', description: 'Description du conseil 2'),
      Conseil(id: 'id3', titre: 'Conseil 3', description: 'Description du conseil 3'),
      Conseil(id: 'id4', titre: 'Conseil 4', description: 'Description du conseil 4'),
    ];

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
              onPressed: () {
                setState(() {
                  conseils.remove(conseil);
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
  Future<void> _openFormPopup({Conseil? conseil}) async {
    final TextEditingController titreController = TextEditingController(text: conseil?.titre ?? '');
    final TextEditingController descriptionController = TextEditingController(text: conseil?.description ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(conseil == null ? 'Ajouter un conseil' : 'Modifier un conseil'),
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
              onPressed: () {
                // Logique d'ajout ou de modification de l'enfant ici
                if (conseil == null) {
                  // Ajouter un nouvel enfant
                  setState(() {
                    conseils.add(Conseil(
                      id: 'E00${conseils.length + 1}',
                      titre: titreController.text,
                      description: descriptionController.text,
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
        const Expanded(flex: 1, child: BarDeRechercheWidget()),
        Expanded(
          flex: 10,
          child: Column(
            children: [
              // Titre + Bouton Ajouter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: conseils.map((conseil) {
                        return DataRow(cells: [
                          DataCell(Text(conseil.id)),
                          DataCell(Text(conseil.titre)),
                          DataCell(Text(conseil.description)),
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
                                    _showDeleteConfirmationDialog(conseil);
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
      ],
    );
  }
}
