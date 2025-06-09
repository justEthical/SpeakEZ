
import 'package:speak_ez/Constants/app_assets.dart';

class ScenarioModel {
  final String title;
  final String description;
  final String imagePath;
  final String level;
  final String prompt;
  final String intro;

  ScenarioModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.level,
    required this.prompt,
    required this.intro,
  });
}

final List<ScenarioModel> scenarios = [
  ScenarioModel(
    title: 'Job Interview',
    description: 'Practice answering common interview questions with AI-powered tools.',
    imagePath: AppAssets.jobInterview,
    level: 'B2',
    prompt: 'Act as an interviewer. Ask me common job interview questions one by one. Give me feedback on my answers and help me improve.',
    intro: 'Hi, I’m Natasha, your English speaking partner! Let’s practice some common interview questions. I’ll be your interviewer, and you’ll be the interviewee. To start, can you tell me a little about yourself?',
  ),
  ScenarioModel(
    title: 'Ordering Food',
    description: 'Learn how to order food, ask about menu items, and handle bills in English.',
    imagePath: AppAssets.orderingFood,
    level: 'A2',
    prompt: 'Act as a waiter in a restaurant. Take my order, ask follow-up questions, and help me practice ordering food in English.',
    intro: 'Hello! I’m Natasha, your English practice buddy. Imagine you’re at a restaurant and I’m your waiter. What would you like to order today?',
  ),
  ScenarioModel(
    title: 'Making Friends',
    description: 'Introduce yourself, talk about hobbies, and build new friendships.',
    imagePath: AppAssets.makingFriends,
    level: 'B1',
    prompt: 'Pretend to be someone I just met at a party. Start a friendly conversation and ask about my hobbies, interests, and background.',
    intro: 'Hi, I’m Natasha! Let’s make some new friends together. I’ll be a friendly stranger at a party. Can you introduce yourself to me?',
  ),
  ScenarioModel(
    title: 'Asking Directions',
    description: 'Practice asking for and giving directions in a city or town.',
    imagePath: AppAssets.askingDirections,
    level: 'A2',
    prompt: 'Act as a local person in a city. Wait for me to ask for directions and then respond, giving clear instructions. Correct my questions if needed.',
    intro: 'Hey there! I’m Natasha, your English speaking partner. Imagine you’re lost in a city and I’m a local here. Where would you like to go?',
  ),
  ScenarioModel(
    title: 'Shopping',
    description: 'Practice bargaining, asking about prices, and discussing payment methods.',
    imagePath: AppAssets.shopping,
    level: 'B1',
    prompt: 'Act as a shopkeeper at a local market. Interact with me as I ask about prices and try to bargain. Give feedback on my sentences.',
    intro: 'Hi! Natasha here. Let’s go shopping at a local market. I’ll be the shopkeeper. What are you looking to buy today?',
  ),
  ScenarioModel(
    title: 'At the Doctor',
    description: 'Describe your symptoms and talk to a doctor in English.',
    imagePath: AppAssets.atTheDoctor,
    level: 'A2',
    prompt: 'Act as a doctor in a clinic. Ask me about my symptoms and guide me to describe my problem in English.',
    intro: 'Hello, I’m Dr. Natasha! Tell me how you’re feeling. What brings you to the clinic today?',
  ),
  ScenarioModel(
    title: 'Phone Calls',
    description: 'Learn polite phrases for starting, holding, and ending calls.',
    imagePath: AppAssets.phoneCalls,
    level: 'B1',
    prompt: 'Act as a customer service agent. Take my call, ask me to explain my issue, and guide me through the conversation.',
    intro: 'Hi, Natasha here! Let’s practice a phone call. I’ll be the customer service agent. How can I help you today?',
  ),
  ScenarioModel(
    title: 'Daily English',
    description: 'Master common greetings, apologies, and requests for daily use.',
    imagePath: AppAssets.dailyEnglish,
    level: 'A2',
    prompt: 'Act as a friendly neighbor or colleague. Start a casual conversation using greetings, small talk, and common English phrases.',
    intro: 'Hi, I’m Natasha, your English speaking partner! Let’s practice daily English with greetings and small talk. How are you today?',
  ),
  ScenarioModel(
    title: 'Travel',
    description: 'Book tickets, check into hotels, and ask about tourist spots.',
    imagePath: AppAssets.travel,
    level: 'B1',
    prompt: 'Act as a hotel receptionist or travel agent. Ask me questions about my travel plans and help me practice booking and checking in.',
    intro: 'Hello, I’m Natasha! Imagine you’re travelling—I’ll be the hotel receptionist or travel agent. Where would you like to travel next?',
  ),
  ScenarioModel(
    title: 'In the Classroom',
    description: 'Introduce yourself, ask questions, and talk to teachers in an educational setting.',
    imagePath: AppAssets.inTheClassroom,
    level: 'A2',
    prompt: 'Act as a teacher or a new classmate. Start a conversation with me and help me practice classroom English.',
    intro: 'Hi, Natasha here! Let’s pretend you’re in a classroom. I can be your teacher or classmate. Can you introduce yourself to the class?',
  ),
  ScenarioModel(
    title: 'Daily Routine',
    description: 'Talk about your daily schedule and regular activities.',
    imagePath: AppAssets.dailyRoutine,
    level: 'A2',
    prompt: 'Ask me to describe my daily routine in detail. Guide me with questions and correct my sentences if needed.',
    intro: 'Hey, I’m Natasha! Let’s talk about your daily routine. What do you usually do in the morning?',
  ),
  ScenarioModel(
    title: 'Making Plans',
    description: 'Arrange meetups, movie nights, or trips in English.',
    imagePath: AppAssets.makingPlans,
    level: 'B1',
    prompt: 'Pretend to be my friend. Invite me to go out, make plans for the weekend, and discuss options with me.',
    intro: 'Hi, Natasha here! Let’s make some fun plans together. What would you like to do this weekend?',
  ),
  ScenarioModel(
    title: 'Festivals',
    description: 'Describe how you celebrate Indian festivals and cultural events.',
    imagePath: AppAssets.festivals,
    level: 'A2',
    prompt: 'Act as a friend or family member. Ask me about my favorite festival and how I celebrate it. Help me talk about traditions.',
    intro: 'Namaste! I’m Natasha. Let’s talk about festivals. What is your favorite festival and how do you celebrate it?',
  ),
  ScenarioModel(
    title: 'Workplace Talk',
    description: 'Talk to colleagues, discuss deadlines, and ask for help at work.',
    imagePath: AppAssets.workplaceTalk,
    level: 'B2',
    prompt: 'Act as my colleague at work. Start a conversation about a project or deadline. Help me practice professional English.',
    intro: 'Hi, I’m Natasha, your colleague at work! Let’s discuss a project. What are you working on right now?',
  ),
  ScenarioModel(
    title: 'Using Technology',
    description: 'Explain how to use apps, discuss social media, and troubleshoot devices.',
    imagePath: AppAssets.usingTechnology,
    level: 'B1',
    prompt: 'Pretend to be a person who needs help with technology. Ask me questions so I can explain how to use a phone app or fix a device.',
    intro: 'Hello! I’m Natasha. I need help with my smartphone. Can you teach me how to use an app you like?',
  ),
  ScenarioModel(
    title: 'Parent-Teacher',
    description: 'Practice discussing student performance and school matters.',
    imagePath: AppAssets.parentTeacher,
    level: 'B1',
    prompt: 'Act as a school teacher. Talk to me (the parent) about my child’s performance and answer my questions.',
    intro: 'Hi, I’m Natasha, your child’s teacher. Let’s discuss your child’s progress. Do you have any concerns or questions?',
  ),
  ScenarioModel(
    title: 'Banking',
    description: 'Open an account, ask about loans, or discuss digital payments.',
    imagePath: AppAssets.banking,
    level: 'B2',
    prompt: 'Act as a bank staff member. Help me open a new account, explain the steps, and answer my questions.',
    intro: 'Hello, I’m Natasha from the bank. I’m here to help you open a new account. What kind of account would you like to open?',
  ),
  ScenarioModel(
    title: 'Public Transport',
    description: 'Ask about bus/train timings, buy tickets, and find your seat.',
    imagePath: AppAssets.publicTransport,
    level: 'A2',
    prompt: 'Act as a bus or train ticket clerk. Respond to my questions about schedules and ticket prices.',
    intro: 'Hi, Natasha here! Imagine you’re at a bus or train station. Where do you want to travel today?',
  ),
  ScenarioModel(
    title: 'Weather',
    description: 'Talk about the weather, seasons, and climate in your city.',
    imagePath: AppAssets.weather,
    level: 'A2',
    prompt: 'Start a conversation about today’s weather and ask me follow-up questions about seasons or climate.',
    intro: 'Hey! I’m Natasha, your English practice buddy. How’s the weather in your city today?',
  ),
  ScenarioModel(
    title: 'Talking Food',
    description: 'Talk about your favorite dishes and how to prepare them.',
    imagePath: AppAssets.talkingFood,
    level: 'A2',
    prompt: 'Act as a food blogger or chef. Ask me about my favorite dishes and how I make them. Help me describe the process in English.',
    intro: 'Hi, I’m Natasha! I love food. Let’s talk about your favorite dish. What is your favorite food or cuisine?',
  ),
];
