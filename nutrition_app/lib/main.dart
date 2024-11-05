import 'package:firebase_app_check/firebase_app_check.dart';
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
import 'package:nutrition_app/Services/notification_service.dart';
import 'package:nutrition_app/Widgets/bar_de_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotifications();
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
  runApp(const MyApp());
}

Future<String?> getLastSelectedChildId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastSelectedChildId');
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/welcome': (context) => const Welcome(),
        '/inscription': (context) => const Inscription(),
        '/connexion': (context) => const Connexion(),
        '/splash2': (context) => const Splash2(),
        '/inscription-enfant': (context) => const Inscription_enfant(),
        '/accueil': (context) => const BarDeNavigation(),
        '/notification': (context) => const Notification_page(),
        '/profil': (context) => const Profil(),
        '/nutritioniste': (context) => const Nutritioniste(),
        '/recette': (context) => const RecettePage(),
        '/enfant': (context) => const EnfantPage(),
      },
    );
  }
}
