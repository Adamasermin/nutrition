import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  final String verificationId;
  final String? nomPrenom; // Nullable car utilisé uniquement pour l'inscription
  final bool isSignUp;

  const Verification({
    super.key,
    required this.verificationId,
    this.nomPrenom,
    required this.isSignUp,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _codeController = TextEditingController();
  String? _erreurMessage;

  void _verifyCode() async {
    String code = _codeController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: code,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;

      if (widget.isSignUp && widget.nomPrenom != null) {
        // Si c'est une inscription, on met à jour le profil avec nom et prénom
        await user?.updateProfile(displayName: widget.nomPrenom);
        await user?.reload();
      }

      // Redirection vers la page d'accueil
      Navigator.pushNamed(context, '//splash2');
    } catch (e) {
      setState(() {
        _erreurMessage = "Code de vérification incorrect.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vérification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Veuillez entrer le code de vérification envoyé par SMS.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Code de vérification"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: const Text("Vérifier"),
            ),
            if (_erreurMessage != null)
              Text(
                _erreurMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
