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
          color: hasMark ? const Color(0xFF1E3A8A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasMark ? AppColors.badgeBg : Colors.indigo.shade200,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hasMark
                  ? AppColors.badgeBg.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: hasMark ? 10 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasMark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasMark ? Icons.stars_rounded : Icons.star_border_rounded,
                      size: 13,
                      color: hasMark ? Colors.amberAccent : Colors.indigo,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'পয়েন্ট',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: hasMark ? Colors.white70 : Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // The Big Point Number (Just like the '3' drawn in the sketch)
              AnimatedScale(
                scale: hasMark ? 1.05 : 0.95,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Text(
                  hasMark ? '$mark' : '—',
                  style: TextStyle(
                    fontSize: hasMark ? 36 : 28,
                    fontWeight: FontWeight.bold,
                    color: hasMark ? Colors.amberAccent : Colors.grey.shade400,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Subtitle
              Text(
                hasMark ? 'প্রাপ্ত মার্ক' : 'মার্ক দিন',
                style: TextStyle(
                  fontSize: 10,
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
