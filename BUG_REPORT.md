# SpeakEZ Bug Analysis Report

## Executive Summary

A comprehensive analysis of the SpeakEZ Flutter project revealed **35+ bugs and issues** across Controllers, Models, and Services. The most critical issues involve memory leaks, null safety violations, and missing error handling that could cause crashes in production.

---

## CRITICAL BUGS (Fix Immediately)

### 1. Memory Leak: StreamSubscription Never Cancelled
**Files:** `lib/Controllers/practice_controller.dart:130-146`, `lib/Controllers/question_options_controller.dart:281-307`

```dart
sub = globalController.isLastChunkTranscribed.listen((val) {
  if (val) {
    // ... processing ...
    sub.cancel();  // Only cancels if condition is met!
  }
});
```
**Problem:** If `val` is never `true`, the subscription is never cancelled, causing memory leaks. Multiple calls create orphaned subscriptions.

**Fix:** Always cancel previous subscription before creating new one, and ensure cleanup in `onClose()`.

---

### 2. Missing Dispose Methods in All Controllers
**Files:** All controller files

**Missing cleanup for:**
- `practice_controller.dart:31,36,37` - `chatScrollController`, `recordingAnimationcontroller`, `lottieAnimationcontroller`
- `question_options_controller.dart:21,37,38` - `questionPageController`, `wordMeaningPageController`, `grammerTipPageController`
- `global_controller.dart:67-85` - `ReceivePort` for Whisper isolate never closed

**Fix:** Add `@override void onClose()` to all controllers.

---

### 3. Null Safety Violations - Force Unwraps Without Checks
**Multiple locations:**

| File | Line | Code |
|------|------|------|
| `practice_controller.dart` | 227 | `currentScenarioModel!.prompt` |
| `practice_controller.dart` | 291, 301 | `currentScenarioModel!.intro` |
| `home_screen_controller.dart` | 48 | `jsonDecode(profileData!)` |
| `onboarding_controller.dart` | 76 | `jsonDecode(userProfileData!)` |
| `question_options_controller.dart` | 173 | `grammar![randomIndexList[i]]` |

**Problem:** These will crash if the value is null.

**Fix:** Add null checks before accessing.

---

### 4. Switch Statement Fall-Through Bug
**File:** `lib/Controllers/question_options_controller.dart:358-370`

```dart
case QuestionType.speaking:
  isContinueButtonEnabled.value = true;  // Missing break!
default:
  isContinueButtonEnabled.value = currentSelectedOptionIndex.value != 100;
```
**Problem:** Missing `break;` causes speaking questions to execute default case too.

**Fix:** Add `break;` after the speaking case.

---

### 5. API Response Parsing Without Bounds Checking
**File:** `lib/Services/network_service.dart:76-77`

```dart
return response.data['choices'][0]['message']['content'];  // No length checks!
```
**Problem:** Assumes `choices` array is non-empty. Will throw `RangeError` if empty.

**Fix:** Check `choices?.isNotEmpty == true` before accessing.

---

### 6. Empty API Key Fallback
**File:** `lib/Services/network_service.dart:69,116,149`

```dart
'Authorization': 'Bearer ${dotenv.env['DEEP_INFRA_API_KEY'] ?? ''}',
```
**Problem:** Uses empty string fallback - API calls silently fail instead of throwing error.

**Fix:** Validate API key exists and throw if missing.

---

### 7. Missing Null Check in Scores.fromMap
**File:** `lib/Models/ai_response_model.dart:91-100`

```dart
fluency: _asInt(map['fluency']),  // Will throw if key missing
```
**Problem:** No null check - crashes if any score field is missing from API response.

**Fix:** Add null coalescing: `map['fluency'] ?? 0`

---

### 8. Missing `feedback` Parameter in copyWith
**File:** `lib/Models/ai_response_model.dart:53-68`

```dart
AIResponseModel copyWith({
  // ... other params ...
  // MISSING: String? feedback
}) {
  return AIResponseModel(
    // ...
    feedback: feedback  // References undefined parameter!
  );
}
```
**Problem:** `feedback` field cannot be updated via copyWith - references instance variable instead of parameter.

**Fix:** Add `String? feedback` parameter.

---

## HIGH PRIORITY BUGS

### 9. Division by Zero Risk
**File:** `lib/Controllers/practice_controller.dart:164`

```dart
"fluency": fluency / aiResponseList.length,  // If list is empty!
```
**Fix:** Check `aiResponseList.isEmpty` before dividing.

---

### 10. Enum Parsing Without Fallback
**File:** `lib/Models/lesson_model.dart:214`

