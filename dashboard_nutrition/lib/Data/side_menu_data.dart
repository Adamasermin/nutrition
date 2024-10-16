import 'package:dashboard_nutrition/Models/menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenuData {
  final menu = <Menu>[
    Menu(icon: FontAwesomeIcons.house, titre: 'Accueil'),
    Menu(icon: FontAwesomeIcons.childReaching, titre: 'Enfant'),
    Menu(icon: FontAwesomeIcons.lightbulb, titre: 'Conseil'),
    Menu(icon: FontAwesomeIcons.utensils, titre: 'Recette'),
    Menu(icon: FontAwesomeIcons.userNurse, titre: 'Nutritioniste'),
    Menu(icon: FontAwesomeIcons.user, titre: 'Parent'),
    Menu(icon: FontAwesomeIcons.gear, titre: 'Parametre'),
  ];
}