// Définition de la classe Barindividuel, qui représente une barre individuelle pour un graphique.
class Barindividuel {
  final int x; // Propriété pour la valeur X, généralement utilisée comme une catégorie ou un identifiant.
  final double? y; // Propriété pour la valeur Y, représentant une mesure ou une quantité.

  // Constructeur de la classe Barindividuel, qui nécessite les valeurs x et y.
  Barindividuel({
    required this.x, // Le paramètre x est requis lors de la création d'une instance.
    required this.y, // Le paramètre y est également requis.
  });
}
