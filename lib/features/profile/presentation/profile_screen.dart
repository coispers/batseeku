import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/review.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
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

  Future<void> _confirmAndSwitchRole({
    required Role currentRole,
  }) async {
    final bool switchToFreelancer = currentRole == Role.student;
    final String targetRoleLabel =
        switchToFreelancer ? 'Freelancer' : 'Customer';

    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Switch role?'),
              content: Text(
                'Are you sure you want to switch to $targetRoleLabel mode?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed || !mounted) {
      return;
    }

    final bool switched = ref
        .read(authControllerProvider.notifier)
        .switchCustomerFreelancerRole();

    if (!mounted) {
      return;
    }

    if (!switched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Role switch is only available for customer/freelancer accounts.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to $targetRoleLabel mode.'),
      ),
    );
    context.go('/app/0');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final role = authState.role;

    if (user == null) {
      return ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AdaptiveLayout(
            child: EmptyStateBlock(
              title: 'Sign in to view your profile',
              message:
                  'Your account info, reviews, and settings are available after login.',
              icon: Icons.person_outline,
              action: ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ),
          ),
        ],
      );
    }

    final repository = ref.watch(mockDataRepositoryProvider);
    final reputation = repository.reputationForUser(user.id);
    final freelancerProfiles = repository.freelancerProfiles;
    final freelancerProfile = freelancerProfiles.where(
      (profile) => profile.userId == user.id,
    );
    final selectedProfile =
        freelancerProfile.isEmpty ? null : freelancerProfile.first;

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
    final bool canSwitchRole = role == Role.student || role == Role.freelancer;
    final double estimatedEarnings = selectedProfile == null
        ? 0
        : selectedProfile.completedJobs * selectedProfile.hourlyRate;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        AdaptiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppReveal(
                child: AppContentCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppAvatar(label: user.name, size: 56),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(user.email),
                            if (user.course != null) Text(user.course!),
                            const SizedBox(height: AppSpacing.sm),
                            AppStatusBadge(
                              label:
                                  user.isVerified ? 'Verified' : 'Unverified',
                              tone: user.isVerified
                                  ? AppStatusTone.success
                                  : AppStatusTone.warning,
                              icon: user.isVerified
                                  ? Icons.verified_rounded
                                  : Icons.info_outline_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppReveal(
                delay: const Duration(milliseconds: 60),
                child: AppContentCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reputation Score'),
                    subtitle: Text(reputation.label),
                    trailing: Text(
                      reputation.score.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (canSwitchRole)
                AppReveal(
                  delay: const Duration(milliseconds: 90),
                  child: AppContentCard(
                    tone:
                        isFreelancer ? AppCardTone.success : AppCardTone.accent,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.swap_horiz_rounded),
                      title: Text(
                        isFreelancer
                            ? 'Switch to Customer'
                            : 'Switch to Freelancer',
                      ),
                      subtitle: Text(
                        isFreelancer
                            ? 'Use customer view to post and track requests.'
                            : 'Use freelancer view to accept jobs and manage demand.',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _confirmAndSwitchRole(currentRole: role),
                    ),
                  ),
                ),
              if (canSwitchRole) const SizedBox(height: AppSpacing.md),
              if (isFreelancer) ...<Widget>[
                AppReveal(
                  delay: const Duration(milliseconds: 100),
                  child: AppContentCard(
                    child: SwitchListTile(
                      value: freelancerMode,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Freelancer Mode'),
                      subtitle: const Text(
                          'Manage profile visibility and active jobs'),
                      onChanged: (bool value) {
                        setState(() {
                          freelancerMode = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppReveal(
                  delay: const Duration(milliseconds: 140),
                  child: AppContentCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
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
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppReveal(
                delay: const Duration(milliseconds: 180),
                child: const AppSectionHeader(
                  title: 'Reviews',
                  subtitle: 'Recent feedback from people you worked with.',
                  compact: true,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...reviews.map(
                (Review review) => AppContentCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(review.reviewerName),
                    subtitle: Text(review.comment),
                    trailing: AppStatusBadge(
                      label: review.rating.toStringAsFixed(1),
                      tone: AppStatusTone.warning,
                      icon: Icons.star_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppReveal(
                delay: const Duration(milliseconds: 240),
                child: AppContentCard(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('Settings'),
                        subtitle:
                            const Text('Notifications, preferences, privacy'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings are mocked in MVP.'),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
