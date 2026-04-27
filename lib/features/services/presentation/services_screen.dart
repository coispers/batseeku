import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/freelancer_profile.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/models/service_request.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String selectedSubject = 'All';
  double minimumRating = 0;
  double maximumPrice = 350;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(mockDataRepositoryProvider);
    final authState = ref.watch(authControllerProvider);
    final Role role = authState.role;
    final bool isFreelancer = role == Role.freelancer;
    final bool isCustomer = role == Role.student;

    final List<String> subjects = <String>[
      'All',
      ...repository.categories.map((category) => category.name),
    ];

    final List<FreelancerProfile> results = repository.freelancerProfiles.where(
      (FreelancerProfile profile) {
        final bool matchesSubject = selectedSubject == 'All' ||
            profile.subject == selectedSubject ||
            profile.skills.any(
              (String skill) =>
                  skill.toLowerCase().contains(selectedSubject.toLowerCase()),
            );
        final bool matchesRating = profile.rating >= minimumRating;
        final bool matchesPrice = profile.hourlyRate <= maximumPrice;
        return matchesSubject && matchesRating && matchesPrice;
      },
    ).toList();

    final List<ServiceRequest> allRequests = repository.serviceRequests;
    final List<ServiceRequest> myRequests = authState.user == null
        ? <ServiceRequest>[]
        : allRequests
            .where((request) => request.freelancerId == authState.user!.id)
            .toList();

    final List<ServiceRequest> marketRequests = allRequests
        .where((request) => request.status == ServiceRequestStatus.pending)
        .toList();

    String studentNameFor(String studentId) {
      for (final user in repository.users) {
        if (user.id == studentId) {
          return user.name;
        }
      }
      return 'Student';
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        AdaptiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppReveal(
                child: AppSectionHeader(
                  title:
                      isFreelancer ? 'Service Demand Board' : 'Find Services',
                  subtitle: isFreelancer
                      ? 'Review requests, claim jobs, and manage your pipeline.'
                      : 'Browse freelancers by subject, rating, and hourly rate.',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 40),
                  child: AppContentCard(
                    tone: AppCardTone.success,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const AppSectionHeader(
                          title: 'Freelancer Queue',
                          subtitle:
                              'Prioritize your assigned requests before taking new work.',
                          compact: true,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: <Widget>[
                            AppStatusBadge(
                              label: '${myRequests.length} assigned',
                              tone: AppStatusTone.success,
                              icon: Icons.task_alt_rounded,
                            ),
                            AppStatusBadge(
                              label: '${marketRequests.length} open market',
                              tone: AppStatusTone.info,
                              icon: Icons.campaign_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 70),
                  child: AppContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: selectedSubject,
                          decoration:
                              const InputDecoration(labelText: 'Subject'),
                          items: subjects
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                selectedSubject = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Minimum rating: ${minimumRating.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Slider(
                          value: minimumRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              minimumRating = value;
                            });
                          },
                        ),
                        Text(
                          'Maximum price: PHP ${maximumPrice.toStringAsFixed(0)} / hr',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Slider(
                          value: maximumPrice,
                          min: 150,
                          max: 400,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              maximumPrice = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (isFreelancer) const SizedBox(height: AppSpacing.md),
              if (isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AppSectionHeader(
                        title: 'Assigned To You',
                        subtitle: 'Requests currently matched to your account.',
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (myRequests.isEmpty)
                        const EmptyStateBlock(
                          title: 'No assigned requests yet',
                          message:
                              'Keep your profile active to receive direct matches.',
                          icon: Icons.inbox_outlined,
                        ),
                      ...myRequests.map(
                        (ServiceRequest request) => AppContentCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          tone: AppCardTone.success,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                const Icon(Icons.assignment_turned_in_rounded),
                            title: Text(request.serviceType),
                            subtitle: Text(
                              '${studentNameFor(request.studentId)} • Due ${request.deadline.month}/${request.deadline.day} ${request.deadline.hour}:00',
                            ),
                            trailing: AppStatusBadge(
                              label: _requestStatusLabel(request.status),
                              tone: _requestStatusTone(request.status),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isFreelancer) const SizedBox(height: AppSpacing.md),
              if (isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AppSectionHeader(
                        title: 'Open Market Requests',
                        subtitle:
                            'Browse unmatched requests and claim a new project.',
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (marketRequests.isEmpty)
                        const EmptyStateBlock(
                          title: 'No open requests right now',
                          message: 'Check again shortly for new demand.',
                          icon: Icons.hourglass_empty_rounded,
                        ),
                      ...marketRequests.map(
                        (ServiceRequest request) => AppContentCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      request.serviceType,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  AppStatusBadge(
                                    label:
                                        'PHP ${request.estimatedPrice.toStringAsFixed(0)}',
                                    tone: AppStatusTone.warning,
                                    icon: Icons.payments_outlined,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(request.details),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: <Widget>[
                                  AppStatusBadge(
                                    label:
                                        '${studentNameFor(request.studentId)}',
                                    tone: AppStatusTone.neutral,
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  AppStatusBadge(
                                    label:
                                        'Due ${request.deadline.month}/${request.deadline.day}',
                                    tone: AppStatusTone.info,
                                    icon: Icons.schedule_rounded,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Align(
                                alignment: Alignment.centerRight,
                                child: AppPrimaryActionButton(
                                  label: 'Claim Request',
                                  icon: Icons.bolt_rounded,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Request claimed (mock).'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isFreelancer) const SizedBox(height: AppSpacing.md),
              if (!isFreelancer)
                AppReveal(
                  delay: const Duration(milliseconds: 120),
                  child: AppStatusBadge(
                    label: isCustomer
                        ? '${results.length} freelancers found'
                        : 'Guest preview: ${results.length} freelancers found',
                    tone:
                        isCustomer ? AppStatusTone.info : AppStatusTone.neutral,
                    icon: isCustomer
                        ? Icons.group_rounded
                        : Icons.visibility_outlined,
                  ),
                ),
              if (!isFreelancer) const SizedBox(height: AppSpacing.sm),
              if (!isFreelancer)
                if (results.isEmpty)
                  const EmptyStateBlock(
                    title: 'No matches with current filters',
                    message:
                        'Adjust subject, rating, or price to see more results.',
                    icon: Icons.filter_alt_off_rounded,
                  ),
              if (!isFreelancer)
                ...results.map(
                  (FreelancerProfile profile) => AppReveal(
                    delay: const Duration(milliseconds: 160),
                    child: AppContentCard(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      onTap: () =>
                          context.push('/services/freelancer/${profile.id}'),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: AppAvatar(label: profile.displayName),
                        title: Text(profile.displayName),
                        subtitle: Text(profile.subject),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AppStatusBadge(
                              label: '${profile.rating.toStringAsFixed(1)} ★',
                              tone: AppStatusTone.success,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'PHP ${profile.hourlyRate.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _requestStatusLabel(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.pending:
        return 'Pending';
      case ServiceRequestStatus.matching:
        return 'Matching';
      case ServiceRequestStatus.accepted:
        return 'Accepted';
      case ServiceRequestStatus.completed:
        return 'Completed';
    }
  }

  AppStatusTone _requestStatusTone(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.pending:
        return AppStatusTone.warning;
      case ServiceRequestStatus.matching:
        return AppStatusTone.info;
      case ServiceRequestStatus.accepted:
        return AppStatusTone.success;
      case ServiceRequestStatus.completed:
        return AppStatusTone.neutral;
    }
  }
}
