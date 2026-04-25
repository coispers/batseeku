import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/shared/widgets/content_card.dart';
import 'package:flutter/material.dart';

class EmptyStateBlock extends StatelessWidget {
  const EmptyStateBlock({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppContentCard(
      tone: AppCardTone.neutral,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.textMuted, size: AppIconSize.lg),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
          if (action != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}
