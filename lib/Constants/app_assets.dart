class AppAssets {
  static String _getFullLottiePath(String name) => "assets/lottie/$name";
  static String _getFullImagePath(String name) => "assets/images/$name";

  // lottie animations
  static String get onboaring1 => _getFullLottiePath("first.lottie");
  static String get onboaring2 => _getFullLottiePath("third.lottie");
  static String get onboaring3 => _getFullLottiePath("second.lottie");

  // images
  static String get logo => _getFullImagePath("logo.png");
  static String get google => _getFullImagePath("google.png");
  static String get fb => _getFullImagePath("fb.png");
}
