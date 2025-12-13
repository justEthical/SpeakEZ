import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Models/country_languages.dart';
import 'package:speak_ez/Models/scenario_model.dart';

class AppData {
  static const Map<String, List<String>> lessonNames = {
    "A1": [
      "Greetings & Introductions",
      "Numbers & Counting",
      "Days of the Week",
      "Months & Dates",
      "Family Members",
      "Describing People (appearance)",
      "Colors",
      "Classroom Objects",
      "School Subjects",
      "My House / Home",
      "Rooms & Furniture",
      "Clothes & Accessories",
      "Food & Drinks",
      "In the Kitchen",
      "Animals (pets & farm)",
      "Wild Animals",
      "Fruits & Vegetables",
      "Body Parts",
      "Hobbies & Free-time Activities",
      "Sports",
      "Daily Routine",
      "Telling the Time",
      "Weather & Seasons",
      "Feelings & Emotions",
      "Asking & Giving Directions",
      "Places in Town",
      "Transport",
      "Jobs & Occupations",
      "Shopping",
      "Money & Prices",
      "Phone & Technology",
      "Countries & Nationalities",
      "Languages",
      "My Body & Health",
      "At the Doctor",
      "At the Restaurant",
      "At the Supermarket",
      "At the Park",
      "Making Plans",
      "Invitations & Replies",
      "Likes & Dislikes",
      "Describing Objects",
      "Talking with friends",
      "Simple Past Actions",
      "My City / Village",
      "On Holiday / Vacations",
      "Festivals & Special Days",
      "Reading a Simple Map",
      "Public Transport",
      "Asking for Help",
    ],
    "A2": [
      "Personal Information",
      "Describing Feelings & Emotions",
      "Describing Daily Routines",
      "Talking About the Past (simple past regular/irregular)",
      "Future Plans (going to, will)",
      "Describing People (character/personality)",
      "Comparing People and Things",
      "Giving Reasons (because, so)",
      "Talking About Experiences",
      "Talking About Hobbies & Interests",
      "Talking About Your Weekend",
      "Making Appointments",
      "Ordering Food & Drink",
      "Shopping for Clothes",
      "Shopping for Groceries",
      "Asking for & Giving Advice",
      "Asking for Permission",
      "Making Requests",
      "Giving & Following Instructions",
      "Describing Places (city, countryside, neighborhood)",
      "At the Hotel",
      "At the Airport",
      "At the Train Station",
      "Travel and Transport",
      "Describing Weather & Climate",
      "Talking About Your Country",
      "Festivals and Celebrations",
      "Describing Past Holidays",
      "Making Suggestions",
      "Inviting and Accepting/Refusing",
      "Health Problems & Remedies",
      "Talking About Schedules & Timetables",
      "Describing Events (parties, concerts, meetings)",
      "Explaining a Problem",
      "Describing Habits",
      "Talking About Technology (gadgets, apps, internet)",
      "Using Social Media",
      "Writing Emails and Messages",
      "Talking About Hopes and Dreams",
      "Expressing Likes, Dislikes, Preferences",
      "Agreeing and Disagreeing",
      "Expressing Opinions",
      "Describing Actions in Progress (present continuous)",
      "Making Plans for the Weekend",
      "Describing Food & Recipes",
      "Describing Films and Books",
      "Talking About the Environment",
      "Giving Directions (more complex)",
      "Public Services (post office, police, bank)",
      "Describing Accidents & Emergencies",
    ],
    "B1": [
      "Describing Life Experiences",
      "Talking About Education & Studies",
      "Discussing Work & Professions",
      "Dealing with Problems & Solutions",
      "Describing Personal Qualities",
      "Making & Justifying Choices",
      "Describing Daily & Weekly Routines",
      "Talking About News & Current Events",
      "Describing Cities & Countryside",
      "Talking About Relationships & Friendship",
      "Describing Social Media Habits",
      "Discussing Rules & Obligations",
      "Explaining Problems with Solutions",
      "Telling Stories (past experiences)",
      "Describing a Process (how to…)",
      "Giving Detailed Directions",
      "Describing Events & Festivals",
      "Discussing Hobbies & Free Time in Detail",
      "Describing Feelings in Different Situations",
      "Talking About Future Predictions",
      "Arranging & Cancelling Plans",
      "Giving Compliments & Responding",
      "Describing Food, Cooking, & Eating Out",
      "Describing Accommodation (houses, apartments)",
      "Talking About Transport & Travel Experiences",
      "Discussing Environmental Issues",
      "Expressing Hopes & Ambitions",
      "Describing Films, TV, & Books in Detail",
      "Explaining Cultural Traditions",
      "Talking About Accidents & Incidents",
      "Making and Responding to Complaints",
      "Handling Difficult Conversations",
      "Expressing Agreement & Disagreement (in detail)",
      "Discussing Success & Failure",
      "Describing Festivals from Other Countries",
      "Describing Changes Over Time",
      "Giving Advice & Recommendations",
      "Describing Health & Fitness",
      "Talking About Technology & Gadgets",
      "Expressing Preferences & Reasons",
      "Making Comparisons (people, places, things)",
      "Describing Personal Achievements",
      "Handling Emergencies (in more detail)",
      "Discussing Shopping Habits",
      "Talking About Money Management",
      "Talking About News Stories",
      "Describing Problems with Public Services",
      "Writing Formal & Informal Emails",
      "Explaining Procedures (step by step)",
      "Talking About Art, Music, & Literature",
      // "Making Arrangements for Meetings",
    ],
    "B2": [
      "Second Conditional (Hypothetical Presents)",
      "Third Conditional (Hypothetical Past Outcomes)",
      "Mixed Conditionals (Time Shifts)",
      "Reported Speech: Statements & Questions",
      "Reported Speech: Reporting Verbs & Backshift",
      "Passives Across Tenses (Process vs. Result)",
      "Causatives: Have/Get Something Done",
      "Relative Clauses: Defining vs. Non-Defining",
      "Participle Clauses (Intro to Reduction)",
      "Gerunds vs. Infinitives (Preference & Purpose)",
      "Modals of Deduction (Present & Past)",
      "Modals of Obligation & Advice (Must/Have to/Should)",
      "Inversion with Negative Adverbials (Not until…)",
      "Ellipsis & Substitution in Spoken English",
      "Comparatives for Trends & Changes",
      "Linkers for Contrast & Reason (Although/Despite)",
      "Concession & Hedging (Even though/Kind of)",
      "Phrasal Verbs for Work & Projects",
      "Phrasal Verbs for Travel & Logistics",
      "Phrasal Verbs for Relationships & Emotions",
      "Collocations: Business & Productivity",
      "Collocations: Technology & Media",
      "Nuanced Vocabulary: Opinion & Evaluation",
      "Narratives: Sequencing Past Events",
      "Problem-Solving: Explaining Issues Clearly",
      "Negotiating & Reaching Agreements",
      "Making Formal Complaints & Resolutions",
      "Presentations: Signposting & Emphasis",
      "Email Tone: Neutral-Formal Requests",
      "Job Interviews: Evidence-Based Answers",
      "Data Talk: Describing Graphs & Trends",
      "Sustainability & Environment (Debate Skills)",
      "Health & Well-Being (Advice & Risk)",
      "Education & Learning (Comparing Systems)",
      "Culture & Identity (Balanced Opinions)",
      "Media Literacy: Fact vs. Opinion",
      "Technology Ethics (Pros, Cons, Trade-offs)",
      "Travel Problems & Solutions (Casework)",
      "Workplace Scenarios: Conflicts & Feedback",
      "Project Updates & Status Reports",
      "Explaining Procedures Step by Step",
      "Future in the Past (Was going to / Would)",
      "Future Forms Review (Will/Going to/Cont.)",
      "Discourse Markers for Flow (Anyway/By the way)",
      "Register: Semi-formal vs. Informal",
      "Precision with Quantifiers & Approximators",
      "Emphasis with Cleft Sentences (It is/What…)",
      "Adverbial Clauses of Time & Reason",
      "Conditionals in Polite Offers & Suggestions",
      "Exam Skills: Paraphrasing & Reformulation",
      "Fluency Clinic: Pausing & Chunking",
    ],
    "C1": [
      "Advanced Passives (Reporting/Beliefs/It is said…)",
      "Complex Noun Phrases & Nominalization",
      "Participle Clauses & Reduced Relatives",
      "Inversion for Emphasis & Style",
      "Fronting & Thematic Progression",
      "Concession & Contrast at Scale (Whereas/While)",
      "Stance & Evaluation (Apparently/Arguably)",
      "Hedging & Caution (Tend to/Relatively/Supposedly)",
      "Precision with Modality (Epistemic vs. Deontic)",
      "Subjunctive & Formulaic Formality",
      "Complex Conditionals in Reasoning",
      "Reported Speech: Nuanced Reporting Verbs",
      "Metaphor & Figurative Language in Opinion",
      "Advanced Collocations (Academic & Business)",
      "Discourse Markers for Argumentation",
      "Cohesion: Reference Chains & Substitution",
      "Ellipsis & Parallelism in Writing",
      "Paragraph Architecture & Topic Sentences",
      "Summarizing & Synthesizing Sources",
      "Counter-Arguments & Rebuttals",
      "Cause–Effect Essays (Linguistic Signalling)",
      "Problem–Solution Reports (Executive Style)",
      "Data Commentary (Charts, Tables, Infographics)",
      "Critical Reviews (Books/Films/Products)",
      "Policy Briefs: Recommendations & Risks",
      "Professional Emails: Persuasion & Politeness",
      "Meeting Skills: Chairing & Facilitation",
      "Negotiation Language: Trade-offs & Concessions",
      "Cross-Cultural Pragmatics & Politeness",
      "Register Shifts: Formal, Neutral, Informal",
      "Public Speaking: Rhetorical Devices",
      "Storytelling for Business & Advocacy",
      "Academic Integrity: Paraphrase & Citation",
      "Evaluating Evidence & Source Quality",
      "Discourse of Technology & AI Ethics",
      "Climate & Sustainability: Nuanced Debate",
      "Health Policy & Public Communication",
      "Economics & Work Futures (Gig/Remote)",
      "Media Discourses: Bias & Framing",
      "Legal & Policy Language (Plain-Englishing)",
      "Error Typology: Fossilized vs. Developmental",
      "Pronunciation: Sentence Stress & Prominence",
      "Prosody: Intonation for Attitude",
      "Fluency: Chunking & Formulaic Sequences",
      "Idiomaticity in Professional Contexts",
      "Multi-word Verbs: Nuance & Register",
      "Preposition Patterns in Academic English",
      "Complex Time & Aspect Nuances",
      "Editing for Clarity, Concision, Cohesion",
      "Exam Strategies: Synthesis & Evaluation Tasks",
    ],
    "C2": [
      "Near-Native Pragmatics: Implicature & Inference",
      "Rhetorical Precision: Framing & Reframing",
      "High-Level Stance: Nuance & Calibration",
      "Advanced Inversion & Emphatic Structures",
      "Theme–Rheme Mastery & Information Flow",
      "Dense Nominal Style vs. Plain English",
      "Metadiscourse: Guiding the Reader/Listener",
      "Irony, Understatement, and Hyperbole",
      "Register Mastery: Legal/Academic/Journalistic",
      "Genre Blending & Voice Control",
      "Intertextuality & Allusion in Argument",
      "Lexical Sophistication: Low-Frequency Items",
      "Collocation Webs & Idiomatic Precision",
      "Metaphor Clusters in Abstract Topics",
      "Evaluation Language: Gradability & Scaling",
      "Hedging vs. Boosting: Strategic Choice",
      "Argument Architecture: Macro-Structure",
      "Counterfactual Reasoning at Length",
      "Complex Conditionals in Policy & Risk",
      "Advanced Passives & Agent Suppression",
      "Clefting & Pseudo-Clefts for Focus",
      "Nominalizations in Expert Discourse",
      "Compression Techniques: Ellipsis/Deletion",
      "Rhythm & Prosody for Persuasion",
      "Pronunciation: Subtle Reduction & Linking",
      "Debate Masterclass: Refutation & Pivoting",
      "Socratic Questioning & Dialectic",
      "Forensic Language: Precision & Caution",
      "Discourse Ethics & Bias Mitigation",
      "Reasoning with Uncertainty & Probability",
      "Data-Driven Argumentation & Caveats",
      "Policy Memos & Executive Summaries",
      "Opinion Columns & Editorial Style",
      "Grant/Proposal Writing: Persuasion & Evidence",
      "Peer Review & Professional Feedback",
      "Cultural Literacy & Allusive Language",
      "Humour & Wit: Pragmatic Boundaries",
      "Crisis Communication & Reputation",
      "Strategic Storytelling for Leadership",
      "Negotiation at C-suite Level: Subtext",
      "Cross-Register Style Shifts On the Fly",
      "Global Englishes: Audience Adaptation",
      "Error-Free Control in High Stakes",
      "Editing at C2: Style, Rhythm, Voice",
      "Paraphrase without Semantic Drift",
      "Summarize vs. Synthesize vs. Critique",
      "Interpreting Ambiguity & Polysemy",
      "Ethos/Pathos/Logos: Rhetoric in Practice",
      "Exam Peak: Synthesize Multiple Sources",
      "Capstone: Long-Form Seminar Presentation",
    ],
  };

