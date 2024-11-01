import 'package:dashboard_nutrition/Models/card.dart';
import 'package:dashboard_nutrition/Services/dashboard_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardData {

  final DashboardService _dashboardService = DashboardService();

  Future<List<UserCard>> getCardData() async {
    final int nombreEnfants = await _dashboardService.getNombreEnfants();
    final int nombreParents = await _dashboardService.getNombreParents();
    final int nombreNutritionistes = await _dashboardService.getNombreNutritionistes();

    // Retourner la liste des cartes avec les données récupérées depuis Firestore
    return [
      UserCard(icon: FontAwesomeIcons.child, titre: 'Enfants inscrits', nombre: nombreEnfants.toString()),
      UserCard(icon: FontAwesomeIcons.user, titre: 'Parents actifs', nombre: nombreParents.toString()),
      UserCard(icon: FontAwesomeIcons.userNurse, titre: 'Nutritionnistes', nombre: nombreNutritionistes.toString()),
    ];
  }
  
}