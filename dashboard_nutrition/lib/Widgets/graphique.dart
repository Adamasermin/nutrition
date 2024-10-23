import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graphique extends StatelessWidget {
  const Graphique({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BarChart(
        BarChartData(
          barGroups: _createBarGroups(),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jui', 'Aout', 'Sep', 'Oct', 'Nov', 'Dec'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(months[value.toInt()]),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // Exemple de données pour le graphique en barres
  List<BarChartGroupData> _createBarGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: 80, color: Colors.blue),
          BarChartRodData(toY: 70, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 60, color: Colors.orange),
          BarChartRodData(toY: 50, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 75, color: Colors.blue),
          BarChartRodData(toY: 65, color: Colors.orange),
          BarChartRodData(toY: 60, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: 90, color: Colors.blue),
          BarChartRodData(toY: 80, color: Colors.orange),
          BarChartRodData(toY: 70, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(toY: 60, color: Colors.blue),
          BarChartRodData(toY: 55, color: Colors.orange),
          BarChartRodData(toY: 45, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 85, color: Colors.blue),
          BarChartRodData(toY: 75, color: Colors.orange),
          BarChartRodData(toY: 65, color: Colors.purple),
        ],
      ),
    ];
  }
}
