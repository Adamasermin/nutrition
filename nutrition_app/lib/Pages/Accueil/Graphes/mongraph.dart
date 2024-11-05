import 'package:fl_chart/fl_chart.dart'; 
import 'package:flutter/material.dart';
import 'package:nutrition_app/Pages/Accueil/Graphes/donneeBar.dart';



// Définition de la classe Mongraph, qui représente un graphique à barres.
class Mongraph extends StatelessWidget {

  final List mois; // Liste contenant les données hebdomadaires pour le graphique.

  // Constructeur de la classe Mongraph, qui nécessite une liste de données hebdomadaires.
  const Mongraph({
    super.key, // Utilisation de super.key pour la gestion des clés dans Flutter
    required this.mois, // Le paramètre donneHebdomadaire est requis lors de la création d'une instance.
  });
  
  @override
  Widget build(BuildContext context) {
    // Création d'une instance de Donneebar avec les données hebdomadaires fournies.
    Donneebar donneebar = Donneebar(
      jan: mois[0], 
      fev: mois[1], 
      mars: mois[2], 
      avr: mois[3],
      mai: mois[4], 
      jun: mois[5], 
      jui: mois[6],
      aout: mois[7],
      sep: mois[8],
      oct: mois[9],
      nov: mois[10],
      dec: mois[11],
    );

    // Initialisation des données pour le graphique.
    donneebar.initialiseDonnee();

    // Retourne un widget BarChart avec les données et les configurations spécifiées.
    return BarChart(
      BarChartData(
        maxY: 60, // Valeur maximale de l'axe Y
        minY: 0, // Valeur minimale de l'axe Y
        gridData: const FlGridData(show: false), // Masque la grille
        borderData: FlBorderData(show: false), // Masque les bordures
        titlesData: const FlTitlesData(
          show: true, // Affiche les titres
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Masque les titres en haut
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Masque les titres à gauche
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Masque les titres à droite
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Masque les titres en bas
        ),
        barGroups: donneebar.donneeBar // Liste des groupes de barres
        .map(
          (data) => BarChartGroupData(
            x: data.x, // Position X de la barre
            barRods: [
              BarChartRodData(
                toY: data.y ?? 0,
                color: Colors.black, // Couleur de la barre
                width: 15, // Largeur de la barre
                borderRadius: BorderRadius.circular(5), // Arrondi des coins de la barre
                backDrawRodData: BackgroundBarChartRodData(
                  show: true, // Affiche la barre de fond
                  toY: 60, // Hauteur de la barre de fond
                  color: const Color(0xFFE9EDF7) // Couleur de la barre de fond
                )
              ),
            ]
          )
        ).toList(), // Conversion de la liste en une liste de BarChartGroupData
    ));
  }
}

// Fonction pour créer des titres pour les jours de la semaine dans le graphique.
Widget jourSemaine(double value, TitleMeta titre) {
  const style = TextStyle(
    color: Colors.black, // Couleur du texte
    fontWeight: FontWeight.bold, // Gras
    fontSize: 14 // Taille de la police
  );

  Widget text; // Variable pour stocker le texte à afficher

  // Détermine le texte à afficher en fonction de la valeur (jour de la semaine).
  switch (value.toInt()) {
    case 0:
      text = const Text('J', style: style,); 
      break;
    case 1:
      text = const Text('F', style: style,);
      break;
    case 2:
      text = const Text('M', style: style,); 
      break;
    case 3:
      text = const Text('A', style: style,); 
      break;
    case 4:
      text = const Text('M', style: style,); 
      break;
    case 5:
      text = const Text('J', style: style,);
      break;
    case 6:
      text = const Text('J', style: style,);
      break;
    case 7:
      text = const Text('A', style: style,);
      break;
    case 8:
      text = const Text('S', style: style,);
      break;
    case 9:
      text = const Text('O', style: style,);
      break;
    case 10:
      text = const Text('N', style: style,);
      break;
    case 11:
      text = const Text('D', style: style,);
      break;
    default:
      text = const Text('', style: style,); // Si aucune correspondance, affiche un texte vide
      break;
  }

  // Retourne un widget SideTitleWidget pour afficher le texte du jour.
  return SideTitleWidget(axisSide: titre.axisSide, child: text);
}
