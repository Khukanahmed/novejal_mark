import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novejal_mark/core/constants/app_colors.dart';
import 'package:novejal_mark/feature/user/home/model/person_model.dart';

class PointBoxWidget extends StatelessWidget {
  final PersonModel person;

  const PointBoxWidget({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mark = person.mark.value;
      final hasMark = mark != null;

      return Container(
        decoration: BoxDecoration(
          color: hasMark ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasMark ? AppColors.badgeBg : Colors.green.shade200,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: hasMark
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: hasMark ? 8 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tiny Badge header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: hasMark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasMark ? Icons.stars_rounded : Icons.star_border_rounded,
                      size: 11,
                      color: hasMark ? Colors.amberAccent : AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'পয়েন্ট',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: hasMark ? Colors.white70 : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              // The Big Point Number
              Text(
                hasMark ? '$mark' : '—',
                style: TextStyle(
                  fontSize: hasMark ? 24 : 18,
                  fontWeight: FontWeight.bold,
                  color: hasMark ? Colors.amberAccent : Colors.grey.shade400,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                hasMark ? '১ম ঘর' : 'মার্ক দিন',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: hasMark ? Colors.white60 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
