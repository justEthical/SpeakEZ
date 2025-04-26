import 'package:speak_ez/Constants/app_assets.dart';

class OnboarindViewModel {
  final String title;
  final String description;
  final String lottieAnimation;

  OnboarindViewModel({
    required this.title,
    required this.description,
    required this.lottieAnimation,
  });
}

List<OnboarindViewModel> onBoardingItems = [
  OnboarindViewModel(
    title: "Speak with Confidence",
    description:
        "Learn to express yourself clearly in interviews, meetings, and real life",
    lottieAnimation: AppAssets.onboaring1
  ),
  OnboarindViewModel(
    title: "Unlock Global Opportunities",
    description:
        "Get fluent English skills to study or work abroad with confidence",
    lottieAnimation: AppAssets.onboaring2
  ),
  OnboarindViewModel(
    title: "Crack the IELTS Exam",
    description: "Master speaking, writing, and listening with AI-powered practice tools.",
    lottieAnimation: AppAssets.onboaring3
  )
];
