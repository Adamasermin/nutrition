import 'package:flutter/material.dart';

class BarDeRechercheWidget extends StatelessWidget {
  const BarDeRechercheWidget({super.key});

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