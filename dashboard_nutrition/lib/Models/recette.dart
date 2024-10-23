class Recette {
  final String id;
  final String titre;
  final String description;
  final String ingredients;
  final String instructions;
  final String photo;

  Recette({
    required this.id, 
    required this.titre, 
    required this.description, 
    required this.ingredients, 
    required this.instructions, 
    required this.photo
  });

  // Convertir une recette en map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'photo': photo,
    };
  }

  // Convertir une map de la base de données en objet recette
  factory Recette.fromMap(Map<String, dynamic> map, String documentId) {
    return Recette(
      id: documentId,
      titre: map['titre'],
      description: (map['description']),
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      photo: map['photo'],
    );
}
}