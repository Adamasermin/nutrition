

// Définition de la classe Donneebar, qui représente des données pour un graphique en barres
import 'package:nutrition_app/Pages/Accueil/Graphes/barIndividuel.dart';

class Donneebar {

  // Propriétés représentant les valeurs pour chaque jour de la semaine.
  final double? jan; // Valeur pour le lundi.
  final double? fev; // Valeur pour le mardi.
  final double? mars; // Valeur pour le mercredi.
  final double? avr; // Valeur pour le jeudi.
  final double? mai; // Valeur pour le vendredi.
  final double? jun; // Valeur pour le samedi.
  final double? jui; // Valeur pour le dimanche.
  final double? aout; // Valeur pour le dimanche.
  final double? sep; // Valeur pour le dimanche.
  final double? oct; // Valeur pour le dimanche.
  final double? nov; // Valeur pour le dimanche.
  final double? dec; // Valeur pour le dimanche.


  // Constructeur de la classe Donneebar, qui nécessite les valeurs pour chaque jour de la semaine.
  Donneebar({
    this.jan, 
    this.fev, 
    this.mars, 
    this.avr, 
    this.mai, 
    this.jun, 
    this.jui, 
    this.aout, 
    this.sep, 
    this.oct, 
    this.nov, 
    this.dec, 
  
  });

  // Liste pour stocker les objets Barindividuel, représentant les données à afficher dans le graphique.
  List<Barindividuel> donneeBar = [];

  // Méthode pour initialiser les données du graphique.
  void initialiseDonnee() {
    // Remplissage de la liste donneeBar avec des objets Barindividuel pour chaque jour de la semaine.
    donneeBar = [
      Barindividuel(x: 0, y: jan), 
      Barindividuel(x: 1, y: fev), 
      Barindividuel(x: 2, y: mars), 
      Barindividuel(x: 3, y: avr), 
      Barindividuel(x: 4, y: mai), 
      Barindividuel(x: 5, y: jun), 
      Barindividuel(x: 6, y: jui),
      Barindividuel(x: 7, y: aout),
      Barindividuel(x: 8, y: sep),
      Barindividuel(x: 9, y: oct),
      Barindividuel(x: 10, y: nov), 
      Barindividuel(x: 11, y: dec),

    ];
  }
}
