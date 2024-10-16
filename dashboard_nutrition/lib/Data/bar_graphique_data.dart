import 'package:dashboard_nutrition/Models/bar_graphique.dart';

class BarGraphiqueData {

  final data = [
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
    BarGraphique(x: 0, y: 1),
  ];

  final leftTitle = {
    0: '0%',
    20: '20%',
    40: '40%',
    60: '60%',
    80: '80%',
    100: '100%'
  };
  final bottomTitle = {
    0: 'Jan',
    10: 'Feb',
    20: 'Mar',
    30: 'Apr',
    40: 'May',
    50: 'Jun',
    60: 'Jul',
    70: 'Aug',
    80: 'Sep',
    90: 'Oct',
    100: 'Nov',
    110: 'Dec',
  };
}