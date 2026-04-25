import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingSkeletonBlock extends StatelessWidget {
  const LoadingSkeletonBlock({
    super.key,
    this.lines = 3,
  });

  final int lines;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1),
      duration: AppMotion.medium,
      curve: Curves.easeInOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: List<Widget>.generate(
            lines,
            (int index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == lines - 1 ? 0 : AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 12,
                  width: index == lines - 1 ? 140 : double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundAlt,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
