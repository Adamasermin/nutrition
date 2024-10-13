import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Services/firebase_auth_service.dart';
import 'package:nutrition_app/Widgets/entete.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _nomPrenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmerMotDePasseController =
      TextEditingController(); // Nouveau contrôleur pour confirmer mot de passe

  String? _erreurMessage; // Pour afficher un message d'erreur

  @override
  void dispose() {
    _nomPrenomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmerMotDePasseController
        .dispose(); // Assurez-vous de libérer la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Entete(title: 'Inscription'),
      body: SafeArea(
        child: Container(
          color: Colors.white, // Couleur de fond du formulaire
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      inputFile(
                          label: 'Nom et prénom',
                          controller: _nomPrenomController),
                      inputFile(label: 'Email', controller: _emailController),
                      inputFile(
                          label: 'Mot de passe',
                          obscureText: true,
                          controller: _motDePasseController),
                      inputFile(
                          label: 'Confirmer le mot de passe',
                          obscureText: true,
                          controller: _confirmerMotDePasseController),
                      if (_erreurMessage !=
                          null) // Afficher l'erreur si elle existe
                        Text(
                          _erreurMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed:
                          _inscription, // Correction: supprimer `=>` pour appeler la fonction directement
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7A73D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Inscrivez-vous', // Texte du bouton
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _inscription() async {
    // Récupération des valeurs des champs
    String nomPrenom = _nomPrenomController.text; // Récupère le nom et prénom
    String email = _emailController.text;
    String motDePasse = _motDePasseController.text;
    String confirmerMotDePasse = _confirmerMotDePasseController.text;

    setState(() {
      _erreurMessage = null; // Réinitialiser l'erreur avant la validation
    });

    // Vérification si les mots de passe correspondent
    if (motDePasse != confirmerMotDePasse) {
      setState(() {
        _erreurMessage = "Les mots de passe ne correspondent pas.";
      });
      return; // Sortir de la fonction si les mots de passe ne correspondent pas
    }

    // Vérification des champs obligatoires et création de l'utilisateur
    User? user = await _auth.creationParMail(email, motDePasse);

    if (user != null) {
      // Mise à jour du profil de l'utilisateur avec le nom et prénom
      await user.updateProfile(displayName: nomPrenom);
      await user.reload(); // Recharge les informations utilisateur

      print('Utilisateur créé avec succès');
      Navigator.pushNamed(context, '/splash2');
    } else {
      setState(() {
        _erreurMessage = "Erreur lors de la création de l'utilisateur.";
      });
    }
  }
}

Widget inputFile({label, obscureText = false, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
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
              borderSide: BorderSide(color: Colors.grey.shade400)),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
