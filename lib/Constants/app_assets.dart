class AppAssets {
  static String _getFullLottiePath(String name) => "assets/lottie/$name";
  static String _getFullImagePath(String name) => "assets/images/$name";

  // lottie animations
  static String get onboaring1 => _getFullLottiePath("first.lottie");
  static String get onboaring2 => _getFullLottiePath("third.lottie");
  static String get onboaring3 => _getFullLottiePath("second.lottie");
  static String get exitAlert => _getFullLottiePath("exit_alert.lottie");
  static String get confetti => _getFullLottiePath("confetti.lottie");
  static String get owl => _getFullLottiePath("owl.lottie");
  static String get correctAnswer => _getFullLottiePath("correct.lottie");
  static String get wrongAnswer => _getFullLottiePath("wrong.lottie");
  static String get chatting => _getFullLottiePath("chating.lottie");
  static String get recording => _getFullLottiePath("recording.lottie");
  static String get downloading => _getFullLottiePath("downloading.lottie");
  static String get mic => _getFullLottiePath("mic.lottie");

  //Audio files
  static String get correct => "correct.mp3";
  static String get incorrect => "incorrect.mp3";

  // images
  static String get logo => _getFullImagePath("logo.png");
  static String get google => _getFullImagePath("google.png");
  static String get fb => _getFullImagePath("fb.png");
  static String get settings => _getFullImagePath("settings.svg");

  // profile
  static String helpCircle = _getFullImagePath('help-circle.svg');
  static String starIcon = _getFullImagePath('star.svg');
  static String giftIcon = _getFullImagePath('gift.svg');
  static String logOut = _getFullImagePath('log-out.svg');
  static String deleteIcon = _getFullImagePath('trash.svg');

  // Home
  static String flame = _getFullImagePath('flame-icon.svg');
  static String medal = _getFullImagePath('medal-icon.svg');

  // practice
  static String get jobInterview => _getFullImagePath("job_interview.svg");
  static String get orderingFood => _getFullImagePath("ordering_food.svg");
  static String get makingFriends => _getFullImagePath("making_friends.svg");
  static String get askingDirections =>
      _getFullImagePath("asking_directions.svg");
  static String get shopping => _getFullImagePath("shopping.svg");
  static String get atTheDoctor => _getFullImagePath("at_the_doctor.svg");
  static String get phoneCalls => _getFullImagePath("phone_calls.svg");
  static String get dailyEnglish => _getFullImagePath("daily_english.svg");
  static String get travel => _getFullImagePath("travel.svg");
  static String get inTheClassroom => _getFullImagePath("in_the_classroom.svg");
  static String get dailyRoutine => _getFullImagePath("daily_routine.svg");
  static String get makingPlans => _getFullImagePath("making_plans.svg");
  static String get festivals => _getFullImagePath("festivals.svg");
  static String get workplaceTalk => _getFullImagePath("workplace_talk.svg");
  static String get usingTechnology =>
      _getFullImagePath("using_technology.svg");
  static String get parentTeacher => _getFullImagePath("parent_teacher.svg");
  static String get banking => _getFullImagePath("banking.svg");
  static String get publicTransport =>
      _getFullImagePath("public_transport.svg");
  static String get weather => _getFullImagePath("weather.svg");
  static String get talkingFood => _getFullImagePath("talking_food.svg");
  static String get natashaChat => _getFullImagePath("natasha_chat.png");

  // Practice Result
  static String get fluency => _getFullImagePath("fluency.svg");
  static String get grammar => _getFullImagePath("grammer.svg");
  static String get vocabulary => _getFullImagePath("vocabulary.svg");
  static String get totalSpeakingTime => _getFullImagePath("total_speaking_time.svg");
}
