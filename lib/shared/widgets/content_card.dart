import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum AppCardTone {
  neutral,
  accent,
  success,
  warning,
}

class AppContentCard extends StatelessWidget {
  const AppContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.tone = AppCardTone.neutral,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final AppCardTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color toneColor = switch (tone) {
      AppCardTone.accent => AppColors.maroonSoft,
      AppCardTone.success => AppColors.successSurface,
      AppCardTone.warning => AppColors.warningSurface,
      AppCardTone.neutral => AppColors.surface,
    };

    final Color borderColor = switch (tone) {
      AppCardTone.accent => AppColors.maroon.withOpacity(0.25),
      AppCardTone.success => AppColors.success.withOpacity(0.28),
      AppCardTone.warning => AppColors.warning.withOpacity(0.24),
      AppCardTone.neutral => AppColors.line,
    };

    final Widget content = Container(
      decoration: BoxDecoration(
        color: toneColor,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: borderColor),
      ),
      padding: padding,
      child: child,
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              onTap: onTap,
              child: content,
            ),
    );
  }
}
