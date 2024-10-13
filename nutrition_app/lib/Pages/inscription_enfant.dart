import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:nutrition_app/Services/enfant_service.dart';

// ignore: camel_case_types, must_be_immutable
class Inscription_enfant extends StatefulWidget {
  const Inscription_enfant({super.key});

  @override
  State<Inscription_enfant> createState() => _Inscription_enfantState();
}

class _Inscription_enfantState extends State<Inscription_enfant> {
  // Contrôleurs pour les champs du formulaire
  final TextEditingController _nomPrenomController = TextEditingController();
  final TextEditingController _dateNaissanceController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();

  // Instance du service EnfantService
  final EnfantService _enfantService = EnfantService();

  // Fonction pour ajouter l'enfant dans Firestore via EnfantService
  Future<void> ajouterEnfant() async {
    // Récupérer l'utilisateur connecté
    User? utilisateurConnecte = FirebaseAuth.instance.currentUser;

    if (utilisateurConnecte == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : utilisateur non connecté.')),
      );
      return;
    }

    if (_nomPrenomController.text.isNotEmpty &&
        _dateNaissanceController.text.isNotEmpty &&
        _poidsController.text.isNotEmpty &&
        _tailleController.text.isNotEmpty) {
      try {
        // Convertir les valeurs du poids et de la taille
        double poids = double.parse(_poidsController.text);
        double taille = double.parse(_tailleController.text) / 100; // Convertir en mètres

        // Calculer l'IMC
        double imc = poids / (taille * taille);

        // Créer l'objet Enfant avec l'IMC calculé
        Enfant enfant = Enfant(
          nomPrenom: _nomPrenomController.text,
          dateDeNaissance: DateTime.parse(_dateNaissanceController.text),
          age: DateTime.now().year - DateTime.parse(_dateNaissanceController.text).year,
          poids: poids,
          taille: taille * 100, // Convertir à nouveau en centimètres
          imc: imc,
          userId: utilisateurConnecte.uid, // Ajouter l'ID de l'utilisateur ici
        );

        // Appeler le service pour ajouter l'enfant
        await _enfantService.ajouterEnfant(enfant);

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Données de l’enfant ajoutées avec succès')),
        );

        // Réinitialiser le formulaire
        _nomPrenomController.clear();
        _dateNaissanceController.clear();
        _poidsController.clear();
        _tailleController.clear();

        // Rediriger vers la page d'accueil
        Navigator.pushReplacementNamed(context, '/accueil');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout des données : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            )),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          color: Colors.white,
          child: Column(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Entrez les données de l’enfant',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF7A73D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      inputFile(
                          label: 'Nom et Prenom',
                          controller: _nomPrenomController),
                      inputFile(
                          label: 'Date de naissance (YYYY-MM-DD)',
                          controller: _dateNaissanceController),
                      inputFile(label: 'Poids', controller: _poidsController),
                      inputFile(label: 'Taille', controller: _tailleController),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7A73D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(300.0, 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: ajouterEnfant,
                    child: const Text('Validez'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputFile({label, obscureText = false, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400))),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
