class Recette {

  String? id;
  String titre;
  String description;
  String ingredients;
  String instructions;
  String photo;

  Recette({
    this.id,
    required this.titre,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.photo,
  });

  // Convertir un objet recette en une map de la base de données
   Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'ingredients': ingredients,
      'photo': photo,
    };
  }

  // Convertir une map de la base de données en objet recette
  factory Recette.fromMap(Map<String, dynamic> map, String documentId) {
    return Recette(
      id: documentId,
      titre: map['titre'],
      description: map['description'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      photo: map['photo'], 
    );
}

}