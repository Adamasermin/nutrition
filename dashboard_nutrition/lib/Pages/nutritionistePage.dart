import 'package:dashboard_nutrition/Models/nutritioniste.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Nutritionistepage extends StatefulWidget {
  const Nutritionistepage({super.key});

  @override
  State<Nutritionistepage> createState() => _NutritionistepageState();
}

class _NutritionistepageState extends State<Nutritionistepage> {

  final List<Nutritioniste> nutritionistes = [
      Nutritioniste(id: 'id1', nomPrenom: 'nomPrenom', email: 'email', password: 'password', telephone: 'telephone', photo: 'photo'),
      Nutritioniste(id: 'id2', nomPrenom: 'nomPrenom', email: 'email', password: 'password', telephone: 'telephone', photo: 'photo'),
      Nutritioniste(id: 'id3', nomPrenom: 'nomPrenom', email: 'email', password: 'password', telephone: 'telephone', photo: 'photo'),
      Nutritioniste(id: 'id4', nomPrenom: 'nomPrenom', email: 'email', password: 'password', telephone: 'telephone', photo: 'photo'),
    ];

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
              onPressed: () {
                // Logique d'ajout ou de modification de l'enfant ici
                if (nutritioniste == null) {
                  // Ajouter un nouvel enfant
                  setState(() {
                    nutritionistes.add(Nutritioniste(
                      id: 'E00${nutritionistes.length + 1}',
                      nomPrenom: nomPrenomController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      telephone: telephoneController.text,
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
              onPressed: () {
                setState(() {
                  nutritionistes.remove(nutritioniste);
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
        const Expanded(
          flex:1, 
          child: BarDeRechercheWidget()
        ),
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
                        DataColumn(label: Text('Nom et Prenom')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Password')),
                        DataColumn(label: Text('Telephone')),
                        DataColumn(label: Text('Photo')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: nutritionistes.map((nutritionistes) {
                        return DataRow(cells: [
                          DataCell(Text(nutritionistes.id)),
                          DataCell(Text(nutritionistes.nomPrenom)),
                          DataCell(Text(nutritionistes.email)),
                          DataCell(Text(nutritionistes.password)),
                          DataCell(Text(nutritionistes.telephone)),
                          DataCell(Text(nutritionistes.photo)),
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
                                    _showDeleteConfirmationDialog(nutritionistes);
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