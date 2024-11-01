import 'package:flutter/material.dart';

class BarDeRechercheWidget extends StatelessWidget {
  const BarDeRechercheWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
            ),
            
            Container(
              margin: const EdgeInsets.only(right: 30),
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