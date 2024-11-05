import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAuthService {


  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> saveUserToken(String userId) async {
    String? userToken = await FirebaseMessaging.instance.getToken();
    if (userToken != null) {
      await _firestore.collection('users').doc(userId).update({
        'token': userToken,
      });
    }
  }


}