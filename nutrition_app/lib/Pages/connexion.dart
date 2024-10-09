import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Services/firebase_auth_service.dart';
import 'package:nutrition_app/Widgets/entete.dart';


class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Entete(title: 'Connexion'),
      body: SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Première section de l'interface contenant le logo et le titre
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Affichage d'une image (logo) avec des dimensions spécifiques
                    Image.asset('assets/images/Logo.png', height: 100, width: 100,),
                    
                  ],
                ),
              ),
            ),
            // Deuxième section contenant les champs de saisie pour l'email et le mot de passe
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    // Champ de texte pour l'adresse e-mail
                    inputFile(label: 'Email', controller: _emailController),
                    // Champ de texte pour le mot de passe
                    inputFile(label: 'Mot de passe', obscureText: true ,controller: _motDePasseController),
                  ],
                ),
              ),
            ),
            // Troisième section contenant le bouton de connexion
            Expanded(
              flex: 5,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    // Appel de la méthode de connexion lors de la soumission
                    onPressed: _connexion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7A73D), // Couleur de fond du bouton
                      foregroundColor: Colors.white, // Couleur du texte du bouton
                      // minimumSize: const Size(300.0, 50.0), // Taille minimale du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Coins arrondis du bouton
                      ),
                    ),
                    child: const Text(
                      'Connectez-vous', // Texte du bouton
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

  void _connexion() async {

    // Récupération des valeurs des champs
    String email = _emailController.text;
    String motDePasse = _motDePasseController.text;

    // Vérification des champs obligatoires et connection de l'utilisateur
    User? user = await _auth.connexionParMail(email, motDePasse);

    if (user != null) {
      print('Utilisateur connecté avec succès');
      Navigator.pushNamed(context, '/accueil');
    } else {
      print('Erreur lors de la connexion');
    }
  }
}

Widget inputFile({label, obscureText = false, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color:Colors.black87
        ),

      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0,
          horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400
            ),

          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)
          )
        ),
      ),
      const SizedBox(height: 10,)
    ],
  );
}