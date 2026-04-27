import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/models/freelancer_profile.dart';
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

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        AdaptiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              AppReveal(
                delay: const Duration(milliseconds: 70),
                child: AppContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        value: selectedSubject,
                        decoration: const InputDecoration(labelText: 'Subject'),
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
              const SizedBox(height: AppSpacing.md),
              AppReveal(
                delay: const Duration(milliseconds: 120),
                child: AppStatusBadge(
                  label: '${results.length} freelancers found',
                  tone: AppStatusTone.info,
                  icon: Icons.group_rounded,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (results.isEmpty)
                const EmptyStateBlock(
                  title: 'No matches with current filters',
                  message:
                      'Adjust subject, rating, or price to see more results.',
                  icon: Icons.filter_alt_off_rounded,
                ),
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
}