  static List<ScenarioCategoryModel> scenarioCategories = [
    ScenarioCategoryModel(
      title: 'Daily Life & Routines',
      assetPath: AppAssets.dailyLifeRoutines,
    ),
    ScenarioCategoryModel(
      title: 'Family, Friends & Relationships',
      assetPath: AppAssets.familyFriendsRelationships,
    ),
    ScenarioCategoryModel(
      title: 'Food, Travel & Culture',
      assetPath: AppAssets.foodTravelCulture,
    ),
    ScenarioCategoryModel(
      title: 'Education & Learning',
      assetPath: AppAssets.educationLearning,
    ),
    ScenarioCategoryModel(
      title: 'Work, Business & Career',
      assetPath: AppAssets.workBusinessCareer,
    ),
    ScenarioCategoryModel(
      title: 'Shopping, Money & Services',
      assetPath: AppAssets.shoppingMoneyServices,
    ),
    ScenarioCategoryModel(
      title: 'Opinions, Emotions & Social Life',
      assetPath: AppAssets.opinionsEmotionsSocialLife,
    ),
    ScenarioCategoryModel(
      title: 'Technology & Modern Life',
      assetPath: AppAssets.technologyModernLife,
    ),
    ScenarioCategoryModel(
      title: 'Society, Environment & Global Issues',
      assetPath: AppAssets.societyEnvironmentGlobalIssues,
    ),
    ScenarioCategoryModel(
      title: 'Imagination, Creativity & Reflection',
      assetPath: AppAssets.imaginationCreativityReflection,
    ),
  ];

