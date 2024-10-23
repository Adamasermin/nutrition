import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_nutrition/Models/enfant.dart';

class EnfantService {

  final CollectionReference enfantsCollection = FirebaseFirestore.instance.collection('enfants');

  // Afficher les enfants
  Stream<List<Enfant>> getEnfants() {
    return enfantsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Enfant(
          id: doc.id,
          nomPrenom: doc['nomPrenom'],
          dateDeNaissance: (doc['dateDeNaissance'] as Timestamp).toDate(),
          taille: doc['taille'],
          poids: doc['poids'],
          imc: doc['imc'], 
          userId:doc['userId'],
        );
      }).toList();
    });
  }

  // Créer un enfant
  Future<void> ajouterEnfant(Enfant enfant) {
    return enfantsCollection.add({
      'nomPrenom': enfant.nomPrenom,
      'dateDeNaissance': enfant.dateDeNaissance,
      'taille': enfant.taille,
      'poids': enfant.poids,
      'imc': enfant.imc,
    });
  }

  // Modifier un enfant
  Future<void> modifierEnfant(String id, Enfant enfant) {
    return enfantsCollection.doc(id).update({
      'nomPrenom': enfant.nomPrenom,
      'dateDeNaissance': enfant.dateDeNaissance,
      'taille': enfant.taille,
      'poids': enfant.poids,
      'imc': enfant.imc,
    });
  }

  // Supprimer un enfant
  Future<void> supprimerEnfant(String id) {
    return enfantsCollection.doc(id).delete();
  }
}
