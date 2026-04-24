import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FreelancerProfileScreen extends ConsumerWidget {
  const FreelancerProfileScreen({
    super.key,
    required this.freelancerId,
  });

  final String freelancerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(mockDataRepositoryProvider);
    final role = ref.watch(currentRoleProvider);

    final profile = repository.getFreelancerById(freelancerId);
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Freelancer Profile')),
        body: const Center(child: Text('Freelancer not found.')),
      );
    }

    final reviews = repository.reviewsForFreelancer(profile.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Freelancer Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.maroonSoft,
                        child: Text(
                          profile.displayName.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 24,
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
                            Text(
                              profile.displayName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(profile.subject),
                            const SizedBox(height: AppSpacing.xs),
                            const Row(
                              children: <Widget>[
                                Icon(
                                  Icons.verified_rounded,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified BatStateU Account',
                                  style: TextStyle(
                                    color: AppColors.success,
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
                  const SizedBox(height: AppSpacing.md),
                  Text(profile.bio),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star_rounded, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${profile.rating.toStringAsFixed(1)} rating'),
                      const Spacer(),
                      Text(
                        'PHP ${profile.hourlyRate.toStringAsFixed(0)} / hr',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  if (profile.gwa != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Optional GWA: ${profile.gwa!.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Skills', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: profile.skills
                .map((skill) => Chip(label: Text(skill)))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Portfolio', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...profile.portfolioSamples.map(
            (sample) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(title: Text(sample)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...reviews.map(
            (review) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                title: Text(review.reviewerName),
                subtitle: Text(review.comment),
                trailing: Text('${review.rating.toStringAsFixed(1)} ★'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (canRequestService(role)) {
                  context.push('/services/request/$freelancerId');
                  return;
                }
                if (role == Role.freelancer) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Freelancers accept requests from incoming queues.',
                      ),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Sign in as student to request this service.'),
                  ),
                );
              },
              child: const Text('Request Service'),
            ),
          ),
        ],
      ),
    );
  }
}