```dart
type: QuestionType.values.firstWhere((e) => e.name == json['type']),
```
**Problem:** Throws `StateError` if type doesn't match any enum value.

**Fix:** Add `orElse: () => QuestionType.multipleChoice`.

---

### 11. Fire-and-Forget Async Methods
**Files:**
- `lib/Controllers/global_controller.dart:92` - `void loadVersion() async`
- `lib/Controllers/onboarding_controller.dart:215` - `void addLanguageBasedQuestionInOnboarding() async`

**Problem:** Errors are silently swallowed. Should be `Future<void>`.

---

### 12. Missing HTTP Status Code Check
**File:** `lib/Services/network_service.dart:170-171`

```dart
final response = await dio.post(apiUrl, ...);
return body['text'];  // No check if response.statusCode == 200!
```

---

### 13. Uninitialized Late Variable
**File:** `lib/Controllers/question_options_controller.dart:44`

```dart
late Lesson currentLessonModel;
```
Used in `updateLesssonProgress()` without guaranteed initialization.

---

### 14. Race Condition in Recording
**File:** `lib/Controllers/question_options_controller.dart:281-307`

Multiple calls to `stopRecording()` create multiple subscriptions without cleanup.

---

### 15. Timer Not Always Cancelled
**File:** `lib/Controllers/practice_controller.dart:39,58,114,348`

`_timer` can be left running in some execution paths.

---

## MEDIUM PRIORITY ISSUES

### 16. Model Depends on Controller (Architecture Violation)
**File:** `lib/Models/ai_response_model.dart:3,37`

```dart
import 'package:speak_ez/Controllers/global_controller.dart';
// ...
jsonDecode(globalController.removeTickMarksJson(source))
```
Models should not import controllers - violates separation of concerns.

---

### 17. Global Variable Anti-Pattern
**File:** `lib/Controllers/global_controller.dart:186`

```dart
GlobalController globalController = GlobalController.instance;
```
Creates untestable tight coupling throughout the app.

---

### 18. Inconsistent Error Handling
Some places use `PostHog.captureError`, others use `print()`. No centralized strategy.

---

### 19. Silent Error in Firestore
**File:** `lib/Services/firestore_helper.dart:23-39`

Returns void without throwing when user is null - caller doesn't know update failed.

---

### 20. Type Safety Issues
**File:** `lib/Controllers/question_options_controller.dart:158`

```dart
var randomIndexList = [];  // Should be List<int>
```

---

## LOW PRIORITY (Code Quality)

### 21. Naming Typos
- `currenSpeakingText` should be `currentSpeakingText` (`question_options_controller.dart:48`)
- `currenEnglishLessonLevel` should be `currentEnglishLessonLevel` (`home_screen_controller.dart:14`)
- `OnboarindViewModel` should be `OnboardingViewModel` (`onboarding_view_model.dart:3`)

### 22. Magic Numbers
- `maxNumberOfAiResponsesPerSession: 5/10`
- `remainingSeconds: 30`
- `currentSelectedOptionIndex != 100`

### 23. Duplicate Streak Logic
Same streak calculation code exists in multiple controllers.

### 24. Large Controller Classes
- `PracticeController`: 487 lines
- `QuestionOptionsController`: 485 lines

---

## Files Requiring Modification

| File | Issues Count | Priority |
|------|--------------|----------|
| `lib/Controllers/practice_controller.dart` | 8 | CRITICAL |
| `lib/Controllers/question_options_controller.dart` | 7 | CRITICAL |
| `lib/Controllers/global_controller.dart` | 4 | CRITICAL |
| `lib/Models/ai_response_model.dart` | 5 | CRITICAL |
| `lib/Services/network_service.dart` | 4 | CRITICAL |
| `lib/Controllers/home_screen_controller.dart` | 2 | HIGH |
| `lib/Controllers/onboarding_controller.dart` | 3 | HIGH |
| `lib/Models/lesson_model.dart` | 2 | HIGH |
| `lib/Models/user_profile.dart` | 2 | MEDIUM |
| `lib/Services/firestore_helper.dart` | 1 | MEDIUM |

---

## Recommended Fix Order

1. **Phase 1 - Critical Crashes:** Fix null safety violations and missing bounds checks
2. **Phase 2 - Memory Leaks:** Add `onClose()` methods to all controllers
3. **Phase 3 - Data Integrity:** Fix copyWith, enum parsing, API key validation
4. **Phase 4 - Error Handling:** Add proper try-catch and error propagation
5. **Phase 5 - Code Quality:** Fix typos, magic numbers, architecture issues
