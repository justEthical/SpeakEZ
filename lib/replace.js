const fs = require("fs");
const path = require("path");

const folderPath = "./lib";   // change this

const strings = [
  "login",
  "register",
  "email",
  "password",
  "confirmPassword",
  "fullName",
  "enterEmail",
  "enterPassword",
  "welcomeBack",
  "gladToSeeYouAgain",
  "letsStart",
  "createAccountInSimpleSteps",
  "or",
  "loginWithGoogle",
  "registerWithGoogle",
  "byContinuingYouAgree",
  "termsOfService",
  "and",
  "privacyPolicy",

  // Settings
  "settings",
  "help",
  "rateUs",
  "rateUsOnGooglePlay",
  "referToFriend",
  "shareWithFriends",
  "logout",
  "deleteAccount",
  "deleteAccountAndData",
  "reauthenticatePrompt",
  "reauthenticate",
  "error",
  "pleaseEnterPassword",

  // Home Screen
  "hi",
  "currentStreak",
  "wordsLearned",
  "days",
  "currentLevel",
  "introduction",
  "startLearning",
  "continueLearning",
  "learnByLevel",
  "seeAll",
  "lessons",
  "levelLessons",
  "completed",
  "retest",
  "close",
  "youGot",
  "yourCurrentStreakIs",

  // Level Bottom Sheet
  "a1Beginner",
  "a1Description",
  "a2Elementary",
  "a2Description",
  "b1Intermediate",
  "b1Description",
  "b2UpperIntermediate",
  "b2Description",
  "c1Advanced",
  "c1Description",
  "c2Expert",
  "c2Description",

  // Tab Bar
  "progress",
  "practice",
  "profile",
  "exit",
  "pressAgainToExit",

  // Onboarding
  "previous",
  "next",
  "back",
  "tellUsAboutYourself",
  "helpUsPersonalize",

  // Lesson Screens
  "levelUnlockTest",
  "welcomeToTheLesson",
  "unlockTestScoreRequirement",
  "level",
  "start",
  "vocabulary",
  "grammarTips",
  "testYourKnowledge",
  "noVocabularyAvailable",
  "noGrammarTipsAvailable",
  "autoSpeak",
  "prev",
  "done",
  "meaning",
  "exampleSentences",
  "listen",
  "check",

  // Answer Result Bottom Sheet
  "correctAnswer",
  "wrongAnswer",

  // Lesson Exit Alert
  "exitUnlockTestWarning",
  "exitLessonConfirmation",
  "continueTest",
  "exitAndDiscard",

  // Speaking Question
  "tapToStop",
  "processing",
  "listening",

  // Result Screen
  "lessonCompleted",
  "accuracy",
  "timeTaken",

  // Practice Screen
  "speakingPractice",
  "practiceWithNatasha",
  "selectScenarioToStart",
  "downloadingNatashaAI",
  "downloadInfo",
  "gems",
  "startPractice",
  "viewResults",

  // Chat Exit Alert
  "exitChatConfirmation",
  "closeAndDiscard",

  // Practice Result Screen
  "score",
  "fluency",
  "grammar",
  "pronunciationLabel",
  "totalSpeakingTime",
  "suggestion",
  "detailedFeedback",
  "minutes",

  // Dialogs
  "areYouSureLogout",
  "yes",
  "cancel",
  "openSettings",
  "areYouSureDeleteAccount",
  "delete",
  "levelLockedMessage",
  "unlock",
  "view",
  "unlockTest",
  "canUnlockIn",
  "hours",
  "startingPracticeWillUse",
  "watchAdGetGems",

  // Review Screen
  "pleaseRateYourExperience"
];


function replaceInFile(filePath) {
  let content = fs.readFileSync(filePath, "utf8");
  let changed = false;

  for (const s of strings) {
    const searchFor = `AppStrings.${s}`;
    const replaceWith = `AppStrings.${s}.tr`;

    if (content.includes(searchFor)) {
      content = content.split(searchFor).join(replaceWith);
      changed = true;
    }
  }

  if (changed) {
    fs.writeFileSync(filePath, content, "utf8");
    console.log(`Updated: ${filePath}`);
  }
}

function walk(dir) {
  const entries = fs.readdirSync(dir);
  for (const entry of entries) {
    const full = path.join(dir, entry);
    const stats = fs.statSync(full);

    if (stats.isDirectory()) {
      walk(full);
    } else {
      replaceInFile(full);
    }
  }
}

walk(folderPath);
console.log("✔ Done!");
