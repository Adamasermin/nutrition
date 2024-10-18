import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthentificationService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  //Connexion des utilisateurs
   Future<User?> connexionParMail(String email, String motDePasse) async {

    try {
      
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: motDePasse);
      return credential.user;

    } catch (e) {
      
       print('Erreur lors de la connexion au compte');

    }

    return null;
  }
  
  
}