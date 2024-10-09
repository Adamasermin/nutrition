import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Démarrer un Timer qui va naviguer vers une autre page après 3 secondes
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // `SafeArea` assure que le contenu n'entre pas en collision avec les zones d'encoche, la barre de statut, etc.
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/Logo.png',
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
      ),
    );
  }
}
