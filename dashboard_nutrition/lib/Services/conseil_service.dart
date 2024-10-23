import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_nutrition/Models/conseil.dart';

class ConseilService {
  final CollectionReference conseilsCollection = FirebaseFirestore.instance.collection('conseils');

  // Afficher les enfants
  Stream<List<Conseil>> getConseils() {
    return conseilsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Conseil(
          id: doc.id,
          titre: doc['titre'],
          description: doc['description'],
        );
      }).toList();
    });
  }

  // Créer un enfant
  Future<void> ajouterConseil(Conseil conseil) {
    return conseilsCollection.add({
      'titre': conseil.titre,
      'description': conseil.description,
    });
  }

  // Modifier un enfant
  Future<void> modifierConseil(String id, Conseil conseil) {
    return conseilsCollection.doc(id).update({
      'titre': conseil.titre,
      'description': conseil.description,
    });
  }

  // Supprimer un enfant
  Future<void> supprimerConseil(String id) {
    return conseilsCollection.doc(id).delete();
  }
}