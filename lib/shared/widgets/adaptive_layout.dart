import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 980,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.fromLTRB(
                appHorizontalPadding(width),
                AppSpacing.md,
                appHorizontalPadding(width),
                AppSpacing.xl,
              ),
          child: child,
        ),
      ),
    );
  }
}

double appHorizontalPadding(double width) {
  if (width >= AppBreakpoints.desktop) {
    return AppSpacing.xxxl;
  }
  if (width >= AppBreakpoints.tablet) {
    return AppSpacing.xl;
  }
  return AppSpacing.lg;
}
