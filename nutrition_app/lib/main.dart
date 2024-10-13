import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_app/Pages/connexion.dart';
import 'package:nutrition_app/Pages/enfant.dart';
import 'package:nutrition_app/Pages/inscription.dart';
import 'package:nutrition_app/Pages/inscription_enfant.dart';
import 'package:nutrition_app/Pages/notification_page.dart';
import 'package:nutrition_app/Pages/nutritioniste.dart';
import 'package:nutrition_app/Pages/profil.dart';
import 'package:nutrition_app/Pages/recette.dart';
import 'package:nutrition_app/Pages/splash.dart';
import 'package:nutrition_app/Pages/splash2.dart';
import 'package:nutrition_app/Pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrition_app/Widgets/bar_de_navigation.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Nutrition App',

      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      // home: Profil(),

      routes: {
        '/': (context) => const Splash(),
        '/welcome': (context) => const Welcome(),
        '/inscription': (context) => const Inscription(),
        '/connexion': (context) => const Connexion(),
        '/splash2': (context) => const Splash2(),
        '/inscription-enfant': (context) => const Inscription_enfant(),
        '/notification': (context) => const Notification_page(),
        '/accueil': (context) => const BarDeNavigation(),
        '/profil': (context) => const Profil(),
        '/nutritioniste': (context) => const Nutritioniste(),
        '/recette': (context) => const Recette(),
        '/enfant': (context) => const EnfantPage(),
      },
    );
  }
}





