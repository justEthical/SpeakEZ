class ChatModel {
  String message;
  String time;
  ChatType chatType = ChatType.normalChatMesssage;
  int messageDuration = 0;
  bool isAI;
  ChatModel({
    required this.message,
    required this.time,
    required this.isAI,
    required this.messageDuration,
    this.chatType = ChatType.normalChatMesssage,
  });
}

enum ChatType { gettingAIResponse, transcribing, normalChatMesssage }
