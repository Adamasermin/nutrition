import 'package:flutter/material.dart';

class Essai extends StatelessWidget {
  const Essai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7A73D),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              width: 50,
              height: 50,
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Bienvenue dans l\'application de suivi de la nutrition infantile !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7A73D),
                ),
              ),
              const SizedBox(height: 20),

              // Section des fonctionnalités principales
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'Suivi de croissance',
                    icon: Icons.show_chart,
                    color: Colors.green,
                    routeName: '/suivi_croissance',
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Recettes',
                    icon: Icons.restaurant_menu,
                    color: Colors.orange,
                    routeName: '/recettes',
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Nutritionistes',
                    icon: Icons.health_and_safety,
                    color: Colors.blue,
                    routeName: '/nutritionistes',
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Pédiatres',
                    icon: Icons.local_hospital,
                    color: Colors.pink,
                    routeName: '/pediatres',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Conseils et Recommandations
              const Text(
                'Conseils pour une alimentation saine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7A73D),
                ),
              ),
              const SizedBox(height: 10),
              _buildRecommendationCard(
                'Favorisez les produits locaux et riches en nutriments.',
              ),
              _buildRecommendationCard(
                'Privilégiez les repas équilibrés et adaptés aux besoins de votre enfant.',
              ),
              _buildRecommendationCard(
                'Respectez les intervalles entre les repas et les portions.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF7A73D),
        child: const Icon(Icons.person, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/profil');
        },
      ),
    );
  }

  // Widget pour construire les cartes des fonctionnalités
  Widget _buildFeatureCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required String routeName}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher les cartes de recommandations
  Widget _buildRecommendationCard(String text) {
    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFF7A73D)),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
