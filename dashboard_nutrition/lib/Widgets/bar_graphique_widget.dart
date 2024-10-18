
import 'package:dashboard_nutrition/Widgets/graphique.dart';
import 'package:flutter/material.dart';

class BarGraphiqueWidget extends StatelessWidget {
  const BarGraphiqueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0),),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'imc moyens des enfants',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              // SizedBox(height: 20,),
              Expanded(
                flex: 7,
                child: Graphique()
              )
            ],
          ),
        )
    );
  }
}

