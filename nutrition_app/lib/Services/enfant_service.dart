import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/enfant.dart';

class EnfantService {
  final CollectionReference enfantsCollection =
      FirebaseFirestore.instance.collection('enfants');

  // Ajouter un enfant avec génération automatique de l'ID
  Future<void> ajouterEnfant(Enfant enfant) async {
    try {
      DocumentReference docRef = await enfantsCollection.add(enfant.toMap());
      // Optionnel: Vous pouvez récupérer l'ID généré comme suit
      enfant.id = docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'enfant: $e');
      throw Exception('Erreur lors de l\'ajout de l\'enfant');
    }
  }

  // Modifier un enfant
  Future<void> modifierEnfant(Enfant enfant) async {
    try {
      await enfantsCollection.doc(enfant.id).update(enfant.toMap());
    } catch (e) {
      print('Erreur lors de la modification de l\'enfant: $e');
      throw Exception('Erreur lors de la modification de l\'enfant');
    }
  }

  // Supprimer un enfant
  Future<void> supprimerEnfant(String id) async {
    try {
      await enfantsCollection.doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de l\'enfant: $e');
      throw Exception('Erreur lors de la suppression de l\'enfant');
    }
  }

  

  // Récupérer la liste des enfants créés par l'utilisateur connecté
  Future<List<Enfant>> recupererEnfantsPourUtilisateur() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      QuerySnapshot querySnapshot = await enfantsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Conversion du Timestamp en DateTime
        Timestamp timestamp = data['dateDeNaissance'];

        return Enfant(
          id: doc.id,
          nomPrenom: data['nomPrenom'],
          dateDeNaissance: timestamp.toDate(),  // Conversion Timestamp -> DateTime
          age: data['age'],
          poids: data['poids'],
          taille: data['taille'],
          imc: data['imc'],
          userId: data['userId'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des enfants: $e');
      throw Exception('Erreur lors de la récupération des enfants');
    }
  }

  // Récupérer la liste des enfants
  Stream<List<Enfant>> recupererEnfants() {
    return enfantsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Enfant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Récupérer les enfants pour l'utilisateur connecté
  Future<List<Enfant>> recupererToutEnfantsPourUtilisateur() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      QuerySnapshot querySnapshot = await enfantsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Vérifie que data['dateDeNaissance'] est un Timestamp avant de le convertir
        Timestamp timestamp = data['dateDeNaissance'];

        return Enfant(
          id: doc.id,
          nomPrenom: data['nomPrenom'],
          dateDeNaissance: timestamp.toDate(),
          age: data['age'],
          poids: data['poids'],
          taille: data['taille'],
          imc: data['imc'],
          userId: data['userId'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des enfants: $e');
      throw Exception('Erreur lors de la récupération des enfants');
    }
  }

  // Récupérer un seul enfant pour l'utilisateur connecté (optionnel)
  Future<Enfant?> recupererEnfantPourUtilisateur() async {
    List<Enfant> enfants = await recupererEnfantsPourUtilisateur();
    return enfants.isNotEmpty ? enfants.first : null;
  }
}
