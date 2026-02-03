// lib/features/dashboard/presentation/widgets/subject_card.dart
import 'package:flutter/material.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/database/app_database.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  Color _getSubjectColor() {
    try {
      final hex = subject.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSubjectColor();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconData(),
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Subject name
              Text(
                subject.name,
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              // Description
              Text(
                subject.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (subject.iconName.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'calculate':
      case 'math':
      case 'mathematics':
        return Icons.calculate;
      case 'book':
        return Icons.menu_book;
      case 'language':
        return Icons.translate;
      default:
        return Icons.book;
    }
  }
}
