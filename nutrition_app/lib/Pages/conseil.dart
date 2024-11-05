import 'package:flutter/material.dart';
import 'package:nutrition_app/Services/conseil_serice.dart';
import 'package:nutrition_app/Widgets/entete.dart';
import 'package:nutrition_app/Models/conseil.dart';

class ConseilPage extends StatefulWidget {
  const ConseilPage({super.key});

  @override
  State<ConseilPage> createState() => _ConseilPageState();
}

class _ConseilPageState extends State<ConseilPage> {
  final ConseilService _conseilService = ConseilService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Entete(title: 'Conseils'),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder<List<Conseil>>(
          stream: _conseilService.getConseils(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun conseil disponible'));
            } else {
              final conseils = snapshot.data!;
              return ListView.builder(
                itemCount: conseils.length,
                itemBuilder: (context, index) {
                  final conseil = conseils[index];
                  return _buildRecommendationCard(conseil.titre, conseil.description);
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Widget pour afficher les cartes de recommandations avec titre et description
  Widget _buildRecommendationCard(String titre, String description) {
    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFF7A73D)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


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
