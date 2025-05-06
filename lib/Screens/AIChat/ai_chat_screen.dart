import 'package:flutter/material.dart';
import 'Widgets/chat_message_bubble.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello, answer me as soon as possible. Please deliver language tips. Yesterday I have asked you about some corrections, can you deliver it today?',
      isUser: true,
      time: '11:11',
    ),
    ChatMessage(
      text: 'Fixed your grammar issues.',
      isUser: false,
      time: '15:12',
    ),
    ChatMessage(
      text: 'However @Teacher should also review it. Waiting for your reply.',
      isUser: false,
      time: '15:12',
    ),
    ChatMessage(
      text: 'Send me the lesson link, please.',
      isUser: true,
      time: '15:15',
    ),
    ChatMessage(
      text: 'https://www.englishlearning.com/lesson/oc3RY/?lesson-id=355%3A0',
      isUser: false,
      time: '15:16',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/ai_avatar.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'English AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFF2D2D2D),
            child: Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}