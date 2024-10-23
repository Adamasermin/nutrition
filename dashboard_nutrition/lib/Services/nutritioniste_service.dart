import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_nutrition/Models/nutritioniste.dart';

class NutritionisteService {
  final CollectionReference nutriCollection = FirebaseFirestore.instance.collection('nutritionistes');

  // Afficher les nutritionistes
  Stream<List<Nutritioniste>> getNutritionistes() {
    return nutriCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Nutritioniste(
          id: doc.id,  
          nomPrenom:  doc['nomPrenom'], 
          email:  doc['email'], 
          password:  doc['password'], 
          telephone:  doc['telephone'],
          photo: doc['photo'],
        );
      }).toList();
    });
  }

  // Créer un nutritioniste
  Future<void> ajouterNutri(Nutritioniste nutritioniste) {
    return nutriCollection.add({
      'nomPrenom': nutritioniste.nomPrenom,
      'email': nutritioniste.email,
      'password': nutritioniste.password,
      'telephone':nutritioniste.telephone,
      'photo': nutritioniste.photo,
    });
  }

  // Modifier un nutritioniste
  Future<void> modifierNutri(String id, Nutritioniste nutritioniste) {
    return nutriCollection.doc(id).update({
      'nomPrenom': nutritioniste.nomPrenom,
      'email': nutritioniste.email,
      'password': nutritioniste.password,
      'telephone': nutritioniste.telephone,
      'photo': nutritioniste.photo,
    });
  }

  // Supprimer un nutritioniste
  Future<void> supprimerNutri(String id) {
    return nutriCollection.doc(id).delete();
  }
}