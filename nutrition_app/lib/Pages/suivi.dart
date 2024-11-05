import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Suivi extends StatelessWidget {
  final List<GrowthData> growthRecords = [
    GrowthData(date: 'Jan', weight: 10.0, height: 80.0),
    GrowthData(date: 'Feb', weight: 10.5, height: 81.0),
    GrowthData(date: 'Mar', weight: 11.0, height: 82.5),
    GrowthData(date: 'Apr', weight: 11.5, height: 83.0),
    GrowthData(date: 'May', weight: 12.0, height: 84.0),
  ];

   Suivi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi de Croissance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildGrowthChart()),
            SizedBox(height: 20),
            _evaluateNutritionalStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              _createLineData(
                'Poids',
                growthRecords.map((e) => e.weight).toList(),
                Colors.blue,
              ),
              _createLineData(
                'Taille',
                growthRecords.map((e) => e.height).toList(),
                Colors.green,
              ),
              _createLineData(
                'IMC',
                growthRecords.map((e) => e.bmi).toList(),
                Colors.red,
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) => Text(
                    growthRecords[value.toInt()].date,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) => Text(
                    value.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }

  LineChartBarData _createLineData(String label, List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      color: color,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _evaluateNutritionalStatus() {
    final latestRecord = growthRecords.last;
    String statusMessage;

    // Analyse simple de carences en fonction de l'IMC
    if (latestRecord.bmi < 15) {
      statusMessage = "Attention : Risque de carence détecté (IMC faible)";
    } else if (latestRecord.bmi > 18) {
      statusMessage = "Risque de surpoids, consultez un professionnel.";
    } else {
      statusMessage = "Statut normal, aucune carence détectée.";
    }

    return Text(
      statusMessage,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }
}

class GrowthData {
  final String date;
  final double weight; // poids en kg
  final double height; // taille en cm

  GrowthData({required this.date, required this.weight, required this.height});

  // Calcul de l'IMC
  double get bmi => weight / ((height / 100) * (height / 100));
}