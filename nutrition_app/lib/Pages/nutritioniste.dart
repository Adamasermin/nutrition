import 'package:flutter/material.dart';

class Nutritioniste extends StatelessWidget {
  const Nutritioniste({super.key});

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
                  child: const TextField(
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(175, 149, 148, 148)),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: Color.fromARGB(175, 149, 148, 148),
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Column(
                children: [
                  Card(
                    color: Color(0xFFF9F3F3),
                    shadowColor: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image(
                            image: AssetImage('assets/images/docteur1.png'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligne les textes à gauche
                            children: [
                              Text(
                                'Dr. Adama SERMIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Expert en nutrition infantile',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                'Bamako',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFF7A73D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
