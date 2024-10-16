import 'package:dashboard_nutrition/Const/constante.dart';
import 'package:dashboard_nutrition/Widgets/contenu_widget.dart';
import 'package:dashboard_nutrition/Widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgCouleur,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                child: SideMenuWidget()
              )
            ),
            Expanded(
              flex: 9,
              child: ContenuWidget(
              )
            ),
          ],
        )
      ),
    );
  }
}