  static List<ScenarioModel> scenarios = [
    ScenarioModel(
      title: 'Talking About Yourself',
      description:
          'Introduce yourself and share basic personal information confidently.',
      imagePath: AppAssets.talkingAboutYourself,
      level: 'A1',
      category: 'Daily Life & Routines',
      prompt:
          'Act as a friendly stranger. Ask me to introduce myself, my name, where I live, and what I do.',
      intro:
          'Hi! I’m Natasha, your English partner. Let’s start with introductions — can you tell me a bit about yourself?',
    ),
    ScenarioModel(
      title: 'Daily Schedule',
      description:
          'Talk about your daily routine and what you do from morning to night.',
      imagePath: AppAssets.dailySchedule,
      level: 'A1',
      category: 'Daily Life & Routines',
      prompt:
          'Ask me to describe my daily activities and help me use correct tense forms.',
      intro:
          'Hello! Let’s talk about your day. What’s the first thing you do in the morning?',
    ),
    ScenarioModel(
      title: 'Weekend Plans',
      description: 'Discuss weekend activities and how you like to relax.',
      imagePath: AppAssets.weekendPlans,
      level: 'A2',
      category: 'Daily Life & Routines',
      prompt:
          'Pretend to be my friend. Ask about my weekend plans and suggest ideas for fun activities.',
      intro: 'Hey there! The weekend is coming — what are your plans?',
    ),
    ScenarioModel(
      title: 'Morning & Night Routine',
      description:
          'Describe what you usually do after waking up and before sleeping.',
      imagePath: AppAssets.morningAndNightRoutine,
      level: 'A1',
      category: 'Daily Life & Routines',
      prompt: 'Ask me to describe my morning and night routines step by step.',
      intro: 'Hi! I’m Natasha. Tell me — what’s your morning routine like?',
    ),
    ScenarioModel(
      title: 'Household Chores',
      description:
          'Talk about cleaning, cooking, and other daily household tasks.',
      imagePath: AppAssets.householdChores,
      level: 'A2',
      category: 'Daily Life & Routines',
      prompt:
          'Act as a roommate. Discuss how we can divide household chores fairly.',
      intro:
          'Hello! Let’s talk about home chores. Do you like cooking or cleaning?',
    ),
    ScenarioModel(
      title: 'Using Public Transport',
      description:
          'Practice talking about buses, trains, and commuting in English.',
      imagePath: AppAssets.usingPublicTransport,
      level: 'A2',
      category: 'Daily Life & Routines',
      prompt:
          'Act as a ticket officer. Ask me where I’m going and help me buy a ticket.',
      intro:
          'Hi there! I’m Natasha at the station — where are you travelling today?',
    ),
    ScenarioModel(
      title: 'Managing Time',
      description:
          'Learn to talk about schedules and balancing time effectively.',
      imagePath: AppAssets.managingTime,
      level: 'B1',
      category: 'Daily Life & Routines',
      prompt:
          'Act as a mentor. Ask me how I manage my time and suggest better ways.',
      intro:
          'Hey! I’m Natasha. Let’s talk about how you manage your time. Do you plan your day?',
    ),
    ScenarioModel(
      title: 'Health & Self-Care',
      description: 'Discuss health habits, fitness, and mental well-being.',
      imagePath: AppAssets.healthSelfCare,
      level: 'B1',
      category: 'Daily Life & Routines',
      prompt:
          'Act as a health coach. Ask me about my exercise and diet routines.',
      intro:
          'Hello! I’m Natasha, your health buddy. How do you take care of yourself every day?',
    ),
    ScenarioModel(
      title: 'Introducing Your Family',
      description: 'Learn to describe family members and their occupations.',
      imagePath: AppAssets.introducingYourFamily,
      level: 'A1',
      category: 'Family, Friends & Relationships',
      prompt:
          'Act as a new friend. Ask me to talk about my family and what they do.',
      intro:
          'Hi! I’m Natasha. Tell me about your family — who do you live with?',
    ),
    ScenarioModel(
      title: 'Describing People',
      description: 'Use adjectives to talk about appearance and personality.',
      imagePath: AppAssets.describingPeople,
      level: 'A2',
      category: 'Family, Friends & Relationships',
      prompt: 'Act as a curious friend. Ask me to describe someone I know.',
      intro:
          'Hey! I’m Natasha. Can you describe your best friend or a family member?',
    ),
    ScenarioModel(
      title: 'Friendship & Trust',
      description:
          'Talk about what makes a good friend and share friendship stories.',
      imagePath: AppAssets.friendshipTrust,
      level: 'B1',
      category: 'Family, Friends & Relationships',
      prompt: 'Act as my best friend. Discuss what friendship means to us.',
      intro: 'Hi! I’m Natasha. What do you think makes a true friend?',
    ),
    ScenarioModel(
      title: 'Talking About Childhood',
      description: 'Share memories and experiences from your early life.',
      imagePath: AppAssets.talkingAboutChildhood,
      level: 'B1',
      category: 'Family, Friends & Relationships',
      prompt: 'Act as a school friend. Ask me about my childhood memories.',
      intro:
          'Hey! I’m Natasha. Let’s talk about your childhood — what games did you love?',
    ),
    ScenarioModel(
      title: 'Celebrations & Family Events',
      description: 'Discuss birthdays, weddings, and family gatherings.',
      imagePath: AppAssets.celebrationsFamilyEvents,
      level: 'A2',
      category: 'Family, Friends & Relationships',
      prompt: 'Act as a cousin. Ask about how my family celebrates events.',
      intro: 'Hello! I’m Natasha. What’s your favorite family celebration?',
    ),
    ScenarioModel(
      title: 'Handling Conflicts Politely',
      description:
          'Practice resolving disagreements using calm, polite English.',
      imagePath: AppAssets.handlingConflictsPolitely,
      level: 'B2',
      category: 'Family, Friends & Relationships',
      prompt:
          'Act as a friend in conflict. Let’s practice apologizing and resolving problems.',
      intro:
          'Hey! I’m Natasha. Let’s learn to handle disagreements politely — shall we talk it out?',
    ),
    ScenarioModel(
      title: 'Talking About Relationships',
      description:
          'Discuss types of relationships and what makes them healthy.',
      imagePath: AppAssets.talkingAboutRelationships,
      level: 'B2',
      category: 'Family, Friends & Relationships',
      prompt:
          'Act as a counselor. Ask me how I maintain healthy relationships.',
      intro:
          'Hi! I’m Natasha. Let’s discuss relationships — what makes them strong and positive?',
    ),
    ScenarioModel(
      title: 'Ordering Food at a Restaurant',
      description:
          'Learn how to order, ask about menu items, and handle bills politely.',
      imagePath: AppAssets.orderingFoodAtARestaurant,
      level: 'A2',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a restaurant waiter. Take my order and ask follow-up questions about food and drinks.',
      intro:
          'Hi! I’m Natasha, your waiter for today. What would you like to order?',
    ),
    ScenarioModel(
      title: 'Describing Favorite Dishes',
      description: 'Talk about your favorite foods, ingredients, and flavors.',
      imagePath: AppAssets.describingFavoriteDishes,
      level: 'A2',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a food blogger. Ask me to describe my favorite dish and how it’s made.',
      intro:
          'Hello! I’m Natasha. Tell me — what’s your favorite dish and why do you love it?',
    ),
    ScenarioModel(
      title: 'Traveling Abroad',
      description:
          'Practice conversations at airports, immigration, and sightseeing spots.',
      imagePath: AppAssets.travelingAbroad,
      level: 'B1',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as an airport staff or tourist guide. Ask me travel questions and help me practice useful phrases.',
      intro:
          'Hi traveler! I’m Natasha at the airport. Where are you flying today?',
    ),
    ScenarioModel(
      title: 'Booking Hotels and Flights',
      description: 'Learn to make travel bookings and ask about facilities.',
      imagePath: AppAssets.bookingHotelsAndFlights,
      level: 'B1',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a hotel receptionist. Help me book a room and answer my questions.',
      intro:
          'Welcome! I’m Natasha at the front desk. What kind of room would you like to book?',
    ),
    ScenarioModel(
      title: 'Festivals and Traditions',
      description: 'Talk about cultural festivals and how you celebrate them.',
      imagePath: AppAssets.festivalsAndTraditions,
      level: 'A2',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a friend from another country. Ask me to describe my favorite festival.',
      intro:
          'Namaste! I’m Natasha. What festival do you love celebrating the most?',
    ),
    ScenarioModel(
      title: 'Local Culture and Customs',
      description: 'Discuss traditions, habits, and manners across cultures.',
      imagePath: AppAssets.localCultureAndCustoms,
      level: 'B2',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a traveler visiting my country. Ask about local culture and etiquette.',
      intro:
          'Hi! I’m Natasha, your local guide. Want to learn about our customs?',
    ),
    ScenarioModel(
      title: 'Food from Different Countries',
      description:
          'Compare cuisines and discuss international dining experiences.',
      imagePath: AppAssets.foodFromDifferentCountries,
      level: 'B1',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a chef from another country. Let’s discuss food from our cultures.',
      intro: 'Hello! I’m Natasha. What’s a popular dish in your country?',
    ),
    ScenarioModel(
      title: 'Travel Experiences and Memories',
      description:
          'Share memorable travel experiences and favorite destinations.',
      imagePath: AppAssets.travelExperiencesAndMemories,
      level: 'B2',
      category: 'Food, Travel & Culture',
      prompt:
          'Act as a travel buddy. Ask me about my best trips and what I learned.',
      intro: 'Hey globetrotter! I’m Natasha. What’s your most memorable trip?',
    ),
    ScenarioModel(
      title: 'School and College Life',
      description:
          'Talk about your classes, teachers, and experiences in school or college.',
      imagePath: AppAssets.schoolAndCollegeLife,
      level: 'A2',
      category: 'Education & Learning',
      prompt:
          'Act as a classmate. Ask me questions about my school life and hobbies.',
      intro:
          'Hi! I’m Natasha, your classmate. How’s your school or college life?',
    ),
    ScenarioModel(
      title: 'Favorite Subjects and Teachers',
      description: 'Describe subjects you enjoy and teachers who inspired you.',
      imagePath: AppAssets.favoriteSubjectsAndTeachers,
      level: 'A2',
      category: 'Education & Learning',
      prompt:
          'Act as a student. Ask me about my favorite subjects and teachers.',
      intro:
          'Hello! I’m Natasha. Which subject do you enjoy learning the most?',
    ),
    ScenarioModel(
      title: 'Online Learning',
      description: 'Discuss e-learning platforms, advantages, and challenges.',
      imagePath: AppAssets.onlineLearning,
      level: 'B1',
      category: 'Education & Learning',
      prompt:
          'Act as an online instructor. Ask me about my online study habits.',
      intro: 'Hi! I’m Natasha. How do you feel about online classes?',
    ),
    ScenarioModel(
      title: 'Study Habits and Exam Preparation',
      description: 'Share techniques for studying and managing exam stress.',
      imagePath: AppAssets.studyHabitsAndExamPreparation,
      level: 'B1',
      category: 'Education & Learning',
      prompt: 'Act as a study coach. Ask me about my exam preparation routine.',
      intro:
          'Hey! I’m Natasha. Exams are coming — how do you prepare for them?',
    ),
    ScenarioModel(
      title: 'Talking About Mistakes',
      description:
          'Learn to discuss errors and how to learn from them positively.',
      imagePath: AppAssets.talkingAboutMistakes,
      level: 'B2',
      category: 'Education & Learning',
      prompt:
          'Act as a teacher. Ask me what mistakes I’ve learned from in studies.',
      intro:
          'Hi! I’m Natasha. Everyone makes mistakes — what have yours taught you?',
    ),
    ScenarioModel(
      title: 'Learning New Skills',
      description:
          'Talk about learning languages, instruments, or digital skills.',
      imagePath: AppAssets.learningNewSkills,
      level: 'B1',
      category: 'Education & Learning',
      prompt: 'Act as a friend. Ask me what new skill I want to learn and why.',
      intro: 'Hello! I’m Natasha. What new skill are you currently learning?',
    ),
    ScenarioModel(
      title: 'Future Education Goals',
      description: 'Discuss your study plans and future ambitions.',
      imagePath: AppAssets.futureEducationGoals,
      level: 'B2',
      category: 'Education & Learning',
      prompt:
          'Act as a career counselor. Ask me about my future academic goals.',
      intro: 'Hi! I’m Natasha. What do you want to study next — and why?',
    ),
    ScenarioModel(
      title: 'Job Interview Practice',
      description:
          'Prepare for interviews and learn professional self-introduction skills.',
      imagePath: AppAssets.jobInterviewPractice,
      level: 'B2',
      category: 'Work, Business & Career',
      prompt:
          'Act as an interviewer. Ask me common job interview questions and give feedback.',
      intro:
          'Hi, I’m Natasha, your interviewer. Let’s start — can you tell me about yourself?',
    ),
    ScenarioModel(
      title: 'Workplace Communication',
      description: 'Discuss projects, deadlines, and teamwork with colleagues.',
      imagePath: AppAssets.workplaceCommunication,
      level: 'B1',
      category: 'Work, Business & Career',
      prompt:
          'Act as a coworker. Start a chat about an upcoming project deadline.',
      intro:
          'Hey! I’m Natasha, your teammate. Can we talk about our current project?',
    ),
    ScenarioModel(
      title: 'Giving and Receiving Feedback',
      description:
          'Practice giving constructive feedback and responding professionally.',
      imagePath: AppAssets.givingAndReceivingFeedback,
      level: 'B2',
      category: 'Work, Business & Career',
      prompt: 'Act as my team lead. Give me feedback and ask for mine too.',
      intro:
          'Hi! I’m Natasha. Let’s practice how to give and receive feedback politely.',
    ),
    ScenarioModel(
      title: 'Making Business Calls',
      description: 'Handle formal phone conversations with confidence.',
      imagePath: AppAssets.makingBusinessCalls,
      level: 'B1',
      category: 'Work, Business & Career',
      prompt:
          'Act as a client on a business call. Ask questions about a project update.',
      intro:
          'Hello! I’m Natasha calling from the client side. Can you give me an update?',
    ),
    ScenarioModel(
      title: 'Professional Emails',
      description: 'Learn how to write and reply to formal emails.',
      imagePath: AppAssets.professionalEmails,
      level: 'B2',
      category: 'Work, Business & Career',
      prompt:
          'Act as my manager. Ask me to write or reply to a formal work email.',
      intro: 'Hi! I’m Natasha. Let’s draft a professional email together.',
    ),
    ScenarioModel(
      title: 'Time Management at Work',
      description:
          'Discuss managing workload, priorities, and deadlines effectively.',
      imagePath: AppAssets.timeManagementAtWork,
      level: 'B1',
      category: 'Work, Business & Career',
      prompt:
          'Act as my mentor. Ask me how I plan my workday and suggest improvements.',
      intro: 'Hello! I’m Natasha. How do you usually plan your workday?',
    ),
    ScenarioModel(
      title: 'Work–Life Balance',
      description:
          'Talk about maintaining balance between job and personal life.',
      imagePath: AppAssets.workLifeBalance,
      level: 'B1',
      category: 'Work, Business & Career',
      prompt:
          'Act as a friend. Discuss how to relax after work and avoid burnout.',
      intro: 'Hey! I’m Natasha. What do you do to unwind after work?',
    ),
    ScenarioModel(
      title: 'Career Goals and Ambitions',
      description: 'Discuss short-term and long-term professional aspirations.',
      imagePath: AppAssets.careerGoalsAndAmbitions,
      level: 'B2',
      category: 'Work, Business & Career',
      prompt: 'Act as a career coach. Ask me about my goals and future plans.',
      intro: 'Hi! I’m Natasha. What kind of career are you dreaming of?',
    ),
    ScenarioModel(
      title: 'Buying Clothes or Gadgets',
      description:
          'Practice asking about sizes, prices, and features in stores.',
      imagePath: AppAssets.buyingClothesOrGadgets,
      level: 'A2',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a store assistant. Ask me what I’m looking for and suggest options.',
      intro:
          'Hi! I’m Natasha from the store. What would you like to buy today?',
    ),
    ScenarioModel(
      title: 'Comparing Prices and Discounts',
      description: 'Learn how to ask for deals and compare prices politely.',
      imagePath: AppAssets.comparingPricesAndDiscounts,
      level: 'B1',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a shopkeeper. Offer me discounts and explain price differences.',
      intro:
          'Hello! I’m Natasha. Are you looking for something affordable or premium?',
    ),
    ScenarioModel(
      title: 'Banking and Payments',
      description:
          'Talk about accounts, loans, and digital transactions in English.',
      imagePath: AppAssets.bankingAndPayments,
      level: 'B2',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a bank staff member. Help me open an account or set up online banking.',
      intro: 'Hi! I’m Natasha from the bank. How can I assist you today?',
    ),
    ScenarioModel(
      title: 'Asking for Help in a Store',
      description:
          'Learn how to approach staff and request assistance politely.',
      imagePath: AppAssets.askingForHelpInAStore,
      level: 'A2',
      category: 'Shopping, Money & Services',
      prompt: 'Act as a shop assistant. Help me find a product in the store.',
      intro: 'Hey there! I’m Natasha. How can I help you today?',
    ),
    ScenarioModel(
      title: 'Online Shopping and Reviews',
      description: 'Discuss online purchases and writing product feedback.',
      imagePath: AppAssets.onlineShoppingAndReviews,
      level: 'B1',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a customer-service agent. Ask me about my order experience.',
      intro:
          'Hello! I’m Natasha from customer support. Did you enjoy your recent purchase?',
    ),
    ScenarioModel(
      title: 'Saving and Budgeting Money',
      description:
          'Learn how to talk about saving, expenses, and financial planning.',
      imagePath: AppAssets.savingAndBudgetingMoney,
      level: 'B1',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a financial advisor. Ask me about my spending habits and savings goals.',
      intro:
          'Hi! I’m Natasha, your financial guide. Do you usually save money each month?',
    ),
    ScenarioModel(
      title: 'Returning or Exchanging Products',
      description: 'Practice polite phrases for refunds and exchanges.',
      imagePath: AppAssets.returningOrExchangingProducts,
      level: 'B2',
      category: 'Shopping, Money & Services',
      prompt:
          'Act as a store manager. Help me return or exchange a product politely.',
      intro: 'Hello! I’m Natasha. How can I help you with your return today?',
    ),
    ScenarioModel(
      title: 'Expressing Opinions Politely',
      description: 'Learn to share and discuss opinions without sounding rude.',
      imagePath: AppAssets.expressingOpinionsPolitely,
      level: 'B1',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a debate partner. Ask me about my opinion on simple topics like movies or food.',
      intro:
          'Hi! I’m Natasha. Let’s practice sharing opinions. What’s your view on social media?',
    ),
    ScenarioModel(
      title: 'Talking About Feelings',
      description: 'Use emotional vocabulary to describe how you feel and why.',
      imagePath: AppAssets.talkingAboutFeelings,
      level: 'A2',
      category: 'Opinions, Emotions & Social Life',
      prompt: 'Act as a friend. Ask me how I feel today and why.',
      intro: 'Hey! I’m Natasha. How are you feeling right now?',
    ),
    ScenarioModel(
      title: 'Handling Stress',
      description: 'Talk about stress, relaxation, and coping techniques.',
      imagePath: AppAssets.handlingStress,
      level: 'B1',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a therapist. Ask me about what stresses me and how I relax.',
      intro:
          'Hi! I’m Natasha. Everyone feels stressed sometimes—what helps you calm down?',
    ),
    ScenarioModel(
      title: 'Making Small Talk',
      description: 'Practice light conversation for social and work settings.',
      imagePath: AppAssets.makingSmallTalk,
      level: 'A2',
      category: 'Opinions, Emotions & Social Life',
      prompt: 'Act as a colleague. Start a short, friendly chat about the day.',
      intro: 'Hi! I’m Natasha. How’s your day going so far?',
    ),
    ScenarioModel(
      title: 'Agreeing and Disagreeing',
      description: 'Use natural phrases to agree or disagree politely.',
      imagePath: AppAssets.agreeingAndDisagreeing,
      level: 'B1',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a discussion partner. Share your opinion and ask if I agree.',
      intro:
          'Hey! I’m Natasha. Let’s practice agreeing and disagreeing politely.',
    ),
    ScenarioModel(
      title: 'Sharing Experiences',
      description: 'Talk about memorable experiences and what you learned.',
      imagePath: AppAssets.sharingExperiences,
      level: 'B2',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a podcast host. Ask me to share an interesting life story.',
      intro:
          'Hello! I’m Natasha. Can you share a memorable moment from your life?',
    ),
    ScenarioModel(
      title: 'Talking About Kindness',
      description: 'Discuss acts of kindness and how to express gratitude.',
      imagePath: AppAssets.talkingAboutKindness,
      level: 'A2',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a friend. Ask me about a time I helped someone or received help.',
      intro: 'Hi! I’m Natasha. When was the last time someone was kind to you?',
    ),
    ScenarioModel(
      title: 'Apologizing and Forgiving',
      description: 'Practice how to apologize and accept apologies in English.',
      imagePath: AppAssets.apologizingAndForgiving,
      level: 'A2',
      category: 'Opinions, Emotions & Social Life',
      prompt:
          'Act as a friend. Pretend I made a mistake—help me practice apologizing.',
      intro:
          'Hey! I’m Natasha. Let’s practice saying sorry and forgiving someone.',
    ),
    ScenarioModel(
      title: 'Using Smartphones and Apps',
      description: 'Talk about favorite apps, features, and phone habits.',
      imagePath: AppAssets.usingSmartphonesAndApps,
      level: 'A2',
      category: 'Technology & Modern Life',
      prompt: 'Act as a tech enthusiast. Ask me what apps I use most and why.',
      intro: 'Hi! I’m Natasha. Which apps do you use every day?',
    ),
    ScenarioModel(
      title: 'Social Media Influence',
      description: 'Discuss how social media affects people’s lives.',
      imagePath: AppAssets.socialMediaInfluence,
      level: 'B1',
      category: 'Technology & Modern Life',
      prompt: 'Act as a friend. Ask me how social media changes communication.',
      intro:
          'Hey! I’m Natasha. Do you think social media has more pros or cons?',
    ),
    ScenarioModel(
      title: 'Artificial Intelligence in Daily Life',
      description: 'Talk about AI tools and how they’re shaping the world.',
      imagePath: AppAssets.artificialIntelligenceInDailyLife,
      level: 'B2',
      category: 'Technology & Modern Life',
      prompt: 'Act as a tech journalist. Ask me how I use AI in daily life.',
      intro: 'Hi! I’m Natasha. How do you feel about AI assistants like me?',
    ),
    ScenarioModel(
      title: 'Online Safety and Privacy',
      description:
          'Learn to discuss internet safety and digital privacy concerns.',
      imagePath: AppAssets.onlineSafetyAndPrivacy,
      level: 'B1',
      category: 'Technology & Modern Life',
      prompt:
          'Act as a cybersecurity expert. Ask me how I protect my online data.',
      intro: 'Hello! I’m Natasha. Do you think your online accounts are safe?',
    ),
    ScenarioModel(
      title: 'Work From Home Lifestyle',
      description:
          'Discuss pros and cons of remote work and productivity tips.',
      imagePath: AppAssets.workFromHomeLifestyle,
      level: 'B1',
      category: 'Technology & Modern Life',
      prompt: 'Act as a coworker. Ask me how I manage work-from-home routines.',
      intro: 'Hi! I’m Natasha. Do you enjoy working from home?',
    ),
    ScenarioModel(
      title: 'Digital Addiction',
      description: 'Talk about screen time and healthy tech habits.',
      imagePath: AppAssets.digitalAddiction,
      level: 'B2',
      category: 'Technology & Modern Life',
      prompt:
          'Act as a life coach. Ask me about my screen habits and solutions.',
      intro:
          'Hey! I’m Natasha. How many hours do you spend on your phone daily?',
    ),
    ScenarioModel(
      title: 'Balancing Screen Time',
      description: 'Learn expressions to talk about balancing technology use.',
      imagePath: AppAssets.balancingScreenTime,
      level: 'A2',
      category: 'Technology & Modern Life',
      prompt: 'Act as a friend. Ask me how I relax without my phone.',
      intro:
          'Hi! I’m Natasha. What do you do when you want a break from screens?',
    ),
    ScenarioModel(
      title: 'Pollution and Climate Change',
      description:
          'Discuss global warming, pollution, and environmental solutions.',
      imagePath: AppAssets.pollutionAndClimateChange,
      level: 'B2',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as an environmental activist. Ask me what I do to protect the planet.',
      intro:
          'Hi! I’m Natasha. What can we do to fight climate change together?',
    ),
    ScenarioModel(
      title: 'Helping the Community',
      description: 'Talk about volunteering and helping people in need.',
      imagePath: AppAssets.helpingTheCommunity,
      level: 'A2',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as a volunteer coordinator. Ask me about my experience helping others.',
      intro:
          'Hello! I’m Natasha. Have you ever volunteered for a community cause?',
    ),
    ScenarioModel(
      title: 'Gender Equality',
      description:
          'Discuss fairness, equality, and opportunities for all genders.',
      imagePath: AppAssets.genderEquality,
      level: 'B2',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as a social worker. Ask me what gender equality means to me.',
      intro: 'Hi! I’m Natasha. Do you think society treats everyone equally?',
    ),
    ScenarioModel(
      title: 'Peace and Global Cooperation',
      description: 'Talk about peace, unity, and global understanding.',
      imagePath: AppAssets.peaceAndGlobalCooperation,
      level: 'B1',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as a peace ambassador. Ask me how countries can work together.',
      intro: 'Hello! I’m Natasha. What does peace mean to you?',
    ),
    ScenarioModel(
      title: 'Animal Welfare',
      description: 'Discuss kindness toward animals and protecting wildlife.',
      imagePath: AppAssets.animalWelfare,
      level: 'A2',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as an animal shelter worker. Ask me about my favorite animals.',
      intro:
          'Hi! I’m Natasha. Do you think animals should have more protection?',
    ),
    ScenarioModel(
      title: 'Waste Management',
      description:
          'Learn to talk about recycling, plastic use, and clean surroundings.',
      imagePath: AppAssets.wasteManagement,
      level: 'B1',
      category: 'Society, Environment & Global Issues',
      prompt: 'Act as a city officer. Ask me how I manage household waste.',
      intro: 'Hey! I’m Natasha. Do you recycle at home?',
    ),
    ScenarioModel(
      title: 'Sustainable Living',
      description:
          'Discuss eco-friendly habits like saving energy and reducing waste.',
      imagePath: AppAssets.sustainableLiving,
      level: 'B2',
      category: 'Society, Environment & Global Issues',
      prompt:
          'Act as a sustainability expert. Ask me about eco-friendly habits.',
      intro: 'Hi! I’m Natasha. How do you live sustainably in your daily life?',
    ),
    ScenarioModel(
      title: 'Storytelling Practice',
      description: 'Develop creativity and storytelling skills in English.',
      imagePath: AppAssets.storytellingPractice,
      level: 'B1',
      category: 'Imagination, Creativity & Reflection',
      prompt:
          'Act as a listener. Ask me to tell a short story about any topic.',
      intro:
          'Hi! I’m Natasha. Can you tell me a short story from your imagination?',
    ),
    ScenarioModel(
      title: 'What Would You Do If…',
      description: 'Practice conditional speech and hypothetical situations.',
      imagePath: AppAssets.whatWouldYouDoIf,
      level: 'B2',
      category: 'Imagination, Creativity & Reflection',
      prompt:
          'Act as a curious friend. Ask me “what would you do if…” type questions.',
      intro:
          'Hey! I’m Natasha. What would you do if you could fly for one day?',
    ),
    ScenarioModel(
      title: 'Dreams and Goals',
      description: 'Talk about ambitions, dreams, and how to achieve them.',
      imagePath: AppAssets.dreamsAndGoals,
      level: 'B1',
      category: 'Imagination, Creativity & Reflection',
      prompt: 'Act as a life coach. Ask me about my future dreams and goals.',
      intro: 'Hi! I’m Natasha. What’s your biggest dream in life?',
    ),
    ScenarioModel(
      title: 'Lessons Learned from Life',
      description: 'Reflect on personal growth and life experiences.',
      imagePath: AppAssets.lessonsLearnedFromLife,
      level: 'B2',
      category: 'Imagination, Creativity & Reflection',
      prompt:
          'Act as a friend. Ask me about the most important lesson I’ve learned.',
      intro: 'Hello! I’m Natasha. What lesson has life taught you recently?',
    ),
    ScenarioModel(
      title: 'Motivation and Inspiration',
      description: 'Discuss what inspires you and how to stay motivated.',
      imagePath: AppAssets.motivationAndInspiration,
      level: 'B1',
      category: 'Imagination, Creativity & Reflection',
      prompt: 'Act as a mentor. Ask me what keeps me motivated every day.',
      intro: 'Hi! I’m Natasha. Who or what inspires you the most?',
    ),
    ScenarioModel(
      title: 'Describing Art and Music',
      description: 'Express opinions about music, movies, and artworks.',
      imagePath: AppAssets.describingArtAndMusic,
      level: 'B2',
      category: 'Imagination, Creativity & Reflection',
      prompt: 'Act as an artist. Ask me what kind of music or art I like.',
      intro: 'Hey! I’m Natasha. What type of music helps you relax?',
    ),
    ScenarioModel(
      title: 'The Future of the World',
      description: 'Talk about technology, environment, and humanity’s future.',
      imagePath: AppAssets.theFutureOfTheWorld,
      level: 'C1',
      category: 'Imagination, Creativity & Reflection',
      prompt:
          'Act as a futurist. Ask me how I imagine the world 50 years from now.',
      intro:
          'Hi! I’m Natasha. What do you think life will be like in the future?',
    ),
    ScenarioModel(
      title: 'Staying Positive',
      description: 'Learn phrases to express hope and positivity.',
      imagePath: AppAssets.stayingPositive,
      level: 'A2',
      category: 'Imagination, Creativity & Reflection',
      prompt:
          'Act as a motivational friend. Ask me how I stay positive in tough times.',
      intro:
          'Hello! I’m Natasha. How do you stay positive when life gets hard?',
    ),
  ];

  static List<String> englishLevel = ["A1", "A2", "B1", "B2", "C1", "C2"];

  static List<String> weekDaysName = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    // In Dart, Monday = 1, Sunday = 7
    final int weekday = now.weekday;

    // Find this week's Monday
    final DateTime monday = now.subtract(Duration(days: weekday - 1));

    // Build the full week (Mon → Sun)
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  static List<LanguageCode> appLanguages = [
      LanguageCode(language: "English", code: "en", countryCode: "US", flag: "🇺🇸"),
  LanguageCode(language: "हिन्दी", code: "hi", countryCode: "IN", flag: "🇮🇳"),
  LanguageCode(language: "española", code: "es", countryCode: "ES", flag: "🇪🇸"),
  LanguageCode(language: "日本語", code: 'ja', countryCode: "JP", flag: "🇯🇵")
  ];
}
