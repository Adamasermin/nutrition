import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/Models/conseil.dart';



class ConseilService {
  final CollectionReference conseilsCollection = FirebaseFirestore.instance.collection('conseils');
  

  // Afficher les conseils
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

  // Créer un conseil
  Future<void> ajouterConseil(Conseil conseil) {
    return conseilsCollection.add({
      'titre': conseil.titre,
      'description': conseil.description,
    });
  }

  // Modifier un conseil
  Future<void> modifierConseil(String id, Conseil conseil) {
    return conseilsCollection.doc(id).update({
      'titre': conseil.titre,
      'description': conseil.description,
    });
  }

  // Supprimer un conseil
  Future<void> supprimerConseil(String id) {
    return conseilsCollection.doc(id).delete();
  }
}