import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Utilisation de SafeArea pour s'assurer que le contenu n'est pas masqué par des éléments du système
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const Column(
              children: [
                // Titre de bienvenue
                Text(
                  'Bienvenue sur votre plateforme\n'
                  '                DENW-BALO',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFF7A73D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Texte explicatif centré
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Suivez la croissance\n'
                    'de votre enfant et recevez des\n'
                    'conseils personnalisés pour une \n'
                    'nutrition saine et adaptée.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Column(
              children: [
                // Bouton de connexion
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/connexion');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7A73D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Connexion',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Bouton d'inscription
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/inscription');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFF7A73D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Inscrivez-vous ici',
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
