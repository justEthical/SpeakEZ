class AppStrings {
  static const String appName = 'SpeakEZ';
  static const String nunitoFont = "Nunito";
  static const String termsAndConditionsUrl =
      "https://docs.google.com/document/d/11FvxDJvzon4p8jY-JtANv_UGw1U4cvYb7peQpRSz7RI/edit?usp=sharing";
  static const String privacyPolicyUrl =
      "https://docs.google.com/document/d/1JZ3ysesz4XjXubRnxb_FaPu_E3PoYSHXQ76VJC35P6s/edit?usp=sharing";

  static const String initialMessage =
      "Hi, I’m Natasha, your English speaking practice partner! Let’s have a conversation and improve your English together. Feel free to say anything or ask me questions. Ready to start chatting?";
  static const String systemPrompt =
      'You are Natasha, an English learning coach. Reply to users with short messages of 3-4 lines based on their responses. If a user asks a question that violates your AI guidelines, such as anything illegal or unethical, politely tell them you can’t discuss that topic. Also, encourage the user to continue the conversation on topic and do not repeat already asked question';
  static const String continueConversation =
      "Continue Conversation by asking question in you every reply based on the past conveersation or topic";
  static const String outroMessage =
      'Great job! You’ve successfully completed this session. Click the "View Result" button to see your results.';

  static const String resultScreenSystemPrompt =
      '''Analyze the following English chat JSON between user and AI. For the overall conversation, provide:
- Ratings: Fluency, Grammar, Vocabulary, Pronunciation (1-10 rating, average for the whole conversation)
- Overall score (out of 100)
- Short feedback for each category
- Motivation message
- One improvement suggestion
- A "correction" array containing only the corrected/improved user sentences in the same order as the input chat (do not include original or extra info).

Reply only in this JSON format:

{
  "score": 0,
  "fluency": {"rating": 0, "feedback": ""},
  "grammar": {"rating": 0, "feedback": ""},
  "vocabulary": {"rating": 0, "feedback": ""},
  "pronunciation": {"rating": 0, "feedback": ""},
  "motivation": "",
  "suggestion": "",
  "correction": [
    "I'm good, how about you?",
    "I went to the market today.",
    ...
  ]
}
''';

  // Shared Preferences
  static const String userAuthState = "user_auth_state";
  static const String userProfile = "user_profile";
}
