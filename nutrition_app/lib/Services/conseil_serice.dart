import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/Models/conseil.dart';

class ConseilService {
  final CollectionReference conseilsCollection = FirebaseFirestore.instance.collection('conseils');

  // Afficher tous les conseils
  Stream<List<Conseil>> getConseils() {
    return conseilsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Conseil(
          id: doc.id,
          titre: doc['titre'],
          description: doc['description'],
          userId: doc['userId'], // Assurez-vous d'inclure userId ici
        );
      }).toList();
    });
  }

  // Afficher les conseils par ID utilisateur
  Stream<List<Conseil>> getConseilsByUserId(String userId) {
    return conseilsCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Conseil(
          id: doc.id,
          titre: doc['titre'],
          description: doc['description'],
          userId: doc['userId'], // Inclure userId si nécessaire
        );
      }).toList();
    });
  }

  // Créer un conseil
  Future<void> ajouterConseil(Conseil conseil) {
    return conseilsCollection.add({
      'titre': conseil.titre,
      'description': conseil.description,
      'userId': conseil.userId, // Inclure userId lors de l'ajout
    });
  }

  // Modifier un conseil
  Future<void> modifierConseil(String id, Conseil conseil) {
    return conseilsCollection.doc(id).update({
      'titre': conseil.titre,
      'description': conseil.description,
      // Inclure userId si nécessaire
    });
  }

  // Supprimer un conseil
  Future<void> supprimerConseil(String id) {
    return conseilsCollection.doc(id).delete();
  }
}
