import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/Widgets/entete.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  String _displayName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _displayName = _user.displayName ?? "Nom non disponible";
    _email = _user.email ?? "Email non disponible";
  }

  Future<void> deconnexion() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }

  void confirmationDeconnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous vraiment vous déconnecter ?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Confirmer"),
              onPressed: () async {
                Navigator.of(context).pop();
                await deconnexion();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editerProfil(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: _displayName);
    final TextEditingController emailController =
        TextEditingController(text: _email);
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom et Prénom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enregistrer'),
              onPressed: () async {
                String updatedName = nameController.text;
                String updatedEmail = emailController.text;
                String updatedPassword = passwordController.text;

                try {
                  if (_displayName != updatedName) {
                    await _user.updateDisplayName(updatedName);
                    setState(() {
                      _displayName = updatedName;
                    });
                  }
                  if (_email != updatedEmail) {
                    await _user.updateEmail(updatedEmail);
                    setState(() {
                      _email = updatedEmail;
                    });
                  }
                  if (updatedPassword.isNotEmpty) {
                    await _user.updatePassword(updatedPassword);
                  }
                } catch (e) {
                  print('Erreur de mise à jour : $e');
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Entete(title: 'Profil'),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.withOpacity(
                          0.2), 
                      child: const Icon(
                        Icons.person, 
                        size: 50,
                        color: Colors.black, 
                      ),
                    ),
                    Text(
                      _displayName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nom et Prénom",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _displayName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _email,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      editerProfil(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7A73D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(200, 35),
                    ),
                    child: const Text(
                      "Modifier le profil",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      confirmationDeconnexion(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF616161),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(200, 35),
                    ),
                    child: const Text(
                      "Déconnexion",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
