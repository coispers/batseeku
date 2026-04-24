import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/models/freelancer_profile.dart';
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
              (String skill) => skill
                  .toLowerCase()
                  .contains(selectedSubject.toLowerCase()),
            );
        final bool matchesRating = profile.rating >= minimumRating;
        final bool matchesPrice = profile.hourlyRate <= maximumPrice;
        return matchesSubject && matchesRating && matchesPrice;
      },
    ).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: <Widget>[
        Text('Services', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Browse freelancers by subject, rating, and price.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
                Text('Minimum rating: ${minimumRating.toStringAsFixed(1)}'),
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
                Text('Maximum price: PHP ${maximumPrice.toStringAsFixed(0)} / hr'),
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
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${results.length} freelancers found',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (results.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('No freelancers match this filter set.'),
            ),
          ),
        ...results.map(
          (FreelancerProfile profile) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.maroonSoft,
                child: Text(profile.displayName.substring(0, 1)),
              ),
              title: Text(profile.displayName),
              subtitle: Text(profile.subject),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${profile.rating.toStringAsFixed(1)} ★',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text('PHP ${profile.hourlyRate.toStringAsFixed(0)}'),
                ],
              ),
              onTap: () => context.push('/services/freelancer/${profile.id}'),
            ),
          ),
        ),
      ],
    );
  }
}
