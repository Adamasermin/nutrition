import 'package:dashboard_nutrition/Data/card_data.dart';
import 'package:flutter/material.dart';

class ContenuWidget extends StatelessWidget {
  const ContenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BarDeRecherche(),
        Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        const HeaderWidget(),
                        Expanded(
                            flex: 4,
                            child: Container(
                              color: Colors.black,
                            )),
                      ],
                    )),
                const Expanded(flex: 3, child: Utilisateur())
              ],
            )),
      ],
    );
  }
}

class Utilisateur extends StatelessWidget {
  const Utilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = CardData();

    return Container(
      padding: const EdgeInsets.all(20), // Ajoutez du padding si nécessaire
      // width: double.infinity,
      child: Column(
        children: [
          GridView.builder(
            itemCount: cardData.card.length,
            physics:
                const NeverScrollableScrollPhysics(), // Désactive le défilement
            shrinkWrap: true, // Ajuste la taille du GridView à son contenu
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:1, // Ajustez le nombre de colonnes selon vos besoins
              crossAxisSpacing: 15, // Ajuste l'espacement horizontal
              mainAxisSpacing: 15, // Ajuste l'espacement vertical
              childAspectRatio: 1.6, // Ajuste le ratio de chaque élément (plus large)
            ),
            itemBuilder: (context, index) {
              final List<Color> colors = [
                const Color.fromARGB(172, 8, 144, 178),
                const Color.fromARGB(172, 90, 33, 182),
                const Color.fromARGB(172, 247, 166, 61),
              ];
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(top:10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: colors[index % colors.length],
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.03,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: Colors.black, // Couleur de la bordure
                          width:0.5, // Épaisseur de la bordure
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.person),
                      ),
                    ),
                    Column(
                      children: [
                        Text(cardData.card[index].titre, style: const TextStyle(fontSize: 16)),
                        Text(cardData.card[index].nombre, style: const TextStyle(fontSize: 14)),
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

class BarDeRecherche extends StatelessWidget {
  const BarDeRecherche({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salut!!!',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text('Bienvenue'),
                    ],
                  ),
                )),
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(175, 149, 148, 148)),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25,
                      color: Color.fromARGB(175, 149, 148, 148),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/notification'),
                child: const Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 98, 98, 98),
                ),
              ),
            ),
          ],
        ));
  }
}
