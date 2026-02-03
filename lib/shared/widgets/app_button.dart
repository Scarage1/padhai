// lib/shared/widgets/app_button.dart
import 'package:flutter/material.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;

  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? AppColors.textOnPrimary
                    : AppColors.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: textStyle),
            ],
          );

    if (fullWidth) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(padding: padding, child: child),
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(padding: padding, child: child),
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(padding: padding, child: child),
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(padding: padding, child: child),
        ),
    };
  }

  ButtonStyle _getButtonStyle() {
    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      AppButtonVariant.secondary => ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      AppButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      AppButtonVariant.text => TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
    };
  }

  TextStyle _getTextStyle() {
    final baseStyle = AppTypography.button;
    return switch (size) {
      AppButtonSize.small => baseStyle.copyWith(fontSize: 14),
      AppButtonSize.medium => baseStyle,
      AppButtonSize.large => baseStyle.copyWith(fontSize: 18),
    };
  }
}
