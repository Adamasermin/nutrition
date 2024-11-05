import 'package:flutter/material.dart';
import 'package:nutrition_app/Models/recette.dart';
import 'package:nutrition_app/Services/recette_service.dart';

class RecettePage extends StatefulWidget {
  const RecettePage({super.key});

  @override
  _RecettePageState createState() => _RecettePageState();
}

class _RecettePageState extends State<RecettePage> {
  final RecetteService _recetteService = RecetteService();
  List<Recette> _recettes = [];
  List<Recette> _recettesFiltrees = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _recupererRecettes();
  }

  void _recupererRecettes() {
    _recetteService.recupererRecette().listen((recettes) {
      setState(() {
        _recettes = recettes;
        _recettesFiltrees = recettes;
      });
    });
  }

  void _filtrerRecettes(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _recettesFiltrees = _recettes
          .where(
              (recette) => recette.titre.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _afficherPopupDetail(BuildContext context, Recette recette) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            recette.titre,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFFF7A73D),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Ingrédients :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(recette.ingredients),
              const SizedBox(height: 20),
              const Text(
                "Description :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(recette.description),
               const SizedBox(height: 20),
              const Text(
                "Instructions :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(recette.instructions),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Couleur d'arrière-plan
                foregroundColor: Colors.white, // Couleur du texte (optionnelle)
              ),
              child: const Text("Fermer"),
              onPressed: () {
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
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, top: 50),
            child: const Text(
              'Recettes',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: _filtrerRecettes,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Color.fromARGB(175, 149, 148, 148)),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: Color.fromARGB(175, 149, 148, 148),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: _recettesFiltrees.isEmpty
                ? const Center(child: Text('Aucune recette trouvée'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _recettesFiltrees.length,
                    itemBuilder: (context, index) {
                      final recette = _recettesFiltrees[index];
                      return GestureDetector(
                        onTap: () => _afficherPopupDetail(context, recette),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        recette.titre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        recette.description,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 100,
                                  child: Image.network(
                                    recette.photo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
