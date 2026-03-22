class PostHogEvents {
  static const String appOpened = 'app_opened';
  static const String appClosed = 'app_closed';
  
  static const String userSignedUp = 'user_signed_up';
  static const String userLoggedIn = 'user_logged_in';
  static const String userLoggedOut = 'user_logged_out';
  static const String userProfileUpdated = 'user_profile_updated';
  
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String onboardingQuestionAnswered = 'onboarding_question_answered';
  static const String onboardingSkipped = 'onboarding_skipped';
  
  static const String lessonQnaStarted = 'lesson_qna_started';
  static const String lessonCompleted = 'lesson_completed';
  static const String lessonExited = 'lesson_exited';
  static const String lessonIntroViewed = 'lesson_intro_viewed';
  static const String grammarTipsViewed = 'grammar_tips_viewed';
  static const String vocabularyViewed = 'vocabulary_viewed';
  static const String questionAnswered = 'question_answered';
  static const String mcqOptionSelected = 'mcq_option_selected';
  static const String speakOptionUsed = 'speak_option_used';
  static const String sentenceRearranged = 'sentence_rearranged';
  static const String unlockEnglishLevelTestStarted = 'unlock_english_level_test_started';
  
  static const String practiceStarted = 'practice_started';
  static const String practiceCompleted = 'practice_completed';
  static const String practiceExited = 'practice_exited';
  static const String scenarioSelected = 'scenario_selected';
  static const String chatMessageSent = 'chat_message_sent';
  static const String audioRecordingStarted = 'audio_recording_started';
  static const String audioRecordingStopped = 'audio_recording_stopped';
  static const String practiceResultViewed = 'practice_result_viewed';
  
  static const String aiChatOpened = 'ai_chat_opened';
  static const String aiChatMessageSent = 'ai_chat_message_sent';
  static const String aiChatResponseReceived = 'ai_chat_response_received';
  
  static const String homeScreenViewed = 'home_screen_viewed';
  static const String levelInfoViewed = 'level_info_viewed';
  static const String streakViewed = 'streak_viewed';
  static const String lessonListViewed = 'lesson_list_viewed';
  static const String lessonCardClicked = 'lesson_card_clicked';
  
  static const String settingsOpened = 'settings_opened';
  static const String settingsOptionClicked = 'settings_option_clicked';
  static const String accountDeleted = 'account_deleted';
  static const String privacyPolicyViewed = 'privacy_policy_viewed';
  static const String termsViewed = 'terms_viewed';
  
  static const String tabChanged = 'tab_changed';
  static const String shareButtonClicked = 'share_button_clicked';
  static const String reviewSubmitted = 'review_submitted';
  
  static const String errorOccurred = 'error_occurred';
  static const String apiCallFailed = 'api_call_failed';
  static const String authenticationError = 'authentication_error';
  static const String whisperError = 'whisper_error';
  static const String networkError = 'network_error';
  static const String permissionDenied = 'permission_denied';
  static const String firebaseError = 'firebase_error';
  static const String appwriteError = 'appwrite_error';
  static const String audioError = 'audio_error';
  static const String speechRecognitionError = 'speech_recognition_error';
  static const String ttsError = 'tts_error';
  
  static const String buttonClicked = 'button_clicked';
  static const String linkClicked = 'link_clicked';
  static const String cardClicked = 'card_clicked';
  static const String dialogOpened = 'dialog_opened';
  static const String dialogClosed = 'dialog_closed';
  static const String bottomSheetOpened = 'bottom_sheet_opened';
  static const String bottomSheetClosed = 'bottom_sheet_closed';
  static const String navigationOccurred = 'navigation_occurred';
  
  static const String adLoaded = 'ad_loaded';
  static const String adFailedToLoad = 'ad_failed_to_load';
  static const String adShown = 'ad_shown';
  static const String adClicked = 'ad_clicked';
  static const String adClosed = 'ad_closed';
  
  static const String audioPlayed = 'audio_played';
  static const String audioPaused = 'audio_paused';
  static const String audioStopped = 'audio_stopped';
  
  static const String whisperModelLoaded = 'whisper_model_loaded';
  static const String whisperTranscriptionStarted = 'whisper_transcription_started';
  static const String whisperTranscriptionCompleted = 'whisper_transcription_completed';
  static const String whisperTranscriptionFailed = 'whisper_transcription_failed';
  
  static const String firestoreReadPerformed = 'firestore_read_performed';
  static const String firestoreWritePerformed = 'firestore_write_performed';
  static const String firestoreUpdatePerformed = 'firestore_update_performed';
  static const String firestoreDeletePerformed = 'firestore_delete_performed';
  
  static const String remoteConfigFetched = 'remote_config_fetched';
  static const String remoteConfigActivated = 'remote_config_activated';
  static const String deepInfraTranscribe = 'deepinfra_transcribe';

  static const String freeTalkScreenViewed = 'free_talk_screen_viewed';
  static const String freeTalkStarted = 'free_talk_started';
  static const String freeTalkCompleted = 'free_talk_completed';

  static const String notificationPermissionGranted = 'notification_permission_granted';
  static const String notificationPermissionDenied = 'notification_permission_denied';
  static const String notificationScheduled = 'notification_scheduled';
  static const String notificationScheduleFailed = 'notification_schedule_failed';
  static const String notificationTimezoneError = 'notification_timezone_error';
}