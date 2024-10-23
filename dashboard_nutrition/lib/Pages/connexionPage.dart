import 'package:dashboard_nutrition/Const/constante.dart';
import 'package:dashboard_nutrition/Services/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Connexionpage extends StatefulWidget {
  const Connexionpage({super.key});

  @override
  State<Connexionpage> createState() => _ConnexionpageState();
}

class _ConnexionpageState extends State<Connexionpage> {

  final AuthentificationService _auth = AuthentificationService();

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
      backgroundColor: couleurPrimaire,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image-connexion.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            )
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding:const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), 
                      spreadRadius:
                          2, // Taille de l'ombre (plus elle est grande, plus l'ombre se diffuse)
                      blurRadius: 10, // Flou de l'ombre
                      offset: const Offset(0, 5), // Décalage de l'ombre (X, Y)
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.09,
                                height: MediaQuery.of(context).size.height * 0.09,
                                child: Image.asset('assets/images/Logo.png')
                              ),
                              const Text(
                                'Connectez-vous au compte',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            // Champ de texte pour l'adresse e-mail
                            inputFile(
                              label: 'Email', 
                              controller: _emailController
                            ),
                            // Champ de texte pour le mot de passe
                            inputFile(
                              label: 'Mot de passe',
                              obscureText: true,
                              controller: _motDePasseController
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1, 
                        child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: ElevatedButton(
                            // Appel de la méthode de connexion lors de la soumission
                            onPressed: _connexion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF7A73D), 
                              foregroundColor: Colors.white, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), 
                              ),
                            ),
                            child: const Text(
                              'Connectez-vous',
                            ),
                          ),
                        ),
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      Navigator.pushNamed(context, '/dashboard');
    } else {
      print('Erreur lors de la connexion');
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
