import 'package:flutter/material.dart';

class Enfant extends StatelessWidget {
  const Enfant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Enfant',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        shadowColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          child: Column(children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                // Informations sur l'enfant
                title: const Text('Adama SERMIN'),
                // Boutons d'action
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
