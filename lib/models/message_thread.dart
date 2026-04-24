enum MessageThreadStatus {
  active,
  completed,
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String sender;
  final String text;
  final DateTime sentAt;
}

class MessageThread {
  const MessageThread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.status,
    required this.messages,
  });

  final String id;
  final List<String> participants;
  final String lastMessage;
  final MessageThreadStatus status;
  final List<ChatMessage> messages;
}
