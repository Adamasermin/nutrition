import 'package:dashboard_nutrition/Models/enfant.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Enfantpage extends StatefulWidget {
  const Enfantpage({super.key});

  @override
  State<Enfantpage> createState() => _EnfantpageState();
}

class _EnfantpageState extends State<Enfantpage> {

  final List<Enfant> enfants = [
      Enfant(
          id: 'E001',
          nomPrenom: 'Adama SERMIN',
          dateDeNaissance: DateTime(2016, 1, 15),
          taille: '145',
          poids: '12',
          imc: '45'),
      Enfant(
          id: 'E002',
          nomPrenom: 'Sophie Brown',
          dateDeNaissance: DateTime(2016, 2, 25),
          taille: '140',
          poids: '13',
          imc: '42'),
      Enfant(
          id: 'E003',
          nomPrenom: 'John Carter',
          dateDeNaissance: DateTime(2016, 3, 12),
          taille: '150',
          poids: '14',
          imc: '46'),
    ];

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Enfant? enfant}) async {
    final TextEditingController nomPrenomController = TextEditingController(text: enfant?.nomPrenom ?? '');
    final TextEditingController tailleController = TextEditingController(text: enfant?.taille ?? '');
    final TextEditingController poidsController = TextEditingController(text: enfant?.poids ?? '');
    final TextEditingController imcController = TextEditingController(text: enfant?.imc ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(enfant == null ? 'Ajouter un enfant' : 'Modifier un enfant'),
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
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Enregistrer"),
              onPressed: () {
                // Logique d'ajout ou de modification de l'enfant ici
                if (enfant == null) {
                  // Ajouter un nouvel enfant
                  setState(() {
                    enfants.add(Enfant(
                      id: 'E00${enfants.length + 1}',
                      nomPrenom: nomPrenomController.text,
                      dateDeNaissance: DateTime.now(),
                      taille: tailleController.text,
                      poids: poidsController.text,
                      imc: imcController.text,
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

  // Fonction pour ouvrir un popup de confirmation de suppression
  Future<void> _showDeleteConfirmationDialog(Enfant enfant) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${enfant.nomPrenom}?"),
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
                  enfants.remove(enfant);
                });
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
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 50),
                child: const Text(
                  'Liste des enfants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // 90% de la largeur de l'écran
                    height: MediaQuery.of(context).size.height * 1, // Hauteur fixe du tableau
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nom et Prenom')),
                        DataColumn(label: Text('Date de naissance')),
                        DataColumn(label: Text('Taille')),
                        DataColumn(label: Text('Poids')),
                        DataColumn(label: Text('IMC')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: enfants.map((enfant) {
                        return DataRow(cells: [
                          DataCell(Text(enfant.id)),
                          DataCell(Text(enfant.nomPrenom)),
                          DataCell(Text(formatDate(enfant.dateDeNaissance))),
                          DataCell(Text(enfant.taille)),
                          DataCell(Text(enfant.poids)),
                          DataCell(Text(enfant.imc)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: _openFormPopup
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed:() {_showDeleteConfirmationDialog(enfant);}
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

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}
