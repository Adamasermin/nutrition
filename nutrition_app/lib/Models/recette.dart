class Recette {
  String id;
  String titre;
  String ingredients;
  String description;
  String instructions;
  String photo;
  bool estFavori; // Ajoutez ce champ

  Recette({
    required this.id,
    required this.titre,
    required this.ingredients,
    required this.description,
    required this.instructions,
    required this.photo,
    this.estFavori = false, // Valeur par défaut
  });

  factory Recette.fromMap(Map<String, dynamic> data, String id) {
    return Recette(
      id: id,
      titre: data['titre'],
      ingredients: data['ingredients'],
      description: data['description'],
      instructions: data['instructions'],
      photo: data['photo'],
      estFavori: data['estFavori'] ?? false, // Charger l'état favori
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'ingredients': ingredients,
      'description': description,
      'instructions': instructions,
      'photo': photo,
      'estFavori': estFavori, // Inclure l'état favori
    };
  }
}
