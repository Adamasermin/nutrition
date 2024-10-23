import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_nutrition/Models/parent.dart';

class ParentService {
  final CollectionReference parentCollection = FirebaseFirestore.instance.collection('parents');

  // Afficher les parents
  Stream<List<Parent>> getParents() {
    return parentCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Parent(
          id: doc.id,  
          nomPrenom:  doc['nomPrenom'], 
          email:  doc['email'], 
          password:  doc['password'], 
          telephone:  doc['telephone'],
        );
      }).toList();
    });
  }

  // Créer un parent
  Future<void> ajouterParent(Parent parent) {
    return parentCollection.add({
      'nomPrenom': parent.nomPrenom,
      'email': parent.email,
      'password': parent.password,
      'telephone':parent.telephone,
    });
  }

  // Modifier un parent
  Future<void> modifierParent(String id, Parent parent) {
    return parentCollection.doc(id).update({
      'nomPrenom': parent.nomPrenom,
      'email': parent.email,
      'password': parent.password,
      'telephone': parent.telephone,
    });
  }

  // Supprimer un parent
  Future<void> supprimerParent(String id) {
    return parentCollection.doc(id).delete();
  }
}