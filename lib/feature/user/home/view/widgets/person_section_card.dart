import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novejal_mark/core/constants/app_colors.dart';
import 'package:novejal_mark/feature/user/home/model/person_model.dart';
import 'package:novejal_mark/feature/user/home/controller/voting_controller.dart';
import 'point_box_widget.dart';
import 'plant_grid_item.dart';

class PersonSectionCard extends StatelessWidget {
  final PersonModel person;

  const PersonSectionCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VotingController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 14,
                  child: Text(
                    'P${person.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        '১০টি গাছ • ১ম ঘরে শুধু পয়েন্ট',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Point Badge
                Obx(() {
                  final mark = person.mark.value;
                  final hasMark = mark != null;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: hasMark ? const Color(0xFF1B5E20) : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasMark ? AppColors.badgeBg : Colors.green.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasMark ? Icons.stars_rounded : Icons.star_border_rounded,
                          size: 13,
                          color: hasMark ? Colors.amberAccent : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          hasMark ? 'পয়েন্ট: $mark' : 'পয়েন্ট বাকি',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasMark ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // Compact 11-Cell Grid (1 point box + 10 plant boxes)
          // Designed so all 10 plants and the point box fit together on screen
          Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 11, // 1 point box + 10 plant images
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 per row
                crossAxisSpacing: 6, // compact spacing
                mainAxisSpacing: 6, // compact spacing
                childAspectRatio: 1.25, // compact height so all 10 fit together on screen
              ),
              itemBuilder: (context, gridIndex) {
                if (gridIndex == 0) {
                  // First box: Point ONLY, NO image
                  return PointBoxWidget(person: person);
                }

                // Remaining 10 boxes: Plant images
                final plantIndex = gridIndex - 1;
                final plant = person.plants[plantIndex];

                return PlantGridItem(
                  person: person,
                  plant: plant,
                  plantIndex: plantIndex,
                );
              },
            ),
          ),

          // Compact 1 to 10 Points Selector Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${person.name} এর পয়েন্ট (১-১০):',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Obx(() {
                      final currentMark = person.mark.value;
                      return Text(
                        currentMark != null
                            ? 'সিলেক্টেড: $currentMark (১ম ঘরে)'
                            : 'পয়েন্ট দিন',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: currentMark != null ? AppColors.primary : Colors.grey.shade500,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 6),

                // 1 to 10 Compact Buttons
                Obx(() {
                  final activeMark = person.mark.value;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: controller.availableNumbers.map((number) {
                        final isSelected = activeMark == number;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: InkWell(
                            onTap: () => controller.applyMarkToPerson(person, number),
                            borderRadius: BorderRadius.circular(18),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.35),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
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
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
