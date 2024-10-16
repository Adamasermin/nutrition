import 'package:dashboard_nutrition/Models/enfant.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Enfantpage extends StatelessWidget {
  const Enfantpage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    // decoration: BoxDecoration(
                    //     borderRadius:
                    //       const BorderRadius.all(Radius.circular(8)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.7), // Couleur de l'ombre
                    //         ),
                    //       ],
                    //   ),
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
                                  onPressed: () {
                                    // Action d'édition ici
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Action de suppression ici
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

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}
