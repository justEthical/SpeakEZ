class AppStrings {
  static const String appName = 'SpeakEZ';
  static const String nunitoFont = "Nunito";
  static const String poppinsFont = "Poppins";
  static const String downloadWhisperModelTaskId = 'download-whisper-model-task-id';
  static const String termsAndConditionsUrl =
      "https://docs.google.com/document/d/11FvxDJvzon4p8jY-JtANv_UGw1U4cvYb7peQpRSz7RI/edit?usp=sharing";
  static const String privacyPolicyUrl =
      "https://docs.google.com/document/d/1JZ3ysesz4XjXubRnxb_FaPu_E3PoYSHXQ76VJC35P6s/edit?usp=sharing";
  static const String appPlayStoreUrl = "https://play.google.com/store/apps/details?id=com.english.learning.speakez.ai";

  // static const String initialMessage =
  //     "Hi, I’m Natasha, your English speaking practice partner! Let’s have a conversation and improve your English together. Feel free to say anything or ask me questions. Ready to start chatting?";
  static const String systemPrompt =
      'You are Natasha, an English learning coach. Reply to users with short messages of 3-4 lines based on their responses. If a user asks a question that violates your AI guidelines, such as anything illegal or unethical, politely tell them you can’t discuss that topic. Also, encourage the user to continue the conversation on topic and do not repeat already asked question';
  static const String systemPrompt2 = '''You are Natasha,fix ASR and grade replies.

Inputs per turn:
AI_LAST_MESSAGE, USER_TRANSCRIPT, PREVIOUS_SUMMARY.

Rules:
- correctedTranscript: ONLY sound-alike ASR fixes according to context of conversation. If unsure, keep original. No rephrase.
- enhancedTranscript: from correctedTranscript, fix grammar/usage/punct lightly; keep meaning.
- nextAiMessage: 2–4 sentences + a brief question based on correctedTranscript.
- conversationSummary: create or extend PREVIOUS_SUMMARY to avoid question repetition and keep context.
- scores: integers 1–10; pronunciation ≈ clamp(1,10, round(10 - 9*WER)).
- feedback: one short phrase naming the weakest area from scores (lowest score; if tie use: pronunciation > grammar > fluency > vocabulary).

Output ONLY JSON:
{"nextAiMessage": "...",
"correctedTranscript": "...",
"enhancedTranscript": "...",
"conversationSummary": "...",
"scores":{"fluency":X,"grammar":X,"vocabulary":X,"pronunciation":X}}
"feedback": "..."}
''';
  static const String continueConversation =
      "Continue Conversation by asking question in you every reply based on the past conversation or topic";
  static const String outroMessage =
      'Great job! You’ve successfully completed this session. Click the "View Result" button to see your results.';
  static const String reviewRequest = "✨ “I’m also a student learning English, and I built this app to help friends like us. Your 1-minute review will mean a lot and inspire me to keep improving. 🙏💜”";

  static const String resultScreenSystemPrompt =
      '''You are a feedback generator. 
Input: scores (1–10 for fluency, grammar, vocabulary, pronunciation) + feedback list. 
Do: 
- For each key give 1–2 sentence feedback using score+comments. 
- suggestion = 1–2 sentences overall advice. 
- motivation = short motivational quote. 
Output JSON only:
{"fluency":"...","grammar":"...","vocabulary":"...","pronunciation":"...","suggestion":"...","motivation":"..."}
''';

static const appShareMessage = '''Unlock Your Confidence with SpeakEZ AI 🎙️✨ – Your Pocket English Coach!
Whether you're a beginner 📘 or polishing your fluency 🚀, SpeakEZ AI helps you practice speaking English anytime, anywhere 🌍. Get instant feedback on pronunciation 🔊, grammar ✍️, and fluency 💬—just like a personal tutor in your pocket 🎒.
Build a strong vocabulary 📚 with daily exercises 📝, word games 🎮, and mini-quizzes ✅. Enjoy engaging, bite-sized lessons on real-life topics 🛫💼☕ designed for real speaking practice.
Speak naturally 😃. Speak confidently 💪. SpeakEZ AI 🌟.''';

  // Shared Preferences
  static const String userAuthState = "user_auth_state";
  static const String userProfile = "user_profile";
  static const String remoteConfig = "remote_config";
  static const String completedPracticeSessions = "completed_practice_sessions";
  static const String isShowPracticeTabInfoBanner = "is_show_practice_tab_info_banner";
  static const String isOnDeviceTranscriptionSupported = "is_on_device_transcription_supported";

  // Admob
  static const String rewardedInterstitialAdUnitId = "ca-app-pub-5948017215945465/4170178867";  
  static const String rewardedAdUnitId = "ca-app-pub-5948017215945465/1763615176";

}
