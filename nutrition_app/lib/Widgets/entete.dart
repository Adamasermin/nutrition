import 'package:flutter/material.dart';

class Entete extends StatelessWidget implements PreferredSizeWidget{

  final String title;

  const Entete({super.key,  required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      
      title: Text(
        title,
        style: const TextStyle(color: Colors.black), // Optionnel, pour un meilleur contraste avec un AppBar blanc
      ),
      centerTitle: true,
      elevation: 0, // Ajoute l'effet shadow
      shadowColor: Colors.white, // Couleur de l'ombre*
      
      leading: IconButton(
        onPressed: () => Navigator.pop(context), 
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded, // Icone du bouton
          color: Colors.black, // Couleur de l'icone
          size: 20,
        )
      ),
    );
  }
  
  
  
}