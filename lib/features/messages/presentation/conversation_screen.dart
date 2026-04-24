import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/message_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({
    super.key,
    required this.threadId,
  });

  final String threadId;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(mockDataRepositoryProvider);
    _messages = List<ChatMessage>.from(
      repository.getThreadById(widget.threadId)?.messages ??
          const <ChatMessage>[],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String currentSender) {
    final String text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          sender: currentSender,
          text: text,
          sentAt: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(mockDataRepositoryProvider);
    final thread = repository.getThreadById(widget.threadId);
    final authState = ref.watch(authControllerProvider);
    final role = authState.role;

    if (thread == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversation')),
        body: const Center(child: Text('Thread not found.')),
      );
    }

    final String sender = authState.user?.name ?? 'You';
    final bool canChat = canUseMessages(role);
    final bool isCompleted = thread.status == MessageThreadStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(thread.participants.join(' • ')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Center(
              child: Text(
                isCompleted ? 'Completed' : 'Active',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final ChatMessage message = _messages[index];
                final bool isMine = message.sender == sender;

                return Align(
                  alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isMine ? AppColors.maroon : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isMine ? AppColors.maroon : AppColors.line,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (!isMine)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              message.sender,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        Text(
                          message.text,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isMine
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (canChat && !isCompleted)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message',
                        ),
                        onSubmitted: (_) => _sendMessage(sender),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filled(
                      onPressed: () => _sendMessage(sender),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                canChat
                    ? 'This thread is completed.'
                    : 'Sign in as student/freelancer to send messages.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}
