import 'package:get/get.dart';
import 'plant_model.dart';

class PersonModel {
  final int id;
  final String name;
  final List<PlantModel> plants;
  final Rx<int?> mark;

  PersonModel({
    required this.id,
    required this.name,
    required this.plants,
    int? initialMark,
  }) : mark = Rx<int?>(initialMark);

  void setMark(int? value) {
    mark.value = value;
  }

  void clearMark() {
    mark.value = null;
  }
}
