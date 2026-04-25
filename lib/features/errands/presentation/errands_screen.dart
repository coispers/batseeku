import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/errand_task.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
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
                  style: Theme.of(context).textTheme.titleLarge,
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
                        budget: double.tryParse(budgetController.text.trim()) ??
                            120,
                        distanceKm:
                            double.tryParse(distanceController.text.trim()) ??
                                1.0,
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
      return ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AdaptiveLayout(
            child: EmptyStateBlock(
              title: 'Errands are locked in guest mode',
              message: 'Sign in to post tasks or request help from peers.',
              icon: Icons.lock_outline_rounded,
            ),
          ),
        ],
      );
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
                  title: 'Errands',
                  subtitle: 'Post tasks or accept nearby campus errands.',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppReveal(
                delay: const Duration(milliseconds: 80),
                child: SizedBox(
                  width: double.infinity,
                  child: AppPrimaryActionButton(
                    label: 'Post Errand',
                    icon: Icons.add_rounded,
                    onPressed: canPost ? _openPostErrandDialog : null,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (errands.isEmpty)
                const EmptyStateBlock(
                  title: 'No errands available',
                  message: 'Be the first to post a new campus task.',
                  icon: Icons.local_shipping_outlined,
                ),
              ...errands.map(
                (task) => AppReveal(
                  delay: const Duration(milliseconds: 130),
                  child: AppContentCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                task.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            AppStatusBadge(
                              label: _statusLabel(task.status),
                              tone: _statusTone(task.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(task.description),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: <Widget>[
                            AppStatusBadge(
                              label: 'PHP ${task.budget.toStringAsFixed(0)}',
                              tone: AppStatusTone.info,
                              icon: Icons.payments_outlined,
                            ),
                            AppStatusBadge(
                              label:
                                  '${task.distanceKm.toStringAsFixed(1)} km away',
                              tone: AppStatusTone.neutral,
                              icon: Icons.place_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Posted by ${task.postedBy}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppPrimaryActionButton(
                            label:
                                role == Role.freelancer ? 'Accept' : 'Request',
                            onPressed: () {
                              final String action = role == Role.freelancer
                                  ? 'Errand accepted (mock).'
                                  : 'Request sent (mock).';
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(action)));
                            },
                          ),
                        ),
                      ],
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

  String _statusLabel(ErrandStatus status) {
    switch (status) {
      case ErrandStatus.accepted:
        return 'Accepted';
      case ErrandStatus.completed:
        return 'Completed';
      case ErrandStatus.open:
        return 'Open';
    }
  }

  AppStatusTone _statusTone(ErrandStatus status) {
    switch (status) {
      case ErrandStatus.accepted:
        return AppStatusTone.info;
      case ErrandStatus.completed:
        return AppStatusTone.success;
      case ErrandStatus.open:
        return AppStatusTone.warning;
    }
  }
}
