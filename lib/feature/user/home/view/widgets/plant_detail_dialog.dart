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
        final currentMark = person.mark.value;
        final hasMark = currentMark != null;

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 550),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // 1st box mark status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: hasMark ? AppColors.badgeBg : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasMark ? Icons.stars_rounded : Icons.star_border_rounded,
                            size: 16,
                            color: hasMark ? Colors.amberAccent : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasMark ? '১ম ঘর: $currentMark' : 'মার্ক নেই',
                            style: TextStyle(
                              color: hasMark ? Colors.white : Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${person.name} — ${plant.title}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '১০টি গাছের মধ্যে #${plantIndex + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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
                      borderRadius: BorderRadius.circular(4),
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: Image.network(
                          plant.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              color: Colors.grey.shade100,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
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
                          radius: 18,
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
                          radius: 18,
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

              // Bottom Point Selector (1 to 10)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${person.name} এর ১০টি গাছের জন্য পয়েন্ট দিন (১ম ঘরে বসবে):',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 1 to 10 buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.availableNumbers.map((number) {
                          final isSelected = currentMark == number;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: InkWell(
                              onTap: () => controller.applyMarkToPerson(person, number),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryDark
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2.5 : 1.2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.35),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    '$number',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
