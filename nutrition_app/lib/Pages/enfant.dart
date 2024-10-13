import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Services/enfant_service.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:nutrition_app/Pages/Accueil/accueil.dart';

class EnfantPage extends StatefulWidget {
  const EnfantPage({super.key});

  @override
  State<EnfantPage> createState() => _EnfantPageState();
}

class _EnfantPageState extends State<EnfantPage> {
  final EnfantService _enfantService = EnfantService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/notification'),
                  child: const Icon(
                    Icons.notifications,
                    color: Color(0xFFFB7129),
                  ),
                ),
              ],
            ),
          ),
          const Text('Liste des enfants',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Enfant>>(
              future: _enfantService.recupererEnfantsPourUtilisateur(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erreur lors du chargement'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun enfant trouvé'));
                }

                List<Enfant> enfants = snapshot.data!;

                return ListView.builder(
                  itemCount: enfants.length,
                  itemBuilder: (context, index) {
                    Enfant enfant = enfants[index];
                    return InkWell(
                      onTap: () {
                        // Naviguer vers la page Accueil avec l'ID de l'enfant
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Accueil(enfantId: enfant.id!),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(enfant.nomPrenom),
                          subtitle: Text(
                              'Poids: ${enfant.poids} kg, Taille: ${enfant.taille} cm'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _afficherPopupAjoutEnfant(context,
                                      enfant: enfant);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _enfantService.supprimerEnfant(enfant.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _afficherPopupAjoutEnfant(context);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _afficherPopupAjoutEnfant(BuildContext context, {Enfant? enfant}) {
    bool estModification = enfant != null;

    final TextEditingController _nomPrenomController = TextEditingController(text: estModification ? enfant.nomPrenom : '');
    final TextEditingController _dateDeNaissanceController =TextEditingController(
            text: estModification
                ? enfant.dateDeNaissance.toIso8601String().substring(0, 10)
                : '');
    final TextEditingController _poidsController = TextEditingController(
        text: estModification ? enfant.poids.toString() : '');
    final TextEditingController _tailleController = TextEditingController(
        text: estModification ? enfant.taille.toString() : '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              estModification ? 'Modifier l\'enfant' : 'Ajouter un enfant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomPrenomController,
                decoration: const InputDecoration(labelText: 'Nom et Prénom'),
              ),
              TextField(
                controller: _dateDeNaissanceController,
                decoration: const InputDecoration(
                    labelText: 'Date de naissance (YYYY-MM-DD)'),
              ),
              TextField(
                controller: _poidsController,
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _tailleController,
                decoration: const InputDecoration(labelText: 'Taille (cm)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                String nomPrenom = _nomPrenomController.text;
                double poids = double.parse(_poidsController.text);
                double taille = double.parse(_tailleController.text);
                DateTime dateDeNaissance =
                    DateTime.parse(_dateDeNaissanceController.text);

                if (estModification) {
                  enfant.nomPrenom = nomPrenom;
                  enfant.poids = poids;
                  enfant.taille = taille;
                  enfant.dateDeNaissance = dateDeNaissance;
                  enfant.age = DateTime.now().year - dateDeNaissance.year;

                  _enfantService
                      .modifierEnfant(enfant)
                      .then((_) => Navigator.pop(context))
                      .catchError((error) {
                    print('Erreur lors de la modification: $error');
                  });
                } else {
                  Enfant nouvelEnfant = Enfant(
                    nomPrenom: nomPrenom,
                    poids: poids,
                    taille: taille,
                    imc: poids / ((taille * taille) / 100),
                    dateDeNaissance: dateDeNaissance,
                    age: DateTime.now().year - dateDeNaissance.year,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  );

                  _enfantService.ajouterEnfant(nouvelEnfant).then((_) {
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Erreur lors de l\'ajout: $error');
                  });
                }
              },
              child: Text(estModification ? 'Modifier' : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
