import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/Models/recette.dart';

class RecetteService {
  final CollectionReference recettesCollection =
      FirebaseFirestore.instance.collection('recettes');

  // Ajouter une recette avec génération automatique de l'ID
  Future<void> ajouterRecette(Recette recette) async {
    try {
      DocumentReference docRef = await recettesCollection.add(recette.toMap());
      recette.id = docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout de la recette: $e');
      throw Exception('Erreur lors de l\'ajout de la recette');
    }
  }

  // Modifier une recette
  Future<void> modifierRecette(Recette recette) async {
    try {
      await recettesCollection.doc(recette.id).update(recette.toMap());
    } catch (e) {
      print('Erreur lors de la modification de la recette: $e');
      throw Exception('Erreur lors de la modification de la recette');
    }
  }

  // Supprimer une recette
  Future<void> supprimerRecette(String id) async {
    try {
      await recettesCollection.doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de la recette: $e');
      throw Exception('Erreur lors de la suppression de la recette');
    }
  }

  // Récupérer la liste des recettes
  Stream<List<Recette>> recupererRecette() {
    return recettesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recette.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Méthode pour mettre à jour l'état favori d'une recette
  Future<void> sauvegarderFavori(Recette recette) async {
    try {
      await recettesCollection.doc(recette.id).update({'estFavori': recette.estFavori});
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'état favori: $e');
      throw Exception('Erreur lors de la sauvegarde de l\'état favori');
    }
  }

  // Nouvelle méthode pour récupérer uniquement les recettes favorites depuis Firestore
  Future<List<Recette>> recupererRecettesFavorites() async {
    try {
      QuerySnapshot querySnapshot = await recettesCollection
          .where('estFavori', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Recette.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des recettes favorites: $e');
      throw Exception('Erreur lors de la récupération des recettes favorites');
    }
  }
}
