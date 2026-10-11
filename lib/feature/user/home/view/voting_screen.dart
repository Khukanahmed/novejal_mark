import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novejal_mark/core/constants/app_colors.dart';
import 'package:novejal_mark/feature/user/home/controller/voting_controller.dart';
import 'widgets/person_section_card.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VotingController());
    final scrollController = ScrollController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'গাছ পয়েন্ট সিস্টেম (৫ জন ইউজার)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '১ম ঘরে শুধু পয়েন্ট • বাকি ১০ ঘরে গাছ • স্ক্রোল করে ইউজার দেখুন',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Completed users badge
          Center(
            child: Obx(() {
              final markedCount = controller.markedPersonsCount;
              final total = controller.persons.length;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white38),
                ),
                child: Text(
                  '$markedCount/$total জন মার্কড',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),

          // Reset all points button
          IconButton(
            tooltip: 'সকল পয়েন্ট রিসেট',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              Get.defaultDialog(
                title: 'সকল পয়েন্ট রিসেট',
                middleText: 'আপনি কি সকল ৫ জন ইউজারের পয়েন্ট মুছে ফেলতে চান?',
                textConfirm: 'হ্যাঁ, মুছুন',
                textCancel: 'বাতিল',
                confirmTextColor: Colors.white,
                buttonColor: Colors.deepOrange,
                onConfirm: () {
                  Get.back();
                  controller.resetAllMarks();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Jump Bar for 5 Users
          Container(
            height: 46,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: 5,
              itemBuilder: (context, index) {
                final userNumber = index + 1;
                return Obx(() {
                  final person = controller.persons[index];
                  final hasPoint = person.mark.value != null;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      onPressed: () {
                        // Scroll to this user's section
                        scrollController.animateTo(
                          index * 580.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      avatar: CircleAvatar(
                        backgroundColor: hasPoint ? Colors.green.shade600 : Colors.grey.shade400,
                        radius: 7,
                        child: hasPoint
                            ? const Icon(Icons.check, size: 9, color: Colors.white)
                            : null,
                      ),
                      label: Text(
                        'ইউজার $userNumber ${hasPoint ? "(${person.mark.value})" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: hasPoint ? AppColors.primary : Colors.grey.shade700,
                        ),
                      ),
                      backgroundColor: hasPoint
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      side: BorderSide(
                        color: hasPoint ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          const Divider(height: 1),

          // Scrollable List of 5 Users
          // Scroll down to see next user's trees & point box as requested
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(top: 6, bottom: 24),
                itemCount: controller.persons.length,
                itemBuilder: (context, index) {
                  final person = controller.persons[index];
                  return PersonSectionCard(person: person);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
