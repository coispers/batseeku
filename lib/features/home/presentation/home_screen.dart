import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/models/service_category.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(mockDataRepositoryProvider);
    final authState = ref.watch(authControllerProvider);

    final String name = authState.user?.name.split(' ').first ?? 'Student';
    final categories = repository.categories;
    final availableNow = repository.freelancerProfiles
        .where((profile) => profile.availableNow)
        .toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        AdaptiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppReveal(
                child: AppContentCard(
                  tone: AppCardTone.accent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hello, $name',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'What do you need help with today?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search tutors, errands, or services',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppReveal(
                delay: const Duration(milliseconds: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppSectionHeader(
                      title: 'Categories',
                      subtitle: 'Jump directly to the kind of help you need.',
                      compact: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: categories
                          .map(
                            (ServiceCategory category) =>
                                _CategoryCard(category: category),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppReveal(
                delay: const Duration(milliseconds: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppSectionHeader(
                      title: 'Available Now',
                      subtitle:
                          'Freelancers currently open for quick requests.',
                      action: TextButton(
                        onPressed: () => context.go('/app/1'),
                        child: const Text('See all'),
                      ),
                      compact: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (availableNow.isEmpty)
                      const EmptyStateBlock(
                        title: 'No one online right now',
                        message:
                            'Try checking Services for the full list of freelancers.',
                      ),
                    ...availableNow.map(
                      (profile) => AppContentCard(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        onTap: () =>
                            context.push('/services/freelancer/${profile.id}'),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: AppAvatar(label: profile.displayName),
                          title: Text(profile.displayName),
                          subtitle: Text(
                            '${profile.subject} • PHP ${profile.hourlyRate.toStringAsFixed(0)}/hr',
                          ),
                          trailing: AppStatusBadge(
                            label: '${profile.rating.toStringAsFixed(1)} ★',
                            tone: AppStatusTone.success,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppReveal(
                delay: const Duration(milliseconds: 190),
                child: AppContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSectionHeader(
                        title: 'Quick Errands',
                        subtitle: 'Post a task or browse active requests.',
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AppPrimaryActionButton(
                              label: 'Post Errand',
                              icon: Icons.add_task_rounded,
                              onPressed: () {
                                if (authState.role == Role.guest) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sign in to post errands.'),
                                    ),
                                  );
                                  return;
                                }
                                context.go('/app/2');
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppSecondaryActionButton(
                              label: 'Browse Tasks',
                              icon: Icons.local_shipping_outlined,
                              onPressed: () => context.go('/app/2'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    final IconData icon = _iconForCategory(category.name);

    return AppContentCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => context.go('/app/1'),
      tone: AppCardTone.neutral,
      child: SizedBox(
        width: 180,
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.maroon),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Programming Help':
        return Icons.code_rounded;
      case 'Math Help':
        return Icons.calculate_rounded;
      case 'Lab Assistance':
        return Icons.science_outlined;
      case 'Thesis Formatting':
        return Icons.article_outlined;
      case 'Tutoring':
      default:
        return Icons.school_rounded;
    }
  }
}
