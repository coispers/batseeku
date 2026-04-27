import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/errand_task.dart';
import 'package:batseeku/models/freelancer_profile.dart';
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
    final Role role = authState.role;
    final bool isFreelancer = role == Role.freelancer;
    final bool isCustomer = role == Role.student;
    final categories = repository.categories;
    final availableNow = repository.freelancerProfiles
        .where((profile) => profile.availableNow)
        .toList();
    FreelancerProfile? profile;
    if (authState.user != null) {
      for (final FreelancerProfile item in repository.freelancerProfiles) {
        if (item.userId == authState.user!.id) {
          profile = item;
          break;
        }
      }
    }
    final openErrands = repository.errands
        .where((task) => task.status == ErrandStatus.open)
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
                  tone: isFreelancer ? AppCardTone.success : AppCardTone.accent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isFreelancer
                            ? 'Freelancer Desk, $name'
                            : isCustomer
                                ? 'Customer Home, $name'
                                : 'Welcome, $name',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        isFreelancer
                            ? 'Spot demand, pick jobs, and keep your queue full.'
                            : isCustomer
                                ? 'What do you need help with today?'
                                : 'Explore services and sign in to start requests.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        decoration: InputDecoration(
                          hintText: isFreelancer
                              ? 'Search requests, subjects, or task keywords'
                              : 'Search tutors, errands, or services',
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: <Widget>[
                          AppStatusBadge(
                            label: isFreelancer
                                ? 'Mode: Freelancer'
                                : isCustomer
                                    ? 'Mode: Customer'
                                    : 'Mode: Guest',
                            tone: isFreelancer
                                ? AppStatusTone.success
                                : isCustomer
                                    ? AppStatusTone.accent
                                    : AppStatusTone.neutral,
                            icon: isFreelancer
                                ? Icons.bolt_rounded
                                : isCustomer
                                    ? Icons.shopping_bag_rounded
                                    : Icons.visibility_outlined,
                          ),
                          if (isFreelancer && profile != null)
                            AppStatusBadge(
                              label: '${profile.completedJobs} jobs completed',
                              tone: AppStatusTone.info,
                              icon: Icons.check_circle_outline_rounded,
                            )
                          else
                            AppStatusBadge(
                              label: '${availableNow.length} available now',
                              tone: AppStatusTone.info,
                              icon: Icons.groups_rounded,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 40),
                  child: AppContentCard(
                    tone: AppCardTone.success,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const AppSectionHeader(
                          title: 'Freelancer Command Center',
                          subtitle:
                              'Use these shortcuts to move from discovery to delivery.',
                          compact: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: AppPrimaryActionButton(
                                label: 'Find Demand',
                                icon: Icons.school_rounded,
                                onPressed: () => context.go('/app/1'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppSecondaryActionButton(
                                label: 'Open Jobs',
                                icon: Icons.local_shipping_rounded,
                                onPressed: () => context.go('/app/2'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (isFreelancer) const SizedBox(height: AppSpacing.lg),
              AppReveal(
                delay: const Duration(milliseconds: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppSectionHeader(
                      title: isFreelancer
                          ? 'High-Demand Categories'
                          : 'Categories',
                      subtitle: isFreelancer
                          ? 'Focus areas students are actively browsing.'
                          : 'Jump directly to the kind of help you need.',
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
                      title: isFreelancer
                          ? 'Open Errands Near You'
                          : 'Available Now',
                      subtitle: isFreelancer
                          ? 'New tasks you can accept immediately.'
                          : 'Freelancers currently open for quick requests.',
                      action: TextButton(
                        onPressed: () =>
                            context.go(isFreelancer ? '/app/2' : '/app/1'),
                        child: Text(isFreelancer ? 'Open board' : 'See all'),
                      ),
                      compact: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (isFreelancer && openErrands.isEmpty)
                      const EmptyStateBlock(
                        title: 'No open errands at the moment',
                        message:
                            'Check again shortly or watch the Jobs tab for updates.',
                      ),
                    if (!isFreelancer && availableNow.isEmpty)
                      const EmptyStateBlock(
                        title: 'No one online right now',
                        message:
                            'Try checking Services for the full list of freelancers.',
                      ),
                    if (isFreelancer)
                      ...openErrands.take(4).map(
                            (task) => AppContentCard(
                              margin:
                                  const EdgeInsets.only(bottom: AppSpacing.sm),
                              onTap: () => context.go('/app/2'),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.local_shipping_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                title: Text(task.title),
                                subtitle: Text(
                                  '${task.postedBy} • ${task.distanceKm.toStringAsFixed(1)} km',
                                ),
                                trailing: AppStatusBadge(
                                  label:
                                      'PHP ${task.budget.toStringAsFixed(0)}',
                                  tone: AppStatusTone.warning,
                                ),
                              ),
                            ),
                          )
                    else
                      ...availableNow.map(
                        (profile) => AppContentCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          onTap: () => context
                              .push('/services/freelancer/${profile.id}'),
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
                        title: isFreelancer
                            ? 'Freelancer Actions'
                            : 'Quick Errands',
                        subtitle: isFreelancer
                            ? 'Accept nearby tasks or keep client chats moving.'
                            : 'Post a task or browse active requests.',
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AppPrimaryActionButton(
                              label:
                                  isFreelancer ? 'Accept Tasks' : 'Post Errand',
                              icon: isFreelancer
                                  ? Icons.task_alt_rounded
                                  : Icons.add_task_rounded,
                              onPressed: () {
                                if (!isFreelancer &&
                                    authState.role == Role.guest) {
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
                              label: isFreelancer
                                  ? 'Client Chats'
                                  : 'Browse Tasks',
                              icon: isFreelancer
                                  ? Icons.chat_bubble_outline_rounded
                                  : Icons.local_shipping_outlined,
                              onPressed: () => context
                                  .go(isFreelancer ? '/app/3' : '/app/2'),
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
