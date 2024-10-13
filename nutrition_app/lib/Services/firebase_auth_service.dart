import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {


  FirebaseAuth _auth = FirebaseAuth.instance;

  //Création de compte Utilisateur
  Future<User?> creationParMail(String email, String motDePassse) async {

    try {

      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: motDePassse);
      User? user = credential.user;
      return user;

    } catch (e) {

      print('Erreur lors de la creation du compte');

    }

    return null;
  }

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