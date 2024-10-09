import 'package:flutter/material.dart';

class Splash2 extends StatelessWidget {
  const Splash2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Première section : Image de bébé en fond
            Expanded(
                flex: 1,
                child: Container(
                  // Définition de l'image de fond pour cette section
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/bebe.png'),
                    fit: BoxFit.cover,
                  )),
                )),
            // Deuxième section : Texte et bouton
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Centrage horizontal des éléments
                    children: [
                      const Text(
                        '  Une Nutrition\n'
                        'Equilibrée, La clé\n'
                        'D\'une Croissance \n'
                        '         Saine.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/inscription-enfant');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7A73D),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Next'),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
