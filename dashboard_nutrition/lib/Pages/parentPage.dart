import 'package:dashboard_nutrition/Models/parent.dart';
import 'package:dashboard_nutrition/Services/parent_service.dart';
import 'package:flutter/material.dart';

class Parentpage extends StatefulWidget {
  const Parentpage({super.key});

  @override
  State<Parentpage> createState() => _ParentpageState();
}

class _ParentpageState extends State<Parentpage> {

  final ParentService _parentService = ParentService();

  // Fonction pour ouvrir le formulaire dans un popup
  Future<void> _openFormPopup({Parent? parent}) async {
    final TextEditingController nomPrenomController = TextEditingController(text: parent?.nomPrenom ?? '');
    final TextEditingController emailController = TextEditingController(text: parent?.email ?? '');
    final TextEditingController passwordController = TextEditingController(text: parent?.password ?? '');
    final TextEditingController telephoneController = TextEditingController(text: parent?.telephone ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(parent == null ? 'Ajouter un parent' : 'Modifier un parent'),
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
                if (parent == null) {
                   await _parentService.ajouterParent(Parent(
                      id: '', // Firebase génère l'ID
                      nomPrenom: nomPrenomController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      telephone: telephoneController.text,
                      ));
                } else {
                  await _parentService.modifierParent(
                    parent.id,
                    Parent(
                        id: parent.id,
                        nomPrenom: nomPrenomController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        telephone: telephoneController.text,
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
  Future<void> _showDeleteConfirmationDialog(Parent parent) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${parent.nomPrenom}?"),
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
                await _parentService.supprimerParent(parent.id);
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
                      'Parents',
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
                child: StreamBuilder<List<Parent>>(
                  stream: _parentService.getParents(),
                  builder: (BuildContext context, AsyncSnapshot<List<Parent>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erreur lors du chargement des parents.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final parents = snapshot.data ?? [];

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
                                rows: List<DataRow>.generate(parents.length,(index) {
                                  final parent = parents[index];

                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(parent.nomPrenom)),
                                    DataCell(Text(parent.email)),
                                    DataCell(Text(parent.telephone)),
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
                                                  parent);
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