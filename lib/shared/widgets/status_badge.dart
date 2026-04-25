import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum AppStatusTone {
  neutral,
  accent,
  success,
  warning,
  danger,
  info,
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.tone = AppStatusTone.neutral,
    this.icon,
  });

  final String label;
  final AppStatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color background = switch (tone) {
      AppStatusTone.accent => AppColors.maroonSoft,
      AppStatusTone.success => AppColors.successSurface,
      AppStatusTone.warning => AppColors.warningSurface,
      AppStatusTone.danger => AppColors.dangerSurface,
      AppStatusTone.info => AppColors.infoSurface,
      AppStatusTone.neutral => AppColors.surfaceMuted,
    };

    final Color foreground = switch (tone) {
      AppStatusTone.accent => AppColors.maroon,
      AppStatusTone.success => AppColors.success,
      AppStatusTone.warning => AppColors.warning,
      AppStatusTone.danger => AppColors.danger,
      AppStatusTone.info => AppColors.info,
      AppStatusTone.neutral => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: AppIconSize.xs, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
