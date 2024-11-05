import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_app/Models/enfant.dart';
import 'package:nutrition_app/Services/enfant_service.dart';

class Inscription_enfant extends StatefulWidget {
  const Inscription_enfant({super.key});

  @override
  State<Inscription_enfant> createState() => _Inscription_enfantState();
}

class _Inscription_enfantState extends State<Inscription_enfant> {
  final TextEditingController _nomPrenomController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final EnfantService _enfantService = EnfantService();

  File? _imageFile;

  // Fonction pour sélectionner une image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> ajouterEnfant() async {
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
        double poids = double.parse(_poidsController.text);
        double taille = double.parse(_tailleController.text) / 100;

        double imc = poids / (taille * taille);

        Enfant enfant = Enfant(
          nomPrenom: _nomPrenomController.text,
          dateDeNaissance: DateTime.parse(_dateNaissanceController.text),
          age: DateTime.now().year -
              DateTime.parse(_dateNaissanceController.text).year,
          poids: poids,
          taille: taille * 100,
          imc: imc,
          userId: utilisateurConnecte.uid,
        );

        await _enfantService.ajouterEnfant(enfant);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Données de l’enfant ajoutées avec succès')),
        );

        _nomPrenomController.clear();
        _dateNaissanceController.clear();
        _poidsController.clear();
        _tailleController.clear();

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
      backgroundColor: Colors.white,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: const Center(
                  child: Text(
                    'Entrez les données de l’enfant',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF7A73D),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(bottom: 30),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _imageFile == null
                              ? 'Image (optionnel)'
                              : 'Image sélectionnée',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload,
                                          color: Color(0xFFF7A73D)),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFF7A73D), // Couleur orange
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _pickImage,
                                child: const Text('Importer image'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
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
      const SizedBox(height: 5),
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
      const SizedBox(height: 10),
    ],
  );
}
