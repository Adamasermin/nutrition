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
        BarDeRechercheWidget(),
        Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        HeaderWidget(),
                        Graphique_widget(),
                      ],
                    )),
                Expanded(flex: 3, child: Utilisateur())
              ],
            )),
      ],
    );
  }
}

// ignore: camel_case_types
class Graphique_widget extends StatelessWidget {
  const Graphique_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        flex: 4,
        child: BarGraphiqueWidget());
  }
}

class Utilisateur extends StatelessWidget {
  const Utilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = CardData();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GridView.builder(
            itemCount: cardData.card.length,
            physics: const NeverScrollableScrollPhysics(), 
            shrinkWrap: true, // Ajuste la taille du GridView à son contenu
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Ajustez le nombre de colonnes selon vos besoins
              crossAxisSpacing: 15, // Ajuste l'espacement horizontal
              mainAxisSpacing: 15, // Ajuste l'espacement vertical
              childAspectRatio: 1.6, // Ajuste le ratio de chaque élément (plus large)
            ),
            itemBuilder: (context, index) {
              final List<Color> colors = [
                const Color.fromARGB(242, 8, 144, 178),
                const Color.fromARGB(242, 90, 33, 182),
                const Color.fromARGB(242, 247, 166, 61),
              ];
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: colors[index % colors.length],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.03,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Couleur de l'ombre
                            ),
                          ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person),
                      ),
                    ),
                    Column(
                      children: [
                        Text(cardData.card[index].titre,
                            style: const TextStyle(fontSize: 16)),
                        Text(cardData.card[index].nombre,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.23,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFC6212), // Couleur de départ
                  Color.fromARGB(255, 237, 176, 143), // Couleur de fin
                ],
                begin: Alignment.topLeft, // Début du dégradé
                end: Alignment.topRight, // Fin du dégradé
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planifiez votre régime alimentaire cette semaine',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(168, 255, 255, 255)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

