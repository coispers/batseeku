import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/errand_task.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrandsScreen extends ConsumerStatefulWidget {
  const ErrandsScreen({super.key});

  @override
  ConsumerState<ErrandsScreen> createState() => _ErrandsScreenState();
}

class _ErrandsScreenState extends ConsumerState<ErrandsScreen> {
  late List<ErrandTask> errands;

  @override
  void initState() {
    super.initState();
    errands = List<ErrandTask>.from(
      ref.read(mockDataRepositoryProvider).errands,
    );
  }

  void _openPostErrandDialog() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController budgetController = TextEditingController();
    final TextEditingController distanceController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Post New Errand',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task title'),
                  validator: (String? value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please add a title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (String? value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please add a description.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Budget (PHP)'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: distanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Distance (km)'),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      final auth = ref.read(authControllerProvider);
                      final task = ErrandTask(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        budget: double.tryParse(budgetController.text.trim()) ?? 120,
                        distanceKm:
                            double.tryParse(distanceController.text.trim()) ?? 1.0,
                        postedBy: auth.user?.name ?? 'Unknown',
                        status: ErrandStatus.open,
                      );

                      setState(() {
                        errands.insert(0, task);
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Errand posted (mock).')),
                      );
                    },
                    child: const Text('Post Errand'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final role = authState.role;
    final bool canPost = canPostErrands(role);

    if (role == Role.guest) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.lock_outline_rounded, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sign in to post or request errands.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: <Widget>[
        Text('Errands', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Post tasks or accept nearby campus errands.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canPost ? _openPostErrandDialog : null,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Post Errand'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (errands.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('No errands available.'),
            ),
          ),
        ...errands.map(
          (task) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(task.description),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      Text('PHP ${task.budget.toStringAsFixed(0)}'),
                      const SizedBox(width: AppSpacing.md),
                      Text('${task.distanceKm.toStringAsFixed(1)} km away'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Posted by ${task.postedBy}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final String action = role == Role.freelancer
                            ? 'Errand accepted (mock).'
                            : 'Request sent (mock).';
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(action)));
                      },
                      child: Text(role == Role.freelancer ? 'Accept' : 'Request'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
