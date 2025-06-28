import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/ai_avatar.png'),
            ),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFFA06BA5) // Purple for user messages
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            message.time,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 2),
            const Icon(
              Icons.check,
              size: 12,
              color: Colors.grey,
            ),
          ],
        ],
      ),
    );
  }
}


class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}