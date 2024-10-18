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
}