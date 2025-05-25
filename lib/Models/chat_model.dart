class ChatModel {
  String message;
  String time;
  ChatType chatType = ChatType.normalChatMesssage;
  bool isAI;
  ChatModel({
    required this.message,
    required this.time,
    required this.isAI,
    this.chatType = ChatType.normalChatMesssage,
  });
}

enum ChatType { gettingAIResponse, transcribing, normalChatMesssage }
