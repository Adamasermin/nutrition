import 'package:dashboard_nutrition/Pages/connexionPage.dart';
import 'package:dashboard_nutrition/Widgets/side_menu_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyATvebU3IGPEtIMbRoirT6bsBwgfeKxeuA', 
      appId: '1:67753090159:web:334141ceb57efeafd8c19a', 
      messagingSenderId: '67753090159', 
      projectId: 'gestion-nutrition'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard nutrition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      routes: {
        '/': (context) => const Connexionpage(),
        '/dashboard': (context) => const SideMenuWidget()
      },
    );
  }
}

