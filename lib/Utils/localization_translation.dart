import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ================= ENGLISH =================
    'en': {
      // Login & Auth
      'login': "Login",
      'register': "Register",
      'email': "Email",
      'password': "Password",
      'confirmPassword': "Confirm Password",
      'fullName': "Full Name",
      'enterEmail': "Enter Email...",
      'enterPassword': "Enter password...",
      'welcomeBack': "Welcome Back",
      'gladToSeeYouAgain': "Glad to see you again",
      'letsStart': "Let's Start",
      'createAccountInSimpleSteps': "Create your account in simple steps",
      'or': "OR",
      'loginWithGoogle': "Login with Google",
      'registerWithGoogle': "Register with Google",
      'byContinuingYouAgree': "By continuing, you agree to our ",
      'termsOfService': "Terms of Service",
      'and': " and ",
      'privacyPolicy': "Privacy Policy",

      // Settings
      'settings': "Settings",
      'help': "Help",
      'rateUs': "Rate Us",
      'rateUsOnGooglePlay': "Rate us on Google play",
      'referToFriend': "Refer to Friend",
      'shareWithFriends': "Share it with your friends",
      'logout': "Logout",
      'deleteAccount': "Delete Account",
      'deleteAccountAndData': "Delete account and data",
      'reauthenticatePrompt': "Please reauthentication to proceed further.",
      'reauthenticate': "Reauthenticate",
      'error': "Error",
      'pleaseEnterPassword': "Please enter password.",

      // Home Screen
      'hi': "Hi",
      'currentStreak': "Current Streak",
      'wordsLearned': "Words Learned",
      'days': "days",
      'currentLevel': "Current Level",
      'introduction': "Introduction",
      'startLearning': "Start Learning",
      'continueLearning': "Continue Learning",
      'learnByLevel': "Learn by level",
      'seeAll': "See all",

      // Practice Cards
      'selectScenario': "Scenario Practice",
      'practiceRealConversations': "Practice real-life conversations with AI",
      'explore': "Explore",
      'freeTalkTitle': "Free Speaking",
      'talkAboutAnything': "Talk about anything you want with AI",
      'startNow': "Start Now",
      'conversationProgress': "Conversation Progress",
      'lessons': "Lessons",
      'levelLessons': "Level Lessons",
      'completed': "Completed",
      'retest': "RETEST",
      'close': "Close",
      'youGot': "You got: ",
      'yourCurrentStreakIs': "Your current Streak is",

      // Level Bottom Sheet
      'a1Beginner': "A1 Beginner",
      'a1Description': "Start learning the language",
      'a2Elementary': "A2 Elementary",
      'a2Description': "Can communicate using simple sentences",
      'b1Intermediate': "B1 Intermediate",
      'b1Description': "Can describe scenes and express thoughts coherently",
      'b2UpperIntermediate': "B2 Upper-Intermediate",
      'b2Description':
          "Can understand complex texts and express ideas effortlessly",
      'c1Advanced': "C1 Advanced",
      'c1Description': "Can communicate fluently with native speakers",
      'c2Expert': "C2 Expert",
      'c2Description': "Has mastered the language to a native level",

      // Tab Bar
      'progress': "Progress",
      'practice': "Practice",
      'freeTalk': "Free Talk",
      'freeTalkDescription': "Practice speaking on any topic of your choice.",
      'startFreeTalk': "Start Free Talk",
      'profile': "Profile",
      'exit': "Exit",
      'pressAgainToExit': "Press again to exit",

      // Onboarding
      'previous': "Previous",
      'next': "Next",
      'back': "Back",
      'tellUsAboutYourself': "Tell us about yourself",
      'helpUsPersonalize': "Help us personalize your experience",

      // Lesson Screens
      'levelUnlockTest': "Level Unlock Test",
      'welcomeToTheLesson': "Welcome to the lesson",
      'unlockTestScoreRequirement':
          "You have to score more than 80% to unlock the",
      'level': "level",
      'start': "Start",
      'vocabulary': "Vocabulary",
      'grammarTips': "Grammer Tips",
      'testYourKnowledge': "Test Your Knowledge",
      'noVocabularyAvailable': "No vocabulary items available",
      'noGrammarTipsAvailable': "No grammar tips available",
      'autoSpeak': "Auto speak",
      'prev': "Prev",
      'done': "Done",
      'meaning': "Meaning:",
      'exampleSentences': "Example Sentence(s)",
      'listen': "Listen",
      'check': "Check",
      'word': "Word",
      'tip': "Tip",
      'startQuiz': "Start Quiz",
      'question': "Question",

      // Answer Result
      'correctAnswer': "Correct Answer",
      'wrongAnswer': "Wrong Answer",

      // Lesson Exit Alert
      'exitUnlockTestWarning':
          "Exiting will immediately end this test. You will not be able to attempt any UNLOCK LEVEL TEST again until 24 hours have passed. Do you still want to Exit?",
      'exitLessonConfirmation':
          "Are you sure you want to exit and discard your current lessson's progress?",
      'continueTest': "Continue Test",
      'exitAndDiscard': "Exit and Discard",

      // Speaking Question
      'tapToStop': "Tap to stop",
      'processing': "Processing...",
      'listening': "Listening...",

      // Result Screen
      'lessonCompleted': "Lesson Completed",
      'accuracy': "Accuracy",
      'timeTaken': "Time Taken",

      // Practice Screen
      'speakingPractice': "Speaking Practice",
      'practiceWithNatasha': "Practice with Natasha",
      'selectScenarioToStart': "Select a scenario to start practicing.",
      'downloadingNatashaAI': "Downloading Natasha AI...",
      'downloadInfo': "The download is about 60 MB. Please keep the app open.",
      'gems': "GEMS",
      'startPractice': "Start Practice",
      'viewResults': "View Results",

      // Chat Exit Alert
      'exitChatConfirmation':
          "Are you sure you want to exit and End this conversation",
      'closeAndDiscard': "Close and discard",

      // Practice Result Screen
      'score': "Score",
      'fluency': "Fluency",
      'grammar': "Grammar",
      'pronunciationLabel': "Pronunciation",
      'totalSpeakingTime': "Total Speaking Time",
      'suggestion': "Suggestion",
      'detailedFeedback': "Detailed Feedback",
      'minutes': "Minutes",

      // Dialogs
      'areYouSureLogout': "Are you sure you want to logout?",
      'yes': "Yes",
      'cancel': "Cancel",
      'openSettings': "Open Settings",
      'areYouSureDeleteAccount':
          "Are you sure you want to delete your account?\n\nThis action is irreversible.",
      'delete': "Delete",
      'levelLockedMessage':
          "This level is locked. You need to complete the previous level(s) to unlock this one or unlock it by giving a test.",
      'unlock': "UNLOCK",
      'view': "View",
      'unlockTest': "Unlock test",
      'canUnlockIn': "You can unlock this level in",
      'hours': "hours.",
      'startingPracticeWillUse': "Starting this practice will use 100 gems.",
      'watchAdGetGems': "Watch an Ad and Get 100 Gems",

      // Review Screen
      'pleaseRateYourExperience': "Please rate your experience",
      'didYouLikeTheSession': "Did you vibe with this session? 🔥",
      'yesLovedIt': "Yesss, loved it! 💯",
      'notReally': "Nah, not really",
      'thankYouFeedback': "Thanks for keeping it real with us! We got you. 🙏",
      'feedbackDone': "Done",

      // Free Talk Screen Enhanced
      'freeTalkWhyTitle': "Why Free Talk?",
      'freeTalkFeature1Title': "Unlimited Topics",
      'freeTalkFeature1Desc': "Talk about anything that interests you",
      'freeTalkFeature2Title': "AI-Powered",
      'freeTalkFeature2Desc': "Smart conversations with Natasha AI",
      'freeTalkFeature3Title': "Instant Feedback",
      'freeTalkFeature3Desc': "Get real-time tips to improve",
      'freeTalkTopicsTitle': "Need inspiration?",
      'freeTalkTopic1': "My hobbies",
      'freeTalkTopic2': "Travel plans",
      'freeTalkTopic3': "Favorite movies",
      'freeTalkTopic4': "Daily routine",
      'freeTalkTopic5': "Dream job",
      'freeTalkTopic6': "Weekend plans",

      // Settings Screen Enhanced
      'settingsAppSection': "APP SETTINGS",
      'settingsSupportSection': "SUPPORT",
      'settingsAccountSection': "ACCOUNT",
      'settingsLanguage': "App Language",
      'settingsLogoutSubtitle': "Sign out of your account",
      'settingsLevel': "Level",
      'settingsWords': "Words",
      'vocabularyBuilder': "Vocabulary Builder",
      'vocabularyBuilderSubtitle':
          "Practice pronunciation and master new words with confidence.",
      'pronunciationPractice': "Pronunciation Practice",
      'pronunciationPracticeSubtitle':
          "Improve your speaking clarity and sound natural.",
      'vocabularyPractice': "Vocabulary Practice",
      'vocabularyPracticeSubtitle':
          "Learn and review useful words for daily conversations.",

      // Preparing Screen
      'preparingTitle': "Creating Your Perfect Learning Plan",
      'preparingSubtitle': "Personalizing just for you",
      'downloadingLessons': "Personalizing AI lessons for you",
      'extractingLessons': "Setting up your learning content",
      'preparingComplete': "Ready to learn",
      'errorOccurred': "Something went wrong",
      'downloadError':
          "Failed to download lessons. Please check your internet connection and try again.",
      'retry': "Retry",
    },

    // ================= JAPANESE =================
    'ja': {
      // Login & Auth
      'login': "ログイン",
      'register': "登録",
      'email': "メールアドレス",
      'password': "パスワード",
      'confirmPassword': "パスワード確認",
      'fullName': "氏名",
      'enterEmail': "メールアドレスを入力...",
      'enterPassword': "パスワードを入力...",
      'welcomeBack': "おかえりなさい",
      'gladToSeeYouAgain': "またお会いできて嬉しいです",
      'letsStart': "始めましょう",
      'createAccountInSimpleSteps': "簡単なステップでアカウントを作成できます",
      'or': "または",
      'loginWithGoogle': "Googleでログイン",
      'registerWithGoogle': "Googleで登録",
      'byContinuingYouAgree': "続行すると、次に同意したものとみなされます：",
      'termsOfService': "利用規約",
      'and': " と ",
      'privacyPolicy': "プライバシーポリシー",

      // Settings
      'settings': "設定",
      'help': "ヘルプ",
      'rateUs': "評価する",
      'rateUsOnGooglePlay': "Google Playで評価する",
      'referToFriend': "友達に紹介",
      'shareWithFriends': "友達と共有する",
      'logout': "ログアウト",
      'deleteAccount': "アカウント削除",
      'deleteAccountAndData': "アカウントとデータを削除",
      'reauthenticatePrompt': "続行するには再認証が必要です。",
      'reauthenticate': "再認証",
      'error': "エラー",
      'pleaseEnterPassword': "パスワードを入力してください。",

      // Home Screen
      'hi': "こんにちは",
      'currentStreak': "現在の連続日数",
      'wordsLearned': "習得した単語",
      'days': "日",
      'currentLevel': "現在のレベル",
      'introduction': "イントロダクション",
      'startLearning': "学習を始める",
      'continueLearning': "学習を続ける",
      'learnByLevel': "レベル別に学ぶ",
      'seeAll': "すべて見る",

      // Practice Cards
      'selectScenario': "シナリオ練習",
      'practiceRealConversations': "AIと実際の会話を練習しましょう",
      'explore': "探索する",
      'freeTalkTitle': "フリースピーキング",
      'talkAboutAnything': "AIと好きなトピックで会話しましょう",
      'startNow': "今すぐ開始",
      'conversationProgress': "会話の進捗",
      'lessons': "レッスン",
      'levelLessons': "レベルレッスン",
      'completed': "完了",
      'retest': "再テスト",
      'close': "閉じる",
      'youGot': "あなたの得点：",
      'yourCurrentStreakIs': "現在の連続日数：",

      // Level Bottom Sheet
      'a1Beginner': "A1 初級",
      'a1Description': "言語学習を始めるレベル",
      'a2Elementary': "A2 基礎",
      'a2Description': "簡単な文章で意思疎通ができる",
      'b1Intermediate': "B1 中級",
      'b1Description': "場面を説明し、考えを整理して表現できる",
      'b2UpperIntermediate': "B2 中上級",
      'b2Description': "複雑な文章を理解し、自然に表現できる",
      'c1Advanced': "C1 上級",
      'c1Description': "ネイティブと流暢に話せる",
      'c2Expert': "C2 熟達",
      'c2Description': "ネイティブレベルで言語を使いこなせる",

      // Tab Bar
      'progress': "進捗",
      'practice': "練習",
      'freeTalk': "フリートーク",
      'freeTalkDescription': "好きなトピックでスピーキングを練習しましょう。",
      'startFreeTalk': "フリートークを始める",
      'profile': "プロフィール",
      'exit': "終了",
      'pressAgainToExit': "もう一度押すと終了します",

      // Onboarding
      'previous': "前へ",
      'next': "次へ",
      'back': "戻る",
      'tellUsAboutYourself': "あなたについて教えてください",
      'helpUsPersonalize': "あなたに合った体験を作るために役立てます",

      // Lesson Screens
      'levelUnlockTest': "レベル解除テスト",
      'welcomeToTheLesson': "レッスンへようこそ",
      'unlockTestScoreRequirement': "このレベルを解除するには80%以上が必要です",
      'level': "レベル",
      'start': "開始",
      'vocabulary': "語彙",
      'grammarTips': "文法のヒント",
      'testYourKnowledge': "知識をテスト",
      'noVocabularyAvailable': "利用可能な語彙はありません",
      'noGrammarTipsAvailable': "利用可能な文法ヒントはありません",
      'autoSpeak': "自動読み上げ",
      'prev': "前へ",
      'done': "完了",
      'meaning': "意味：",
      'exampleSentences': "例文",
      'listen': "聞く",
      'check': "チェック",
      'word': "単語",
      'tip': "ヒント",
      'startQuiz': "クイズ開始",
      'question': "問題",

      // Answer Result
      'correctAnswer': "正解",
      'wrongAnswer': "不正解",

      // Exit Alerts
      'exitUnlockTestWarning': "終了するとテストは中断されます。24時間経過するまで再受験できません。本当に終了しますか？",
      'exitLessonConfirmation': "レッスンを終了すると進捗が失われます。よろしいですか？",
      'continueTest': "テストを続ける",
      'exitAndDiscard': "終了して破棄",

      // Speaking
      'tapToStop': "タップして停止",
      'processing': "処理中...",
      'listening': "聞き取り中...",

      // Result Screen
      'lessonCompleted': "レッスン完了",
      'accuracy': "正確さ",
      'timeTaken': "所要時間",

      // Practice Screen
      'speakingPractice': "スピーキング練習",
      'practiceWithNatasha': "ナターシャと練習",
      'selectScenarioToStart': "シナリオを選択して開始してください",
      'downloadingNatashaAI': "ナターシャAIをダウンロード中...",
      'downloadInfo': "約60MBのダウンロードです。アプリを閉じないでください。",
      'gems': "GEMS",
      'startPractice': "練習を開始",
      'viewResults': "結果を見る",

      // Chat Exit
      'exitChatConfirmation': "会話を終了しますか？",
      'closeAndDiscard': "閉じて破棄",

      // Practice Result
      'score': "スコア",
      'fluency': "流暢さ",
      'grammar': "文法",
      'pronunciationLabel': "発音",
      'totalSpeakingTime': "総スピーキング時間",
      'suggestion': "アドバイス",
      'detailedFeedback': "詳細フィードバック",
      'minutes': "分",

      // Dialogs
      'areYouSureLogout': "ログアウトしてよろしいですか？",
      'yes': "はい",
      'cancel': "キャンセル",
      'openSettings': "設定を開く",
      'areYouSureDeleteAccount': "アカウントを削除してよろしいですか？\n\nこの操作は元に戻せません。",
      'delete': "削除",
      'levelLockedMessage': "このレベルはロックされています。前のレベルを完了するか、テストで解除できます。",
      'unlock': "解除",
      'view': "表示",
      'unlockTest': "解除テスト",
      'canUnlockIn': "このレベルを解除できるまで：",
      'hours': "時間",
      'startingPracticeWillUse': "この練習を開始すると100ジェムを使用します。",
      'watchAdGetGems': "広告を見て100ジェムを獲得",

      // Review Screen
      'pleaseRateYourExperience': "体験を評価してください",
      'didYouLikeTheSession': "このセッション、良かった？ 🔥",
      'yesLovedIt': "めっちゃ良かった！ 💯",
      'notReally': "うーん、微妙かも",
      'thankYouFeedback': "正直に教えてくれてありがとう！ 🙏",
      'feedbackDone': "完了",

      // Free Talk Screen Enhanced
      'freeTalkWhyTitle': "フリートークの魅力",
      'freeTalkFeature1Title': "無限のトピック",
      'freeTalkFeature1Desc': "好きなことについて話そう",
      'freeTalkFeature2Title': "AI搭載",
      'freeTalkFeature2Desc': "ナターシャAIとスマートな会話",
      'freeTalkFeature3Title': "即座のフィードバック",
      'freeTalkFeature3Desc': "リアルタイムで改善のヒントを取得",
      'freeTalkTopicsTitle': "何を話そうか迷ったら？",
      'freeTalkTopic1': "趣味について",
      'freeTalkTopic2': "旅行の計画",
      'freeTalkTopic3': "好きな映画",
      'freeTalkTopic4': "日常生活",
      'freeTalkTopic5': "夢の仕事",
      'freeTalkTopic6': "週末の予定",

      // Settings Screen Enhanced
      'settingsAppSection': "アプリ設定",
      'settingsSupportSection': "サポート",
      'settingsAccountSection': "アカウント",
      'settingsLanguage': "アプリの言語",
      'settingsLogoutSubtitle': "アカウントからログアウト",
      'settingsLevel': "レベル",
      'settingsWords': "単語",
      'vocabularyBuilder': "語彙ビルダー",
      'vocabularyBuilderSubtitle': "発音を練習し、新しい単語を自信を持って身につけましょう。",
      'pronunciationPractice': "発音練習",
      'pronunciationPracticeSubtitle': "発話の明瞭さを高め、自然な話し方を目指しましょう。",
      'vocabularyPractice': "語彙練習",
      'vocabularyPracticeSubtitle': "日常会話で役立つ単語を学び、復習しましょう。",

      // Preparing Screen
      'preparingTitle': "あなた専用の学習プランを作成中",
      'preparingSubtitle': "パーソナライズしています",
      'downloadingLessons': "AIレッスンをパーソナライズ中",
      'extractingLessons': "学習コンテンツを準備中",
      'preparingComplete': "学習の準備完了",
      'errorOccurred': "エラーが発生しました",
      'downloadError': "レッスンのダウンロードに失敗しました。インターネット接続を確認して再試行してください。",
      'retry': "再試行",
    },

    // ================= Hindi =================
    'hi': {
      // Login & Auth
      'login': "लॉगिन",
      'register': "रजिस्टर",
      'email': "ईमेल",
      'password': "पासवर्ड",
      'confirmPassword': "पासवर्ड की पुष्टि करें",
      'fullName': "पूरा नाम",
      'enterEmail': "ईमेल दर्ज करें...",
      'enterPassword': "पासवर्ड दर्ज करें...",
      'welcomeBack': "वापसी पर स्वागत है",
      'gladToSeeYouAgain': "आपसे फिर मिलकर खुशी हुई",
      'letsStart': "चलो शुरू करें",
      'createAccountInSimpleSteps': "सरल चरणों में अपना खाता बनाएं",
      'or': "या",
      'loginWithGoogle': "Google से लॉगिन करें",
      'registerWithGoogle': "Google से रजिस्टर करें",
      'byContinuingYouAgree': "जारी रखते हुए, आप हमारी सहमति देते हैं ",
      'termsOfService': "सेवा की शर्तें",
      'and': " और ",
      'privacyPolicy': "गोपनीयता नीति",

      // Settings
      'settings': "सेटिंग्स",
      'help': "सहायता",
      'rateUs': "हमें रेट करें",
      'rateUsOnGooglePlay': "Google Play पर हमें रेट करें",
      'referToFriend': "दोस्त को रेफर करें",
      'shareWithFriends': "अपने दोस्तों के साथ साझा करें",
      'logout': "लॉगआउट",
      'deleteAccount': "खाता हटाएं",
      'deleteAccountAndData': "खाता और डेटा हटाएं",
      'reauthenticatePrompt': "आगे बढ़ने के लिए कृपया पुन: प्रमाणित करें।",
      'reauthenticate': "पुन: प्रमाणित करें",
      'error': "त्रुटि",
      'pleaseEnterPassword': "कृपया पासवर्ड दर्ज करें।",

      // Home Screen
      'hi': "नमस्ते",
      'currentStreak': "वर्तमान स्ट्रीक",
      'wordsLearned': "सीखे गए शब्द",
      'days': "दिन",
      'currentLevel': "वर्तमान स्तर",
      'introduction': "परिचय",
      'startLearning': "सीखना शुरू करें",
      'continueLearning': "सीखना जारी रखें",
      'learnByLevel': "स्तर के अनुसार सीखें",
      'seeAll': "सब देखें",

      // Practice Cards
      'selectScenario': "परिदृश्य अभ्यास",
      'practiceRealConversations': "AI के साथ वास्तविक बातचीत का अभ्यास करें",
      'explore': "खोजें",
      'freeTalkTitle': "फ्री स्पीकिंग",
      'talkAboutAnything': "AI के साथ किसी भी विषय पर बात करें",
      'startNow': "अभी शुरू करें",
      'conversationProgress': "बातचीत की प्रगति",
      'lessons': "पाठ",
      'levelLessons': "स्तर के पाठ",
      'completed': "पूर्ण",
      'retest': "पुनः परीक्षण",
      'close': "बंद करें",
      'youGot': "आपका स्कोर: ",
      'yourCurrentStreakIs': "आपकी वर्तमान स्ट्रीक है",

      // Level Bottom Sheet
      'a1Beginner': "A1 प्रारंभिक",
      'a1Description': "भाषा सीखना शुरू करें",
      'a2Elementary': "A2 प्राथमिक",
      'a2Description': "सरल वाक्यों का उपयोग करके संचार कर सकते हैं",
      'b1Intermediate': "B1 मध्यम",
      'b1Description':
          "दृश्यों का वर्णन कर सकते हैं और विचार स्पष्ट रूप से व्यक्त कर सकते हैं",
      'b2UpperIntermediate': "B2 उच्च-मध्यम",
      'b2Description':
          "जटिल पाठों को समझ सकते हैं और विचार आसानी से व्यक्त कर सकते हैं",
      'c1Advanced': "C1 उन्नत",
      'c1Description': "मूल वक्ताओं के साथ धाराप्रवाह संवाद कर सकते हैं",
      'c2Expert': "C2 विशेषज्ञ",
      'c2Description': "भाषा का उपयोग मूल स्तर पर कर सकते हैं",

      // Tab Bar
      'progress': "प्रगति",
      'practice': "अभ्यास",
      'freeTalk': "फ्री टॉक",
      'freeTalkDescription':
          "अपनी पसंद के किसी भी विषय पर बोलने का अभ्यास करें।",
      'startFreeTalk': "फ्री टॉक शुरू करें",
      'profile': "प्रोफ़ाइल",
      'exit': "निकास",
      'pressAgainToExit': "बाहर निकलने के लिए फिर से दबाएँ",

      // Onboarding
      'previous': "पिछला",
      'next': "अगला",
      'back': "वापस",
      'tellUsAboutYourself': "अपने बारे में बताएं",
      'helpUsPersonalize': "आपके अनुभव को व्यक्तिगत बनाने में मदद करें",

      // Lesson Screens
      'levelUnlockTest': "स्तर अनलॉक परीक्षण",
      'welcomeToTheLesson': "पाठ में आपका स्वागत है",
      'unlockTestScoreRequirement':
          "इस स्तर को अनलॉक करने के लिए आपको 80% से अधिक स्कोर चाहिए",
      'level': "स्तर",
      'start': "शुरू करें",
      'vocabulary': "शब्दावली",
      'grammarTips': "व्याकरण सुझाव",
      'testYourKnowledge': "अपना ज्ञान जांचें",
      'noVocabularyAvailable': "कोई शब्दावली उपलब्ध नहीं है",
      'noGrammarTipsAvailable': "कोई व्याकरण सुझाव उपलब्ध नहीं है",
      'autoSpeak': "स्वचालित पढ़ना",
      'prev': "पिछला",
      'done': "पूर्ण",
      'meaning': "अर्थ:",
      'exampleSentences': "उदाहरण वाक्य",
      'listen': "सुनें",
      'check': "जाँच करें",
      'word': "शब्द",
      'tip': "सुझाव",
      'startQuiz': "क्विज़ शुरू करें",
      'question': "प्रश्न",

      // Answer Result
      'correctAnswer': "सही उत्तर",
      'wrongAnswer': "गलत उत्तर",

      // Lesson Exit Alert
      'exitUnlockTestWarning':
          "बाहर निकलने पर यह परीक्षण तुरंत समाप्त हो जाएगा। अगले 24 घंटे तक आप इस अनलॉक स्तर परीक्षण को दोबारा नहीं दे पाएंगे। क्या आप वाकई बाहर निकलना चाहते हैं?",
      'exitLessonConfirmation':
          "क्या आप वाकई बाहर निकलना चाहते हैं और अपनी वर्तमान प्रगति को त्यागना चाहते हैं?",
      'continueTest': "परीक्षण जारी रखें",
      'exitAndDiscard': "बाहर निकलें और त्यागें",

      // Speaking Question
      'tapToStop': "रोकने के लिए टैप करें",
      'processing': "प्रोसेसिंग...",
      'listening': "सुन रहे हैं...",

      // Result Screen
      'lessonCompleted': "पाठ पूर्ण",
      'accuracy': "सटीकता",
      'timeTaken': "समय लिया",

      // Practice Screen
      'speakingPractice': "बोलने का अभ्यास",
      'practiceWithNatasha': "नताशा के साथ अभ्यास करें",
      'selectScenarioToStart': "अभ्यास शुरू करने के लिए परिदृश्य चुनें",
      'downloadingNatashaAI': "नताशा AI डाउनलोड हो रहा है...",
      'downloadInfo': "डाउनलोड लगभग 60 MB है। कृपया ऐप खुला रखें।",
      'gems': "जेम्स",
      'startPractice': "अभ्यास शुरू करें",
      'viewResults': "परिणाम देखें",

      // Chat Exit Alert
      'exitChatConfirmation': "क्या आप बातचीत समाप्त करना चाहते हैं?",
      'closeAndDiscard': "बंद करें और त्यागें",

      // Practice Result Screen
      'score': "स्कोर",
      'fluency': "धाराप्रवाहता",
      'grammar': "व्याकरण",
      'pronunciationLabel': "उच्चारण",
      'totalSpeakingTime': "कुल बोलने का समय",
      'suggestion': "सुझाव",
      'detailedFeedback': "विस्तृत प्रतिक्रिया",
      'minutes': "मिनट",

      // Dialogs
      'areYouSureLogout': "क्या आप वाकई लॉगआउट करना चाहते हैं?",
      'yes': "हाँ",
      'cancel': "रद्द करें",
      'openSettings': "सेटिंग्स खोलें",
      'areYouSureDeleteAccount':
          "क्या आप वाकई अपना खाता हटाना चाहते हैं?\n\nयह कार्रवाई अपरिवर्तनीय है।",
      'delete': "हटाएं",
      'levelLockedMessage':
          "यह स्तर लॉक है। आपको पिछले स्तर पूरे करने होंगे या परीक्षण देकर इसे अनलॉक कर सकते हैं।",
      'unlock': "अनलॉक",
      'view': "देखें",
      'unlockTest': "अनलॉक परीक्षण",
      'canUnlockIn': "आप इसे अनलॉक कर सकते हैं:",
      'hours': "घंटे",
      'startingPracticeWillUse':
          "इस अभ्यास को शुरू करने पर 100 जेम्स उपयोग होंगे।",
      'watchAdGetGems': "विज्ञापन देखें और 100 जेम्स प्राप्त करें",

      // Review Screen
      'pleaseRateYourExperience': "कृपया अपने अनुभव को रेट करें",
      'didYouLikeTheSession': "सेशन कैसा लगा? मज़ा आया? 🔥",
      'yesLovedIt': "हाँ बहुत बढ़िया! 💯",
      'notReally': "नहीं, ज़्यादा नहीं",
      'thankYouFeedback': "सच बताने के लिए थैंक्स! हम सुधारेंगे। 🙏",
      'feedbackDone': "ठीक है",

      // Free Talk Screen Enhanced
      'freeTalkWhyTitle': "फ्री टॉक क्यों?",
      'freeTalkFeature1Title': "असीमित विषय",
      'freeTalkFeature1Desc': "अपनी पसंद के किसी भी विषय पर बात करें",
      'freeTalkFeature2Title': "AI संचालित",
      'freeTalkFeature2Desc': "नताशा AI के साथ स्मार्ट बातचीत",
      'freeTalkFeature3Title': "तुरंत फीडबैक",
      'freeTalkFeature3Desc': "सुधार के लिए रीयल-टाइम सुझाव",
      'freeTalkTopicsTitle': "कुछ आइडिया चाहिए?",
      'freeTalkTopic1': "मेरी हॉबी",
      'freeTalkTopic2': "यात्रा की योजना",
      'freeTalkTopic3': "पसंदीदा फिल्में",
      'freeTalkTopic4': "रोज़ की दिनचर्या",
      'freeTalkTopic5': "सपनों की नौकरी",
      'freeTalkTopic6': "वीकेंड प्लान",

      // Settings Screen Enhanced
      'settingsAppSection': "ऐप सेटिंग्स",
      'settingsSupportSection': "सहायता",
      'settingsAccountSection': "खाता",
      'settingsLanguage': "ऐप की भाषा",
      'settingsLogoutSubtitle': "अपने खाते से लॉगआउट करें",
      'settingsLevel': "स्तर",
      'settingsWords': "शब्द",
      'vocabularyBuilder': "शब्दावली बिल्डर",
      'vocabularyBuilderSubtitle':
          "उच्चारण का अभ्यास करें और नए शब्द आत्मविश्वास से सीखें।",
      'pronunciationPractice': "उच्चारण अभ्यास",
      'pronunciationPracticeSubtitle':
          "अपनी बोलने की स्पष्टता सुधारें और अधिक स्वाभाविक लगें।",
      'vocabularyPractice': "शब्दावली अभ्यास",
      'vocabularyPracticeSubtitle':
          "दैनिक बातचीत के लिए उपयोगी शब्द सीखें और दोहराएँ।",

      // Preparing Screen
      'preparingTitle': "आपके लिए सर्वश्रेष्ठ लर्निंग प्लान बना रहे हैं",
      'preparingSubtitle': "आपके लिए पर्सनलाइज़ कर रहे हैं",
      'downloadingLessons': "AI पाठ आपके लिए तैयार हो रहे हैं",
      'extractingLessons': "लर्निंग कंटेंट सेट अप हो रहा है",
      'preparingComplete': "सीखने के लिए तैयार",
      'errorOccurred': "कुछ गड़बड़ हुई",
      'downloadError':
          "पाठ डाउनलोड करने में विफल। कृपया अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।",
      'retry': "पुनः प्रयास करें",
    },

    // ================ Spanish =================
    'es': {
      // Login & Auth
      'login': "Iniciar sesión",
      'register': "Registrarse",
      'email': "Correo electrónico",
      'password': "Contraseña",
      'confirmPassword': "Confirmar contraseña",
      'fullName': "Nombre completo",
      'enterEmail': "Introduzca el correo...",
      'enterPassword': "Introduzca la contraseña...",
      'welcomeBack': "Bienvenido de nuevo",
      'gladToSeeYouAgain': "Nos alegra verte de nuevo",
      'letsStart': "Comencemos",
      'createAccountInSimpleSteps': "Crea tu cuenta en simples pasos",
      'or': "o",
      'loginWithGoogle': "Iniciar con Google",
      'registerWithGoogle': "Registrarse con Google",
      'byContinuingYouAgree': "Al continuar aceptas nuestros ",
      'termsOfService': "Términos de servicio",
      'and': " y ",
      'privacyPolicy': "Política de privacidad",

      // Settings
      'settings': "Ajustes",
      'help': "Ayuda",
      'rateUs': "Califícanos",
      'rateUsOnGooglePlay': "Califícanos en Google Play",
      'referToFriend': "Recomendar a un amigo",
      'shareWithFriends': "Compartir con amigos",
      'logout': "Cerrar sesión",
      'deleteAccount': "Eliminar cuenta",
      'deleteAccountAndData': "Eliminar cuenta y datos",
      'reauthenticatePrompt': "Por favor vuelve a autenticarte para continuar.",
      'reauthenticate': "Reautenticar",
      'error': "Error",
      'pleaseEnterPassword': "Por favor introduce tu contraseña.",

      // Home
      'hi': "Hola",
      'currentStreak': "Racha actual",
      'wordsLearned': "Palabras aprendidas",
      'days': "días",
      'currentLevel': "Nivel actual",
      'introduction': "Introducción",
      'startLearning': "Comenzar a aprender",
      'continueLearning': "Continuar aprendiendo",
      'learnByLevel': "Aprender por nivel",
      'seeAll': "Ver todo",

      // Practice Cards
      'selectScenario': "Práctica de Escenarios",
      'practiceRealConversations': "Practica conversaciones reales con IA",
      'explore': "Explorar",
      'freeTalkTitle': "Hablar Libremente",
      'talkAboutAnything': "Habla de cualquier tema con la IA",
      'startNow': "Comenzar Ahora",
      'conversationProgress': "Progreso de la Conversación",
      'lessons': "Lecciones",
      'levelLessons': "Lecciones del nivel",
      'completed': "Completado",
      'retest': "Reevaluar",
      'close': "Cerrar",
      'youGot': "Obtuviste: ",
      'yourCurrentStreakIs': "Tu racha actual es",

      // Level Bottom Sheet
      'a1Beginner': "A1 Principiante",
      'a1Description': "Comienza a aprender el idioma",
      'a2Elementary': "A2 Elemental",
      'a2Description': "Puedes comunicarte con frases sencillas",
      'b1Intermediate': "B1 Intermedio",
      'b1Description': "Puedes describir situaciones y expresar ideas",
      'b2UpperIntermediate': "B2 Intermedio alto",
      'b2Description':
          "Puedes entender textos complejos y comunicarte con fluidez",
      'c1Advanced': "C1 Avanzado",
      'c1Description': "Puedes comunicarte con hablantes nativos con fluidez",
      'c2Expert': "C2 Experto",
      'c2Description': "Manejas el idioma a un nivel casi nativo",

      // Tabs
      'progress': "Progreso",
      'practice': "Práctica",
      'freeTalk': "Conversación libre",
      'freeTalkDescription':
          "Practica hablando sobre cualquier tema que prefieras.",
      'startFreeTalk': "Iniciar conversación libre",
      'profile': "Perfil",
      'exit': "Salir",
      'pressAgainToExit': "Pulsa de nuevo para salir",

      // Onboarding
      'previous': "Anterior",
      'next': "Siguiente",
      'back': "Atrás",
      'tellUsAboutYourself': "Cuéntanos sobre ti",
      'helpUsPersonalize': "Ayúdanos a personalizar tu experiencia",

      // Lessons
      'levelUnlockTest': "Prueba de desbloqueo",
      'welcomeToTheLesson': "Bienvenido a la lección",
      'unlockTestScoreRequirement':
          "Necesitas más del 80% para desbloquear este nivel",
      'level': "Nivel",
      'start': "Comenzar",
      'vocabulary': "Vocabulario",
      'grammarTips': "Consejos de gramática",
      'testYourKnowledge': "Prueba tus conocimientos",
      'noVocabularyAvailable': "No hay vocabulario disponible",
      'noGrammarTipsAvailable': "No hay consejos de gramática disponibles",
      'autoSpeak': "Lectura automática",
      'prev': "Anterior",
      'done': "Listo",
      'meaning': "Significado:",
      'exampleSentences': "Frases de ejemplo",
      'listen': "Escuchar",
      'check': "Comprobar",
      'word': "Palabra",
      'tip': "Consejo",
      'startQuiz': "Iniciar Quiz",
      'question': "Pregunta",

      // Answer Result
      'correctAnswer': "Respuesta correcta",
      'wrongAnswer': "Respuesta incorrecta",

      // Lesson Exit Alerts
      'exitUnlockTestWarning':
          "Si sales ahora, se dará por terminada la prueba. No podrás volver a intentarla durante 24 horas. ¿Seguro que quieres salir?",
      'exitLessonConfirmation':
          "¿Seguro que quieres salir y perder tu progreso actual?",
      'continueTest': "Continuar prueba",
      'exitAndDiscard': "Salir y descartar",

      // Speaking Question
      'tapToStop': "Toca para detener",
      'processing': "Procesando...",
      'listening': "Escuchando...",

      // Result
      'lessonCompleted': "Lección completada",
      'accuracy': "Precisión",
      'timeTaken': "Tiempo usado",

      // Practice
      'speakingPractice': "Práctica de habla",
      'practiceWithNatasha': "Practicar con Natasha",
      'selectScenarioToStart': "Selecciona un escenario para comenzar",
      'downloadingNatashaAI': "Descargando Natasha AI...",
      'downloadInfo':
          "La descarga pesa alrededor de 60 MB. Mantén la app abierta.",
      'gems': "Gemas",
      'startPractice': "Iniciar práctica",
      'viewResults': "Ver resultados",

      // Chat Exit
      'exitChatConfirmation': "¿Deseas finalizar la conversación?",
      'closeAndDiscard': "Cerrar y descartar",

      // Practice Result
      'score': "Puntuación",
      'fluency': "Fluidez",
      'grammar': "Gramática",
      'pronunciationLabel': "Pronunciación",
      'totalSpeakingTime': "Tiempo total hablando",
      'suggestion': "Sugerencia",
      'detailedFeedback': "Retroalimentación detallada",
      'minutes': "minutos",

      // Dialogs
      'areYouSureLogout': "¿Seguro que deseas cerrar sesión?",
      'yes': "Sí",
      'cancel': "Cancelar",
      'openSettings': "Abrir ajustes",
      'areYouSureDeleteAccount':
          "¿Seguro que deseas eliminar tu cuenta?\n\nEsta acción es irreversible.",
      'delete': "Eliminar",
      'levelLockedMessage':
          "Este nivel está bloqueado. Completa los niveles anteriores o realiza la prueba para desbloquearlo.",
      'unlock': "Desbloquear",
      'view': "Ver",
      'unlockTest': "Prueba de desbloqueo",
      'canUnlockIn': "Podrás desbloquear en:",
      'hours': "horas",
      'startingPracticeWillUse': "Comenzar esta práctica consumirá 100 gemas.",
      'watchAdGetGems': "Ver anuncio y obtener 100 gemas",

      // Review Screen
      'pleaseRateYourExperience': "Por favor califica tu experiencia",
      'didYouLikeTheSession': "¿Te gustó la sesión? 🔥",
      'yesLovedIt': "¡Sí, estuvo increíble! 💯",
      'notReally': "No mucho, la verdad",
      'thankYouFeedback': "¡Gracias por ser honesto! Lo tenemos en cuenta. 🙏",
      'feedbackDone': "Listo",

      // Free Talk Screen Enhanced
      'freeTalkWhyTitle': "¿Por qué Conversación Libre?",
      'freeTalkFeature1Title': "Temas ilimitados",
      'freeTalkFeature1Desc': "Habla de lo que más te interese",
      'freeTalkFeature2Title': "Con IA",
      'freeTalkFeature2Desc': "Conversaciones inteligentes con Natasha AI",
      'freeTalkFeature3Title': "Retroalimentación instantánea",
      'freeTalkFeature3Desc': "Consejos en tiempo real para mejorar",
      'freeTalkTopicsTitle': "¿Necesitas inspiración?",
      'freeTalkTopic1': "Mis pasatiempos",
      'freeTalkTopic2': "Planes de viaje",
      'freeTalkTopic3': "Películas favoritas",
      'freeTalkTopic4': "Rutina diaria",
      'freeTalkTopic5': "Trabajo soñado",
      'freeTalkTopic6': "Planes del fin de semana",

      // Settings Screen Enhanced
      'settingsAppSection': "AJUSTES DE LA APP",
      'settingsSupportSection': "SOPORTE",
      'settingsAccountSection': "CUENTA",
      'settingsLanguage': "Idioma de la app",
      'settingsLogoutSubtitle': "Cerrar sesión de tu cuenta",
      'settingsLevel': "Nivel",
      'settingsWords': "Palabras",
      'vocabularyBuilder': "Constructor de Vocabulario",
      'vocabularyBuilderSubtitle':
          "Practica pronunciación y domina nuevas palabras con confianza.",
      'pronunciationPractice': "Práctica de Pronunciación",
      'pronunciationPracticeSubtitle':
          "Mejora la claridad al hablar y suena más natural.",
      'vocabularyPractice': "Práctica de Vocabulario",
      'vocabularyPracticeSubtitle':
          "Aprende y repasa palabras útiles para conversaciones diarias.",

      // Preparing Screen
      'preparingTitle': "Creando tu plan de aprendizaje perfecto",
      'preparingSubtitle': "Personalizando para ti",
      'downloadingLessons': "Personalizando lecciones de IA para ti",
      'extractingLessons': "Configurando tu contenido de aprendizaje",
      'preparingComplete': "Listo para aprender",
      'errorOccurred': "Algo salió mal",
      'downloadError':
          "Error al descargar las lecciones. Por favor verifica tu conexión a internet e inténtalo de nuevo.",
      'retry': "Reintentar",
    },
  };
}
