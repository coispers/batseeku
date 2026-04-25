import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppPrimaryActionButton extends StatelessWidget {
  const AppPrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppIconSize.sm),
      label: Text(label),
    );
  }
}

class AppSecondaryActionButton extends StatelessWidget {
  const AppSecondaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppIconSize.sm),
      label: Text(label),
    );
  }
}
