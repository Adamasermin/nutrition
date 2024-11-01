import 'package:dashboard_nutrition/Models/menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenuData {
  final menu = <Menu>[
    Menu(icon: FontAwesomeIcons.house, titre: 'Dashboard'),
    Menu(icon: FontAwesomeIcons.childReaching, titre: 'Enfants'),
    Menu(icon: FontAwesomeIcons.lightbulb, titre: 'Conseils'),
    Menu(icon: FontAwesomeIcons.utensils, titre: 'Recettes'),
    Menu(icon: FontAwesomeIcons.userNurse, titre: 'Nutritionistes'),
    Menu(icon: FontAwesomeIcons.user, titre: 'Parents'),
    Menu(icon: FontAwesomeIcons.gear, titre: 'Profil'),
  ];
}