import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/models/service_category.dart';
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: <Widget>[
        Text(
          'Hello, $name',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'What do you need help with today?',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Search tutors, errands, or services',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Categories', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: categories
              .map(
                (ServiceCategory category) => _CategoryCard(category: category),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Available Now', style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () => context.go('/app/1'),
              child: const Text('See all'),
            ),
          ],
        ),
        ...availableNow.map(
          (profile) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.maroonSoft,
                child: Text(profile.displayName.substring(0, 1)),
              ),
              title: Text(profile.displayName),
              subtitle: Text(
                '${profile.subject} • PHP ${profile.hourlyRate.toStringAsFixed(0)}/hr',
              ),
              trailing: Text(
                profile.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () => context.push('/services/freelancer/${profile.id}'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Quick Errands', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton.icon(
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
                icon: const Icon(Icons.add_task_rounded),
                label: const Text('Post Errand'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.go('/app/2'),
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Browse Tasks'),
              ),
            ),
          ],
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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.go('/app/1'),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.maroon),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
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
