import 'package:get/get.dart';

class OnboardingQuestion {
  final String id;
  final String question;
  final List<String> options;

  /// Optional soft line under the headline (e.g. "Is this true for you?").
  final String? subtitle;

  /// First-person "pain statement" screens are rendered with extra emphasis so
  /// the user recognises themselves in the headline (Learna-style mirroring).
  final bool isStatement;

  OnboardingQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.subtitle,
    this.isStatement = false,
  });
}

var onboardingQuestions = <OnboardingQuestion>[
  // ── Emotional hook: the "why". Investment + relatability. ──────────────
  OnboardingQuestion(
    id: 'motivation',
    question: 'Why do you want to learn English?',
    subtitle: 'This helps us shape your plan.',
    options: [
      '💬 Speak confidently in daily life',
      '💼 Job interviews & career',
      '✈️ Travel & meeting new people',
      '🎓 Exams or school',
      '📈 Better grammar & vocabulary',
    ],
  ),

  // ── Pain-statement mirroring: "this app gets me". ─────────────────────
  OnboardingQuestion(
    id: 'painFreeze',
    question: 'I understand English, but I freeze when it\'s time to speak.',
    subtitle: 'Is this true for you?',
    isStatement: true,
    options: ['Yes, that\'s me', 'Sometimes', 'Not really'],
  ),
  OnboardingQuestion(
    id: 'painWords',
    question: 'I get stuck mid-sentence because I can\'t find the right words.',
    subtitle: 'Is this true for you?',
    isStatement: true,
    options: ['Yes, that\'s me', 'Sometimes', 'Not really'],
  ),
  OnboardingQuestion(
    id: 'painFear',
    question: 'I avoid speaking English because I\'m scared of mistakes.',
    subtitle: 'Is this true for you?',
    isStatement: true,
    options: ['Yes, that\'s me', 'Sometimes', 'Not really'],
  ),

  // ── Area to improve → picks the landing focus. ───────────────────────
  OnboardingQuestion(
    id: 'focusArea',
    question: 'What do you most want to improve?',
    subtitle: 'We\'ll put this front and centre for you.',
    options: [
      '🗣️ Speaking fluently',
      '👂 Listening & understanding',
      '📚 Vocabulary',
    ],
  ),

  // ── Logistics (existing profile fields). ─────────────────────────────
  OnboardingQuestion(
    id: 'confidence',
    question: 'How confident are you speaking English right now?',
    options: [
      'Not confident at all',
      'A little confident',
      'Fairly confident',
      'Very confident',
    ],
  ),
  OnboardingQuestion(
    id: 'dailyStudyDuration',
    question: 'How much time can you practise each day?',
    subtitle: 'Even a few minutes builds a streak.',
    options: [
      '5 minutes',
      '10 minutes',
      '15 minutes',
      '30 minutes',
    ],
  ),
  OnboardingQuestion(
    id: 'preferredPracticeTime',
    question: 'When should we remind you to practise?',
    // NOTE: option order is load-bearing — _resolvePracticeTime maps
    // first→08:00, [1]→12:00, else→18:00, last→custom picker.
    options: [
      '🔅 Morning 8:00 AM',
      '☀️ Afternoon 12:00 PM',
      '🌙 Evening 6:00 PM',
      '⏰ Pick a time',
    ],
  ),
].obs;
