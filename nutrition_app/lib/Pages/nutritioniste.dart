import 'package:flutter/material.dart';
import 'package:nutrition_app/Models/nutritionniste.dart';
import 'package:nutrition_app/Pages/chat.dart';
import 'package:nutrition_app/Services/nutri_service.dart';

class Nutritioniste extends StatefulWidget {
  const Nutritioniste({super.key});

  @override
  _NutritionisteState createState() => _NutritionisteState();
}

class _NutritionisteState extends State<Nutritioniste> {
  final NutriService nutriService = NutriService();
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/notification'),
                    child: const Icon(
                      Icons.notifications,
                      color: Color(0xFFFB7129),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Liste des nutritionistes',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher par nom',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(175, 149, 148, 148),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                        color: Color.fromARGB(175, 149, 148, 148),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
            StreamBuilder<List<Nutritionniste>>(
              stream: nutriService.getNutritionistes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Aucun nutritionniste trouvé');
                } else {
                  final nutritionnistes = snapshot.data!
                      .where((nutritioniste) => nutritioniste.nomPrenom
                          .toLowerCase()
                          .contains(searchText))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: nutritionnistes.length,
                    itemBuilder: (context, index) {
                      final nutritioniste = nutritionnistes[index];
                      return GestureDetector(
                        onTap: () => detailsNutri(context, nutritioniste),
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          color: const Color(0xFFF9F3F3),
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      nutritioniste.photo,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.person, size: 80),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nutritioniste.nomPrenom,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Expert en nutrition infantile',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(
                                        nutritioniste.telephone,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFF7A73D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> detailsNutri(
      BuildContext context, Nutritionniste nutritioniste) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    nutritioniste.photo,
                    width: 200,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 150),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  nutritioniste.nomPrenom,
                  style: const TextStyle(
                    color: Color(0xFFF7A73D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email : ${nutritioniste.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Téléphone : ${nutritioniste.telephone}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Description: Spécialisé dans la nutrition infantile.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF7A73D),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Chat(nutritionistName: nutritioniste.nomPrenom),
                  ),
                );
              },
              child: const Text('Contactez'),
            ),
          ],
        );
      },
    );
  }
}
