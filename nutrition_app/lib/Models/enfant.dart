import 'package:cloud_firestore/cloud_firestore.dart';

class Enfant {

  String? id;
  String nomPrenom;
  DateTime dateDeNaissance;
  double poids;
  double taille;
  int? age;
  double? imc;
  String userId;

  Enfant({
  this.id, 
  required this.nomPrenom, 
  required this.dateDeNaissance, 
  required this.poids,
  required this.taille,
  this.age,
  this.imc,
  required this.userId,
  });

  // Convertir un enfant en map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'nomPrenom': nomPrenom,
      'dateDeNaissance': Timestamp.fromDate(dateDeNaissance),
      'poids': poids,
      'taille': taille,
      'age': age,
      'imc': imc,
      'userId': userId
    };
  }

  // Convertir une map de la base de données en objet enfant
  factory Enfant.fromMap(Map<String, dynamic> map, String documentId) {
    return Enfant(
      id: documentId,
      nomPrenom: map['nomPrenom'],
      dateDeNaissance: (map['dateDeNaissance'] as Timestamp).toDate(),
      poids: map['poids'],
      taille: map['taille'],
      age: map['age'],
      imc: map['imc'],
      userId: map['userId']
    );
}
}