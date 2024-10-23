import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_nutrition/Models/recette.dart';

class RecetteService {
  final CollectionReference recettesCollection = FirebaseFirestore.instance.collection('recettes');

  // Afficher les recettes
  Stream<List<Recette>> getRecettes() {
    return recettesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recette(
          id: doc.id,
          titre: doc['titre'],
          description: doc['description'], 
          ingredients: doc['ingredients'], 
          instructions: doc['instructions'], 
          photo: doc['photo'],
        );
      }).toList();
    });
  }

  // Créer une recette
  Future<void> ajouterRecette(Recette recette) {
    return recettesCollection.add({
      'titre': recette.titre,
      'description': recette.description,
      'ingredients': recette.ingredients,
      'instructions':recette.instructions,
      'photo': recette.photo,
    });
  }

  // Modifier une recette
  Future<void> modifierRecette(String id, Recette recette) {
    return recettesCollection.doc(id).update({
      'titre': recette.titre,
      'description': recette.description,
      'ingredients': recette.ingredients,
      'instructions': recette.instructions,
      'photo': recette.photo,
    });
  }

  // Supprimer une recette
  Future<void> supprimerRecette(String id) {
    return recettesCollection.doc(id).delete();
  }
}