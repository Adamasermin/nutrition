import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer le nombre total d'enfants inscrits
  Future<int> getNombreEnfants() async {
    QuerySnapshot enfantsSnapshot = await _firestore.collection('enfants').get();
    return enfantsSnapshot.size; // Retourne le nombre de documents dans la collection
  }

  // Récupérer le nombre total de parents actifs
  Future<int> getNombreParents() async {
    QuerySnapshot parentsSnapshot = await _firestore.collection('parents').get();
    return parentsSnapshot.size;
  }

  // Récupérer le nombre total de nutritionnistes
  Future<int> getNombreNutritionistes() async {
    QuerySnapshot nutritionistesSnapshot = await _firestore.collection('nutritionistes').get();
    return nutritionistesSnapshot.size;
  }
}