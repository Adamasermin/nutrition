

// Définition de la classe Donneebar, qui représente des données pour un graphique en barres
import 'package:nutrition_app/Pages/Accueil/Graphes/barIndividuel.dart';

class Donneebar {

  // Propriétés représentant les valeurs pour chaque jour de la semaine.
  final double lun; // Valeur pour le lundi.
  final double mar; // Valeur pour le mardi.
  final double mer; // Valeur pour le mercredi.
  final double jeu; // Valeur pour le jeudi.
  final double ven; // Valeur pour le vendredi.
  final double sam; // Valeur pour le samedi.
  final double dim; // Valeur pour le dimanche.

  // Constructeur de la classe Donneebar, qui nécessite les valeurs pour chaque jour de la semaine.
  Donneebar({
    required this.lun, // Le paramètre lun est requis lors de la création d'une instance.
    required this.mar, // Le paramètre mar est requis.
    required this.mer, // Le paramètre mer est requis.
    required this.jeu, // Le paramètre jeu est requis.
    required this.ven, // Le paramètre ven est requis.
    required this.sam, // Le paramètre sam est requis.
    required this.dim, // Le paramètre dim est requis.
  });

  // Liste pour stocker les objets Barindividuel, représentant les données à afficher dans le graphique.
  List<Barindividuel> donneeBar = [];

  // Méthode pour initialiser les données du graphique.
  void initialiseDonnee() {
    // Remplissage de la liste donneeBar avec des objets Barindividuel pour chaque jour de la semaine.
    donneeBar = [
      Barindividuel(x: 0, y: lun), // Lundi
      Barindividuel(x: 1, y: mar), // Mardi
      Barindividuel(x: 2, y: mer), // Mercredi
      Barindividuel(x: 3, y: jeu), // Jeudi
      Barindividuel(x: 4, y: ven), // Vendredi
      Barindividuel(x: 5, y: sam), // Samedi
      Barindividuel(x: 6, y: dim), // Dimanche
    ];
  }
}
