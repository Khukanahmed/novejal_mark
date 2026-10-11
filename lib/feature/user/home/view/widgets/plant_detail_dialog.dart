import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novejal_mark/core/constants/app_colors.dart';
import 'package:novejal_mark/feature/user/home/model/person_model.dart';
import 'package:novejal_mark/feature/user/home/controller/voting_controller.dart';

class PlantDetailDialog extends StatelessWidget {
  final PersonModel person;

  const PlantDetailDialog({super.key, required this.person});

  static void show(BuildContext context, PersonModel person, int initialIndex) {
    final controller = Get.find<VotingController>();
    controller.currentPreviewPlantIndex.value = initialIndex;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PlantDetailDialog(person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VotingController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Obx(() {
        final plantIndex = controller.currentPreviewPlantIndex.value;
        final plant = person.plants[plantIndex];

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clean Top Bar with Title & Close
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'গাছ #${plantIndex + 1} / ${person.plants.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Title
                    Expanded(
                      child: Text(
                        '${person.name} — ${plant.title}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Close Button
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Large Interactive Zoomable Image
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: Image.network(
                          plant.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 380,
                              color: Colors.grey.shade100,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 380,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Previous Button
                    if (plantIndex > 0)
                      Positioned(
                        left: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.chevron_left, color: Colors.white),
                            onPressed: () => controller.previousPreviewPlant(person),
                          ),
                        ),
                      ),

                    // Next Button
                    if (plantIndex < person.plants.length - 1)
                      Positioned(
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.chevron_right, color: Colors.white),
                            onPressed: () => controller.nextPreviewPlant(person),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
