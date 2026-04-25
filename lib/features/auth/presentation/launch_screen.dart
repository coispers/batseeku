import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            AdaptiveLayout(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppReveal(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                        gradient: const LinearGradient(
                          colors: <Color>[AppColors.maroon, AppColors.maroonDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            blurRadius: 20,
                            offset: Offset(0, 8),
                            color: Color(0x338B2332),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'BatSeekU',
                            style: textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Campus services and student-to-student support in one app.',
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.94),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppReveal(
                    delay: const Duration(milliseconds: 120),
                    child: AppContentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Prototype Flow',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const _FlowPoint(text: 'Find tutors and campus helpers'),
                          const _FlowPoint(text: 'Post service requests and errands'),
                          const _FlowPoint(text: 'Track conversations and reputation'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppReveal(
                    delay: const Duration(milliseconds: 220),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Get Started'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowPoint extends StatelessWidget {
  const _FlowPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
