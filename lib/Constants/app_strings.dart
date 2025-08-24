class AppStrings {
  static const String appName = 'SpeakEZ';
  static const String nunitoFont = "Nunito";
  static const String termsAndConditionsUrl =
      "https://docs.google.com/document/d/11FvxDJvzon4p8jY-JtANv_UGw1U4cvYb7peQpRSz7RI/edit?usp=sharing";
  static const String privacyPolicyUrl =
      "https://docs.google.com/document/d/1JZ3ysesz4XjXubRnxb_FaPu_E3PoYSHXQ76VJC35P6s/edit?usp=sharing";
  static const String appPlayStoreUrl = "https://play.google.com/store/apps/details?id=com.english.learning.speakez.ai";

  static const String initialMessage =
      "Hi, I’m Natasha, your English speaking practice partner! Let’s have a conversation and improve your English together. Feel free to say anything or ask me questions. Ready to start chatting?";
  static const String systemPrompt =
      'You are Natasha, an English learning coach. Reply to users with short messages of 3-4 lines based on their responses. If a user asks a question that violates your AI guidelines, such as anything illegal or unethical, politely tell them you can’t discuss that topic. Also, encourage the user to continue the conversation on topic and do not repeat already asked question';
  static const String systemPrompt2 = '''You are Natasha a friendly English speaking partner. Stay on-topic and use simple, natural English.  
Replies: 2–4 sentences, encouraging, supportive. End each reply with a related follow-up question.  
Match user’s level: simple words for beginners, push slightly. Gently correct mistakes only if they exist, without interrupting the flow.  
No off-topic, no other language, no explanations—just raw conversation.''';
  static const String continueConversation =
      "Continue Conversation by asking question in you every reply based on the past conversation or topic";
  static const String outroMessage =
      'Great job! You’ve successfully completed this session. Click the "View Result" button to see your results.';

  static const String resultScreenSystemPrompt =
      '''Analyze the following English chat JSON between user and AI but rate only the user responses. For the overall conversation, provide:
- Ratings: Fluency, Grammar, Vocabulary, Pronunciation (1-10 rating, average for the whole conversation)
- Overall score (out of 100). for A1 and A2 level, the score should be above 60.
- Short feedback for each category
- Motivation message
- One improvement suggestion
- A "correction" array containing only the corrected/improved user sentences in the same order as the input chat (do not include original or extra info).
- Adjust the feedback and scores to match the user's English level

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

static const appShareMessage = '''Unlock Your Confidence with SpeakEZ AI 🎙️✨ – Your Pocket English Coach!
Whether you're a beginner 📘 or polishing your fluency 🚀, SpeakEZ AI helps you practice speaking English anytime, anywhere 🌍. Get instant feedback on pronunciation 🔊, grammar ✍️, and fluency 💬—just like a personal tutor in your pocket 🎒.
Build a strong vocabulary 📚 with daily exercises 📝, word games 🎮, and mini-quizzes ✅. Enjoy engaging, bite-sized lessons on real-life topics 🛫💼☕ designed for real speaking practice.
Speak naturally 😃. Speak confidently 💪. SpeakEZ AI 🌟.''';

  // Shared Preferences
  static const String userAuthState = "user_auth_state";
  static const String userProfile = "user_profile";
  static const String remoteConfig = "remote_config";

  static const String appWriteProjectId = "68922bff001e5c2efef0";
  static const String appWriteEndPointUrl = "https://nyc.cloud.appwrite.io/v1";
  static const String appStorageBuckerId = "689233a2002934deb1b4";

}
