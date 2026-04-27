import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/message_thread.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);

    if (!canUseMessages(role)) {
      return ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          AdaptiveLayout(
            child: EmptyStateBlock(
              title: 'Messages are unavailable for this role',
              message: 'Students and freelancers can access chat threads.',
              icon: Icons.lock_outline_rounded,
            ),
          ),
        ],
      );
    }

    final repository = ref.watch(mockDataRepositoryProvider);
    final List<MessageThread> threads = repository.messageThreads;

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        AdaptiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              if (threads.isEmpty)
                const EmptyStateBlock(
                  title: 'No threads yet',
                  message:
                      'Conversations will appear here after a service request starts.',
                ),
              ...threads.map(
                (MessageThread thread) => AppReveal(
                  delay: const Duration(milliseconds: 90),
                  child: AppContentCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    onTap: () => context.push('/messages/${thread.id}'),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: AppAvatar(label: thread.participants.first),
                      title: Text(thread.participants.join(' • ')),
                      subtitle: Text(thread.lastMessage),
                      trailing: _StatusPill(status: thread.status),
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final MessageThreadStatus status;

  @override
  Widget build(BuildContext context) {
    final bool active = status == MessageThreadStatus.active;
    return AppStatusBadge(
      label: active ? 'Active' : 'Completed',
      tone: active ? AppStatusTone.success : AppStatusTone.neutral,
      icon: active ? Icons.bolt_rounded : Icons.check_circle_outline_rounded,
    );
  }
}
