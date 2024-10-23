import 'package:dashboard_nutrition/Data/card_data.dart';
import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:dashboard_nutrition/Widgets/bar_graphique_widget.dart';
import 'package:flutter/material.dart';

class ContenuWidget extends StatelessWidget {
  const ContenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Barre de recherche
        BarDeRechercheWidget(),

        // Contenu principal
        Expanded(
          flex: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne principale (header + graphique)
              Expanded(
                flex: 8,
                child: Column(
                  children: [

                    Expanded(
                      flex: 2,
                      child: HeaderWidget()
                    ), // Bannière de la planification alimentaire
                    
                    // Graphique des IMC
                    Expanded(
                      flex: 4,
                      child: BarGraphiqueWidget()
                    ),

                  ],
                ),
              ),
              Expanded(flex: 3, child: Utilisateur()),
            ],
          ),
        ),
      ],
    );
  }
}


// Cartes des utilisateurs
class Utilisateur extends StatelessWidget {
  const Utilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = CardData();

    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        itemCount: cardData.card.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Une seule colonne pour chaque carte
          crossAxisSpacing: 15, 
          mainAxisSpacing: 15, 
          childAspectRatio: 1.6, // Ratio de la taille des cartes
        ),
        itemBuilder: (context, index) {
          final List<Color> colors = [
            const Color.fromARGB(242, 8, 144, 178), // Enfants inscrits
            const Color.fromARGB(242, 90, 33, 182), // Parents actifs
            const Color.fromARGB(242, 247, 166, 61), // Nutritionnistes
          ];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: colors[index % colors.length],
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardData.card[index].titre,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      cardData.card[index].nombre,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// Header de la page
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.23,
      margin: const EdgeInsets.only(right: 20, top: 29, left: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Découvrez des recettes locales adaptées à votre enfant',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
