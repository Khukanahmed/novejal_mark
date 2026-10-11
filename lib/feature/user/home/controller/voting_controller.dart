import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/plant_model.dart';
import '../model/person_model.dart';

class VotingController extends GetxController {
  // Available points (1 to 10)
  final List<int> availableNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // 5 persons list
  final RxList<PersonModel> persons = <PersonModel>[].obs;

  // Currently previewed plant index in large dialog (0 to 9)
  final RxInt currentPreviewPlantIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    // 10 distinct plant / bonsai / tree image URLs
    final List<String> plantImages = [
      'https://images.unsplash.com/photo-1512428813834-c702c7702b78?w=800&q=80', // Bonsai
      'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=800&q=80', // Potted plant
      'https://images.unsplash.com/photo-1509423350716-97f9360b4e09?w=800&q=80', // Leaf plant
      'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=800&q=80', // Succulent
      'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=800&q=80', // Indoor green
      'https://images.unsplash.com/photo-1545241047-6083a3684587?w=800&q=80', // House plant
      'https://images.unsplash.com/photo-1463936575829-25148e1db1b8?w=800&q=80', // Cactus
      'https://images.unsplash.com/photo-1520412099551-62b6bafeb5bb?w=800&q=80', // Monstera
      'https://images.unsplash.com/photo-1517196084881-c37a6b083b48?w=800&q=80', // Fern
      'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=800&q=80', // Ficus bonsai
    ];

    final List<PersonModel> loadedPersons = [];

    for (int p = 1; p <= 5; p++) {
      final List<PlantModel> plants = [];
      for (int i = 1; i <= 10; i++) {
        plants.add(
          PlantModel(
            id: i,
            title: 'গাছ #$i',
            imageUrl: plantImages[(i - 1 + (p - 1) * 2) % plantImages.length],
          ),
        );
      }

      // Person 1 gets default mark 3 as drawn in user sketch
      loadedPersons.add(
        PersonModel(
          id: p,
          name: 'ইউজার $p',
          plants: plants,
          initialMark: p == 1 ? 3 : null,
        ),
      );
    }

    persons.assignAll(loadedPersons);
  }

  /// Apply point directly to a specific person
  /// The point appears on their 1st box
  void applyMarkToPerson(PersonModel person, int markValue) {
    if (person.mark.value == markValue) {
      person.clearMark();
      Get.snackbar(
        'পয়েন্ট বাতিল',
        '${person.name} এর ১ম ঘর থেকে পয়েন্ট মুছে ফেলা হয়েছে।',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1200),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    } else {
      person.setMark(markValue);
      Get.snackbar(
        'পয়েন্ট দেওয়া হয়েছে!',
        '${person.name} এর ১ম ঘরে $markValue পয়েন্ট যুক্ত হয়েছে।',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2563EB),
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1200),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }

  /// Reset points for all 5 persons
  void resetAllMarks() {
    for (var person in persons) {
      person.clearMark();
    }
    Get.snackbar(
      'সকল পয়েন্ট রিসেট',
      'সকল ৫ জন ইউজারের পয়েন্ট মুছে দেওয়া হয়েছে।',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepOrange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }

  /// Large preview navigation
  void nextPreviewPlant(PersonModel person) {
    if (currentPreviewPlantIndex.value < person.plants.length - 1) {
      currentPreviewPlantIndex.value++;
    }
  }

  void previousPreviewPlant(PersonModel person) {
    if (currentPreviewPlantIndex.value > 0) {
      currentPreviewPlantIndex.value--;
    }
  }

  /// Count of persons who received marks
  int get markedPersonsCount =>
      persons.where((p) => p.mark.value != null).length;
}
