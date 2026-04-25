import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.label,
    this.size = 44,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final String safe = label.trim().isEmpty ? '?' : label.trim();

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.maroonSoft,
      child: Text(
        safe.substring(0, 1).toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foregroundColor ?? AppColors.maroon,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
