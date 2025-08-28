# PostHog Integration Guide

## Overview
PostHog has been integrated into the SpeakEZ project to track user events, errors, and analytics.

## Configuration

### 1. API Key Setup
Update the PostHog API key in `/lib/Services/posthog_service.dart`:
```dart
// Add your PostHog API key and host configuration
// You may want to use environment variables or a config file
```

### 2. PostHog Initialization
PostHog is initialized in `main.dart` when the app starts:
```dart
await PostHogService.instance.initialize();
```

## Event Tracking

### Event Constants
All event names are defined in `/lib/Constants/posthog_events.dart`. This ensures consistency across the application.

### Categories of Events:

#### Authentication Events
- `user_signed_up`
- `user_logged_in`
- `user_logged_out`
- `authentication_error`

#### Lesson Events
- `lesson_started`
- `lesson_completed`
- `question_answered`
- `vocabulary_viewed`

#### Practice Events
- `practice_started`
- `practice_completed`
- `scenario_selected`

#### Error Events
- `error_occurred`
- `api_call_failed`
- `network_error`
- `firebase_error`

#### UI Events
- `button_clicked`
- `tab_changed`
- `screen_viewed`

## Usage Examples

### Tracking Button Clicks
```dart
PostHogService.instance.captureClick(
  'submit_button',
  elementType: 'button',
  screenName: 'login_screen',
);
```

### Tracking Errors in Try-Catch Blocks
```dart
try {
  // Your code here
} catch (e) {
  PostHogService.instance.captureError(
    PostHogEvents.apiCallFailed,
    errorMessage: e.toString(),
    location: 'ClassName.methodName',
    additionalProperties: {'context': 'additional_info'},
  );
}
```

### Tracking Screen Views
```dart
PostHogService.instance.captureScreenView('home_screen');
```

### Identifying Users
```dart
PostHogService.instance.identify(
  userId,
  userProperties: {
    'email': userEmail,
    'name': userName,
  },
);
```

## Files Modified

### Core Integration Files:
1. `/lib/Services/posthog_service.dart` - PostHog service implementation
2. `/lib/Constants/posthog_events.dart` - Event name constants
3. `/lib/main.dart` - PostHog initialization

### Services with Error Tracking Added:
1. `/lib/Services/auth_service.dart` - Authentication error tracking
2. `/lib/Services/network_service.dart` - Network and API error tracking
3. `/lib/Services/firestore_helper.dart` - Firebase error tracking
4. `/lib/Services/appwrite_service.dart` - Appwrite error tracking

### Controllers with Error Tracking Added:
1. `/lib/Controllers/question_options_controller.dart` - Lesson loading error tracking
2. `/lib/Controllers/home_screen_controller.dart` - File system error tracking

### Utils with Error Tracking Added:
1. `/lib/Utils/audio_chunk_recorder.dart` - Audio recording error tracking
2. `/lib/Utils/whisper_helper.dart` - Whisper transcription error tracking (in comments, as it runs in isolate)

### Screens with Event Tracking Added:

#### Onboarding:
1. `/lib/Screens/OnBoarding/onboarding_screen.dart` - Onboarding flow tracking
   - Screen view tracking
   - Next/Previous button clicks
   - Onboarding completion

#### Lessons:
1. `/lib/Screens/Lessons/qna_screen.dart` - Lesson Q&A tracking
   - Screen view tracking
   - Lesson started event
   - Audio listen button clicks

#### Practice:
1. `/lib/Screens/Practice/chat_screen.dart` - Practice chat tracking
   - Screen view tracking
   - Practice started event
   - Practice exited event with message count

#### Settings:
1. `/lib/Screens/SettingsScreen/setting_screens.dart` - Settings screen tracking
   - Screen view tracking
   - Settings opened event
   - Close button clicks
2. `/lib/Screens/SettingsScreen/Widgets/settings_option_tile.dart` - Settings option clicks

#### Navigation:
1. `/lib/Screens/tab_bar_screen.dart` - Tab navigation tracking
2. `/lib/Screens/HomeScreen/home_screen.dart` - Home screen view tracking

#### Login:
1. `/lib/Screens/Login/Widgets/login_button.dart` - Login button clicks
   - Email login button
   - Google login button

## Best Practices

1. **Always use event constants** from `posthog_events.dart` instead of hardcoding event names
2. **Add error tracking** to all try-catch blocks with meaningful context
3. **Track user actions** that are important for understanding user behavior
4. **Include relevant metadata** in event properties for better analysis
5. **Test events** in PostHog dashboard to ensure they're being captured correctly

## Next Steps

1. **Add your PostHog API key** to the service configuration
2. **Configure PostHog host** if using self-hosted instance
3. **Test the integration** in development environment
4. **Set up dashboards** in PostHog for monitoring
5. **Consider adding more specific events** based on your analytics needs

## Privacy Considerations

- Ensure compliance with privacy regulations (GDPR, CCPA, etc.)
- Consider implementing user consent for tracking
- Avoid logging sensitive personal information
- Use PostHog's built-in privacy features when needed