import 'package:dashboard_nutrition/Widgets/bar_de_recherche_widget.dart';
import 'package:flutter/material.dart';

class Conseilpage extends StatelessWidget {
  const Conseilpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex:1, child: BarDeRechercheWidget()),
        Expanded(flex: 10, child: Container(color: Colors.amber,),)
      ],
    );
  }
}