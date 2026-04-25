import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: compact
                    ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
                    : textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            if (action != null) action!,
          ],
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
