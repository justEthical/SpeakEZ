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

final List<OnboardingQuestion> onboardingQuestions = [
  OnboardingQuestion(
    id: 'userType',
    question: 'What best describes you?',
    options: [
      'Student',
      'Working Professional',
      'Job Seeker',
      'Homemaker / Casual Learner',
      'Other',
    ],
  ),
  OnboardingQuestion(
    id: 'motivation',
    question: 'Why do you want to learn English?',
    options: [
      'To speak fluently and confidently',
      'For job interviews or work communication',
      'For travel or international conversations',
      'To improve grammar and vocabulary',
      'Just learning for fun',
    ],
  ),
  OnboardingQuestion(
    id: 'confidence',
    question: 'How confident are you speaking in English?',
    options: [
      'Not confident at all',
      'A little confident',
      'Very confident',
    ],
  ),
  OnboardingQuestion(
    id: 'preferredPractice',
    question: 'How do you want to practice?',
    options: [
      'Speaking with AI',
      'Writing and grammar correction',
      'Mini games / quizzes',
      'Daily lessons / challenges',
    ],
  ),
];
