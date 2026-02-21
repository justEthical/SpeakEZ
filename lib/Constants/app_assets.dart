class AppAssets {
  static String _getFullLottiePath(String name) => "assets/lottie/$name";
  static String _getFullImagePath(String name) => "assets/images/$name";
  static String _getPracticeCategoryPath(String name) => "assets/images/practice-tab-icons/$name";
  static String _getScenarioCategoryPath(String name) => "assets/images/scenario-icons/$name";

  // lottie animations
  static String get onboaring1 => _getFullLottiePath("first.lottie");
  static String get onboaring2 => _getFullLottiePath("third.lottie");
  static String get onboaring3 => _getFullLottiePath("second.lottie");
  static String get exitAlert => _getFullLottiePath("exit_alert.lottie");
  static String get confetti => _getFullLottiePath("confetti.lottie");
  static String get resultSuccess => _getFullLottiePath("success.lottie");
  static String get correctAnswer => _getFullLottiePath("correct.lottie");
  static String get wrongAnswer => _getFullLottiePath("wrong.lottie");
  static String get chatting => _getFullLottiePath("chating.lottie");
  static String get recording => _getFullLottiePath("recording.lottie");
  static String get downloading => _getFullLottiePath("downloading.lottie");
  static String get mic => _getFullLottiePath("mic.lottie");
  static String get loader => _getFullLottiePath("loader.lottie");
  static String get rating => _getFullLottiePath("rating.lottie");
  static String get unlock => _getFullLottiePath("unlock.lottie");
  static String get locked => _getFullLottiePath("locked.lottie");
  static String get key => _getFullLottiePath("key.lottie");
  static String get gemAnimation => _getFullLottiePath("gem.lottie");
  static String get streak => _getFullLottiePath("streak.lottie");  
  static String get freeTalk => _getFullLottiePath("free_talk.lottie");
  static String get vocabTab => _getFullLottiePath('vocab_tab.lottie');

  static String get placeholder => _getFullImagePath("placeholder.png");

  //Audio files
  static String get correct => "correct.mp3";
  static String get incorrect => "incorrect.mp3";

  // images
  static String get logo => _getFullImagePath("logo.png");
  static String get google => _getFullImagePath("google.svg");
  static String get fb => _getFullImagePath("fb.png");
  static String get settings => _getFullImagePath("settings.svg");
  static String get user => _getFullImagePath("user.svg");
  static String get eyeClosed => _getFullImagePath("eye-off.svg");
  static String get eyeIcon => _getFullImagePath("eye.svg");
  static String get atIcon => _getFullImagePath("at-sign.svg");
  static String get lockIcon => _getFullImagePath("lock.svg");
  static String get gem => _getFullImagePath("gem.png");
  static String get fire => _getFullImagePath("fire.png");

  // profile
  static String helpCircle = _getFullImagePath('help-circle.svg');
  static String starIcon = _getFullImagePath('star.svg');
  static String giftIcon = _getFullImagePath('gift.svg');
  static String logOut = _getFullImagePath('log-out.svg');
  static String deleteIcon = _getFullImagePath('trash.svg');
  static String appLanguage = _getFullImagePath('app_language.svg');

  // Home
  static String flame = _getFullImagePath('flame-icon.svg');
  static String medal = _getFullImagePath('medal-icon.svg');

  // Lesson
  static String cat = _getFullImagePath('cat.png');
  static String speak = _getFullImagePath('speak.svg');

  // practice
  // static String get jobInterview => _getFullImagePath("job_interview.svg");
  // static String get orderingFood => _getFullImagePath("ordering_food.svg");
  // static String get makingFriends => _getFullImagePath("making_friends.svg");
  // static String get askingDirections =>
  //     _getFullImagePath("asking_directions.svg");
  // static String get shopping => _getFullImagePath("shopping.svg");
  // static String get atTheDoctor => _getFullImagePath("at_the_doctor.svg");
  // static String get phoneCalls => _getFullImagePath("phone_calls.svg");
  // static String get dailyEnglish => _getFullImagePath("daily_english.svg");
  // static String get travel => _getFullImagePath("travel.svg");
  // static String get inTheClassroom => _getFullImagePath("in_the_classroom.svg");
  // static String get dailyRoutine => _getFullImagePath("daily_routine.svg");
  // static String get makingPlans => _getFullImagePath("making_plans.svg");
  // static String get festivals => _getFullImagePath("festivals.svg");
  // static String get workplaceTalk => _getFullImagePath("workplace_talk.svg");
  // static String get usingTechnology =>
  //     _getFullImagePath("using_technology.svg");
  // static String get parentTeacher => _getFullImagePath("parent_teacher.svg");
  // static String get banking => _getFullImagePath("banking.svg");
  // static String get publicTransport =>
  //     _getFullImagePath("public_transport.svg");
  // static String get weather => _getFullImagePath("weather.svg");
  // static String get talkingFood => _getFullImagePath("talking_food.svg");
  static String get natashaChat => _getFullImagePath("natasha_chat.png");

  // Practice Result
  static String get fluency => _getFullImagePath("fluency.svg");
  static String get grammar => _getFullImagePath("grammer.svg");
  static String get vocabulary => _getFullImagePath("vocabulary.svg");
  static String get prononciation => _getFullImagePath("prononciation.svg");
  static String get totalSpeakingTime =>
      _getFullImagePath("total_speaking_time.svg");
  static String get tip => _getFullImagePath("tip.svg");


  // practice tab category
  static String get dailyLifeRoutines => _getPracticeCategoryPath("daily_life_routines.png"); 
  static String get educationLearning => _getPracticeCategoryPath("education_learning.png");
  static String get familyFriendsRelationships => _getPracticeCategoryPath("family_friends_relationships.png");
  static String get foodTravelCulture => _getPracticeCategoryPath("food_travel_culture.png"); 
  static String get imaginationCreativityReflection => _getPracticeCategoryPath("imagination_creativity_reflection.png"); 
  static String get opinionsEmotionsSocialLife => _getPracticeCategoryPath("opinions_emotions_social_life.png"); 
  static String get societyEnvironmentGlobalIssues => _getPracticeCategoryPath("society_environment_global_issues.png");
  static String get shoppingMoneyServices => _getPracticeCategoryPath("shopping_money_services.png");
  static String get technologyModernLife => _getPracticeCategoryPath("technology_modern_life.png");
  static String get workBusinessCareer => _getPracticeCategoryPath("work_business_career.png");

  // Scenario icons
  static String get weekendPlans => _getScenarioCategoryPath("weekend_plans.png");
  static String get futureEducationGoals => _getScenarioCategoryPath("future_education_goals.png");
  static String get workFromHomeLifestyle => _getScenarioCategoryPath("work_from_home_lifestyle.png");
  static String get talkingAboutYourself => _getScenarioCategoryPath("talking_about_yourself.png");
  static String get sustainableLiving => _getScenarioCategoryPath("sustainable_living.png");
  static String get bookingHotelsAndFlights => _getScenarioCategoryPath("booking_hotels_and_flights.png");
  static String get professionalEmails => _getScenarioCategoryPath("professional_emails.png");
  static String get householdChores => _getScenarioCategoryPath("household_chores.png");
  static String get schoolAndCollegeLife => _getScenarioCategoryPath("school_and_college_life.png");
  static String get localCultureAndCustoms => _getScenarioCategoryPath("local_culture_and_customs.png");
  static String get givingAndReceivingFeedback => _getScenarioCategoryPath("giving_and_receiving_feedback.png");
  static String get morningAndNightRoutine => _getScenarioCategoryPath("morning_night_routine.png");
  static String get managingTime => _getScenarioCategoryPath("managing_time.png");
  static String get festivalsAndTraditions => _getScenarioCategoryPath("festivals_and_traditions.png"); 
  static String get returningOrExchangingProducts => _getScenarioCategoryPath("returning_or_exchanging_products.png");
  static String get expressingOpinionsPolitely => _getScenarioCategoryPath("expressing_opinions_politely.png");
  static String get dreamsAndGoals => _getScenarioCategoryPath("dreams_and_goals.png");
  static String get celebrationsFamilyEvents => _getScenarioCategoryPath("celebrations_family_events.png");
  static String get handlingConflictsPolitely => _getScenarioCategoryPath("handling_conflicts_politely.png");
  static String get savingAndBudgetingMoney => _getScenarioCategoryPath("saving_and_budgeting_money.png");
  static String get sharingExperiences => _getScenarioCategoryPath("sharing_experiences.png");
  static String get orderingFoodAtARestaurant => _getScenarioCategoryPath("ordering_food_at_a_restaurant.png");
  static String get workplaceCommunication => _getScenarioCategoryPath("workplace_communication.png");
  static String get onlineShoppingAndReviews => _getScenarioCategoryPath("online_shopping_and_reviews.png");
  static String get friendshipTrust => _getScenarioCategoryPath("friendship_trust.png");
  static String get theFutureOfTheWorld => _getScenarioCategoryPath("the_future_of_the_world.png");
  static String get askingForHelpInAStore => _getScenarioCategoryPath("asking_for_help_in_a_store.png");
  static String get animalWelfare => _getScenarioCategoryPath("animal_welfare.png");  
  static String get healthSelfCare => _getScenarioCategoryPath("health_self-care.png");
  static String get travelingAbroad => _getScenarioCategoryPath("traveling_abroad.png");
  static String get careerGoalsAndAmbitions => _getScenarioCategoryPath("career_goals_and_ambitions.png");
  static String get storytellingPractice => _getScenarioCategoryPath("storytelling_practice.png");
  static String get pollutionAndClimateChange => _getScenarioCategoryPath("pollution_and_climate_change.png");
  static String get artificialIntelligenceInDailyLife => _getScenarioCategoryPath("artificial_intelligence_in_daily_life.png");
  static String get describingPeople => _getScenarioCategoryPath("describing_people.png");
  static String get motivationAndInspiration => _getScenarioCategoryPath("motivation_and_inspiration.png");
  static String get usingPublicTransport => _getScenarioCategoryPath("using_public_transport.png");
  static String get talkingAboutKindness => _getScenarioCategoryPath("talking_about_kindness.png");
  static String get buyingClothesOrGadgets => _getScenarioCategoryPath("buying_clothes_or_gadgets.png");
  static String get genderEquality => _getScenarioCategoryPath("gender_equality.png");
  static String get onlineSafetyAndPrivacy => _getScenarioCategoryPath("online_safety_and_privacy.png");
  static String get foodFromDifferentCountries => _getScenarioCategoryPath("food_from_different_countries.png");
  static String get talkingAboutFeelings => _getScenarioCategoryPath("talking_about_feelings.png");
  static String get talkingAboutChildhood => _getScenarioCategoryPath("talking_about_childhood.png");
  static String get whatWouldYouDoIf => _getScenarioCategoryPath("what_would_you_do_if.png");
  static String get introducingYourFamily => _getScenarioCategoryPath("introducing_your_family.png");
  static String get balancingScreenTime => _getScenarioCategoryPath("balancing_screen_time.jpg");
  static String get favoriteSubjectsAndTeachers => _getScenarioCategoryPath("favorite_subjects_and_teachers.png");
  static String get talkingAboutMistakes => _getScenarioCategoryPath("talking_about_mistakes.png");
  static String get handlingStress => _getScenarioCategoryPath("handling_stress.png");
  static String get workLifeBalance => _getScenarioCategoryPath("worklife_balance.png");
  static String get jobInterviewPractice => _getScenarioCategoryPath("job_interview_practice.png");
  static String get travelExperiencesAndMemories => _getScenarioCategoryPath("travel_experiences_and_memories.png");
  static String get socialMediaInfluence => _getScenarioCategoryPath("social_media_influence.png");
  static String get onlineLearning => _getScenarioCategoryPath("online_learning.png");
  static String get stayingPositive => _getScenarioCategoryPath("staying_positive.png");
  static String get apologizingAndForgiving => _getScenarioCategoryPath("apologizing_and_forgiving.png");
  static String get describingFavoriteDishes => _getScenarioCategoryPath("describing_favorite_dishes.png");
  static String get bankingAndPayments => _getScenarioCategoryPath("banking_and_payments.png");
  static String get agreeingAndDisagreeing => _getScenarioCategoryPath("agreeing_and_disagreeing.png");
  static String get usingSmartphonesAndApps => _getScenarioCategoryPath("using_smartphones_and_apps.png");
  static String get comparingPricesAndDiscounts => _getScenarioCategoryPath("comparing_prices_and_discounts.png");
  static String get studyHabitsAndExamPreparation => _getScenarioCategoryPath("study_habits_and_exam_preparation.png");
  static String get lessonsLearnedFromLife => _getScenarioCategoryPath("lessons_learned_from_life.png");
  static String get timeManagementAtWork => _getScenarioCategoryPath("time_management_at_work.png");
  static String get dailySchedule => _getScenarioCategoryPath("daily_schedule.png");
  static String get learningNewSkills => _getScenarioCategoryPath("learning_new_skills.png");
  static String get talkingAboutRelationships => _getScenarioCategoryPath("talking_about_relationships.png");
  static String get peaceAndGlobalCooperation => _getScenarioCategoryPath("peace_and_global_cooperation.png");
  static String get wasteManagement => _getScenarioCategoryPath("waste_management.png");
  static String get helpingTheCommunity => _getScenarioCategoryPath("helping_the_community.png");
  static String get makingSmallTalk => _getScenarioCategoryPath("making_small_talk.png");
  static String get describingArtAndMusic => _getScenarioCategoryPath("describing_art_and_music.png");
  static String get makingBusinessCalls => _getScenarioCategoryPath("making_business_calls.png");
  static String get digitalAddiction => _getScenarioCategoryPath("digital_addiction.jpg");

  // Vocab Tab icons
  static String get level_1 => _getFullImagePath("level_1.svg");
  static String get level_2 => _getFullImagePath("level_2.svg");
  static String get level_3 => _getFullImagePath("level_3.svg");
  static String get level_4 => _getFullImagePath("level_4.svg");
  static String get level_5 => _getFullImagePath("level_5.svg");
  static String get level_6 => _getFullImagePath("level_6.svg");

  static String levelIcon(int index) => _getFullImagePath("level_${index + 1}.svg");

  static String get whisperTestAudio => "assets/audio/whisper_test.wav";
}