import 'package:get/get.dart';

class OnboardingQuestion {
  final String id;
  final String question;
  final List<String> options;

  OnboardingQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

var  onboardingQuestions = [
  // OnboardingQuestion(
  //   id: 'userType',
  //   question: 'What best describes you?',
  //   options: [
  //     'Student',
  //     'Working Professional',
  //     'Job Seeker',
  //     'Homemaker / Casual Learner',
  //     'Other',
  //   ],
  // ),
  // OnboardingQuestion(
  //   id: 'motivation',
  //   question: 'Why do you want to learn English?',
  //   options: [
  //     'Speak fluently and confidently',
  //     'Job interviews or work',
  //     'For travel or international conversations',
  //     'Improve grammar and vocabulary',
  //     'School or college',
  //     'Just learning for fun',
  //   ],
  // ),
  OnboardingQuestion(
    id: 'confidence',
    question: 'How confident are you speaking in English?',
    options: [
      'Not confident at all',
      'A little confident',
      'Very confident',
      'Fluent in English',
    ],
  ),
  OnboardingQuestion(
    id: 'dailyStudyDuration',
    question: 'How much time can you study daily?',
    options: [
      '5 minutes',
      '10 minutes',
      '15 minutes',
      '30 minutes',
    ],
  ),
  OnboardingQuestion(
    id: 'preferredPracticeTime',
    question: 'When would you like to practice? We’ll remind you then.',
    options: [
      '🔅 Morning 8:00 AM',
      '☀️ Afternoon 12:00 PM',
      '🌙 Evening 6:00 PM',
      '⏰ Pick a time',
    ],
  ),
  // OnboardingQuestion(
  //   id: 'preferredPractice',
  //   question: 'How do you want to practice?',
  //   options: [
  //     'Speaking with AI',
  //     'Writing and grammar correction',
  //     'Mini games / quizzes',
  //     'Daily lessons / challenges',
  //   ],
  // ),
].obs;
