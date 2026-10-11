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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Person Info & Point status
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: Text(
                    'P${person.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        '১০টি গাছ • রো-তে ৩টি করে • ১ম ঘরে শুধু পয়েন্ট',
                        style: TextStyle(
                          fontSize: 11,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: hasMark ? const Color(0xFF1E3A8A) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasMark ? AppColors.badgeBg : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasMark ? Icons.stars_rounded : Icons.star_border_rounded,
                          size: 15,
                          color: hasMark ? Colors.amberAccent : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasMark ? 'পয়েন্ট: $mark' : 'পয়েন্ট বাকি',
                          style: TextStyle(
                            fontSize: 12,
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

          // 11 Cells Grid:
          // Cell 0: PointBoxWidget (ONLY Point, NO image as requested!)
          // Cells 1 to 10: 10 Plant images (3 per row)
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 11, // 1 point box + 10 plant images
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 per row as requested ("row te tin ta kore")
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.90,
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

          // 1 to 10 Points Selector Bar for this Person
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${person.name} এর জন্য পয়েন্ট দিন (১ - ১০):',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Obx(() {
                      final currentMark = person.mark.value;
                      return Text(
                        currentMark != null
                            ? 'সিলেক্টেড: $currentMark (১ম ঘরে)'
                            : 'কোনো পয়েন্ট দেওয়া হয়নি',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: currentMark != null ? AppColors.primary : Colors.grey.shade500,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),

                // 1 to 10 Numbers Row
                Obx(() {
                  final activeMark = person.mark.value;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: controller.availableNumbers.map((number) {
                        final isSelected = activeMark == number;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: InkWell(
                            onTap: () => controller.applyMarkToPerson(person, number),
                            borderRadius: BorderRadius.circular(22),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 44,
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
                                    fontSize: 16,
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
