import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/review.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool freelancerMode = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final role = authState.role;

    if (user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.person_outline, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sign in to view your profile.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    final repository = ref.watch(mockDataRepositoryProvider);
    final reputation = repository.reputationForUser(user.id);
    final freelancerProfiles = repository.freelancerProfiles;
    final freelancerProfile = freelancerProfiles.where(
      (profile) => profile.userId == user.id,
    );
    final selectedProfile = freelancerProfile.isEmpty ? null : freelancerProfile.first;

    final List<Review> reviews = selectedProfile != null
        ? repository.reviewsForFreelancer(selectedProfile.id)
        : <Review>[
            Review(
              id: 'sr_1',
              reviewerName: 'Campus Moderator',
              comment: 'Timely communication and clear requests.',
              rating: 4.8,
              createdAt: DateTime(2026, 4, 4),
            ),
            Review(
              id: 'sr_2',
              reviewerName: 'Theresa M.',
              comment: 'Reliable and easy to work with.',
              rating: 4.6,
              createdAt: DateTime(2026, 4, 9),
            ),
          ];

    final bool isFreelancer = role == Role.freelancer;
    final double estimatedEarnings = selectedProfile == null
        ? 0
        : selectedProfile.completedJobs * selectedProfile.hourlyRate;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.maroonSoft,
                  child: Text(
                    user.name.substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(user.email),
                      if (user.course != null) Text(user.course!),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: <Widget>[
                          Icon(
                            user.isVerified
                                ? Icons.verified_rounded
                                : Icons.info_outline_rounded,
                            color:
                                user.isVerified ? AppColors.success : AppColors.warning,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.isVerified ? 'Verified' : 'Unverified',
                            style: TextStyle(
                              color: user.isVerified
                                  ? AppColors.success
                                  : AppColors.warning,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: ListTile(
            title: const Text('Reputation Score'),
            subtitle: Text(reputation.label),
            trailing: Text(
              reputation.score.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (isFreelancer) ...<Widget>[
          SwitchListTile(
            value: freelancerMode,
            title: const Text('Freelancer Mode'),
            subtitle: const Text('Manage profile visibility and active jobs'),
            onChanged: (bool value) {
              setState(() {
                freelancerMode = value;
              });
            },
          ),
          Card(
            child: ListTile(
              title: const Text('Estimated Earnings'),
              subtitle: Text(
                '${selectedProfile?.completedJobs ?? 0} completed tasks',
              ),
              trailing: Text(
                'PHP ${estimatedEarnings.toStringAsFixed(0)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        ...reviews.map(
          (Review review) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              title: Text(review.reviewerName),
              subtitle: Text(review.comment),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(review.rating.toStringAsFixed(1)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                subtitle: const Text('Notifications, preferences, privacy'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings are mocked in MVP.')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                  context.go('/launch');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
