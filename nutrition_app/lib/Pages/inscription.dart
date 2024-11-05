import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final TextEditingController _confirmerMotDePasseController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _erreurMessage;

  @override
  void dispose() {
    _nomPrenomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmerMotDePasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Entete(title: 'Inscription'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      inputFile(label: 'Nom et prénom', controller: _nomPrenomController),
                      inputFile(label: 'Email', controller: _emailController),
                      inputFile(label: 'Mot de passe', obscureText: true, controller: _motDePasseController),
                      inputFile(label: 'Confirmer le mot de passe', obscureText: true, controller: _confirmerMotDePasseController),
                      if (_erreurMessage != null)
                        Text(
                          _erreurMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: _inscription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7A73D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Inscrivez-vous'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _inscription() async {
    String nomPrenom = _nomPrenomController.text;
    String email = _emailController.text;
    String motDePasse = _motDePasseController.text;
    String confirmerMotDePasse = _confirmerMotDePasseController.text;

    setState(() {
      _erreurMessage = null;
    });

    if (motDePasse != confirmerMotDePasse) {
      setState(() {
        _erreurMessage = "Les mots de passe ne correspondent pas.";
      });
      return;
    }

    User? user = await _auth.creationParMail(email, motDePasse);

    if (user != null) {
      await user.updateProfile(displayName: nomPrenom);
      await user.reload();

      // Récupérer le token FCM
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Ajouter les informations de l'utilisateur à Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'nomPrenom': nomPrenom,
        'email': email,
        'createdAt': Timestamp.now(),
        'fcmToken': fcmToken, // Stocke le token FCM
      });

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
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
        ),
      ),
      const SizedBox(height: 10)
    ],
  );
}
