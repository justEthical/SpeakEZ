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
}
