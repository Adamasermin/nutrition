import 'package:flutter/material.dart';

class Recette extends StatelessWidget {
  const Recette({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft, // Aligner à gauche
              padding: const EdgeInsets.only(left: 20, top: 50),
              child: const Text(
                'Recette',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
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
                    border: InputBorder.none),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height *
                  0.15, // Augmenter la hauteur pour plus d'espace
              width: double.infinity,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(
                            10), // Ajouter du padding autour du texte
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Delights with Greek yogurt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2, // Limiter à 2 lignes
                              overflow: TextOverflow
                                  .ellipsis, // Ajouter des points de suspension si le texte dépasse
                            ),
                            SizedBox(height: 5),
                            Text(
                              '6 Minutes - 200 Cal',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Courber les bords de l'image
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.4, // 40% de la largeur pour mieux gérer le texte
                        height: double
                            .infinity, // Remplir toute la hauteur disponible
                        child: Image.asset(
                          'assets/images/plat.png',
                          fit: BoxFit
                              .cover, // Ajuster l'image pour remplir le conteneur
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
