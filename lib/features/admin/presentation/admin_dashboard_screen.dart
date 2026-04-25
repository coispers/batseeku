import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final repository = ref.watch(mockDataRepositoryProvider);

    if (role != Role.admin) {
      return const Scaffold(
        body: Center(
          child: Text('Admin access only.'),
        ),
      );
    }

    final metrics = repository.adminMetrics;
    final statuses = repository.adminUserStatuses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go('/launch');
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AdaptiveLayout(
            maxWidth: 1120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppReveal(
                  child: const AppSectionHeader(
                    title: 'Platform Metrics',
                    subtitle:
                        'Snapshot of adoption, requests, and risk signals.',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppReveal(
                  delay: const Duration(milliseconds: 80),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        child: _MetricCard(
                          label: 'Total Users',
                          value: metrics.totalUsers.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: _MetricCard(
                          label: 'Active Requests',
                          value: metrics.activeRequests.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: _MetricCard(
                          label: 'Reports',
                          value: metrics.reports.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: _MetricCard(
                          label: 'Verified',
                          value: metrics.verifiedUsers.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: _MetricCard(
                          label: 'Flagged',
                          value: metrics.flaggedUsers.toString(),
                          warning: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppReveal(
                  delay: const Duration(milliseconds: 140),
                  child: const AppSectionHeader(
                    title: 'User Status',
                    subtitle:
                        'Verification and moderation overview by account.',
                    compact: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...statuses.map(
                  (user) => AppContentCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: AppAvatar(label: user.name),
                      title: Text(user.name),
                      subtitle: Text(user.role.label),
                      trailing: AppStatusBadge(
                        label: user.status,
                        tone: user.status == 'Flagged'
                            ? AppStatusTone.danger
                            : AppStatusTone.success,
                        icon: user.status == 'Flagged'
                            ? Icons.warning_amber_rounded
                            : Icons.verified_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    this.warning = false,
  });

  final String label;
  final String value;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return AppContentCard(
      tone: warning ? AppCardTone.warning : AppCardTone.neutral,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
