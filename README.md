
# SpeakEZ - AI English Learning Partner

SpeakEZ is a Flutter-based mobile application designed to help users improve their English speaking skills through interactive, AI-powered conversations and structured lessons. The app provides a safe and engaging environment for users to practice speaking in various real-life scenarios and receive instant feedback.

## ✨ Key Features

- **AI Conversation Partner:** Practice speaking with "Natasha," an AI coach, in a variety of real-world scenarios (e.g., job interviews, ordering food).
- **Structured Lessons:** Follow a curriculum based on CEFR levels (A1-C2), including vocabulary, grammar, and quizzes.
- **Instant Feedback:** Receive detailed analysis of your speaking performance, including scores for fluency, grammar, vocabulary, and pronunciation.
- **On-Device Speech Recognition:** Utilizes an offline Whisper model for fast and private speech-to-text transcription.
- **Personalized Experience:** Onboarding questions tailor the learning path to the user's goals, confidence level, and native language.
- **Progress Tracking:** Monitor your learning journey with statistics on your current streak and words learned.
- **Cross-Platform:** Built with Flutter for a consistent experience on both Android and iOS.

## 🛠️ Tech Stack & Architecture

The application is built with a modern tech stack, emphasizing a clean, scalable architecture.

- **Framework:** Flutter
- **Architecture:** MVC-like pattern with clear separation of concerns (Models, Views, Controllers).
- **State Management:** GetX for dependency injection, route management, and state management.
- **Backend & Services:**
  - **Firebase:** Used for authentication (Email/Password, Google Sign-In) and as a database (Cloud Firestore) for user profiles.
  - **Gemini API:** Powers the AI conversation partner and generates performance feedback.
- **Speech-to-Text:** Sherpa/ONNX with a Whisper model for efficient on-device transcription.
- **Key Libraries:**
  - `dio`: For making network requests to the Gemini API.
  - `lottie`: For engaging animations.
  - `permission_handler`: To handle device permissions (microphone).
  - `record`, `flutter_tts`: For audio recording and text-to-speech capabilities.
  - `shared_preferences`: For local data persistence.

## 🚀 Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- An IDE like VS Code or Android Studio

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/SpeakEZ.git
    cd SpeakEZ
    ```

2.  **Set up Firebase:**
    - Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    - Add an Android application to your Firebase project with the package name `com.english.learning.speakez.ai`.
    - Download the `google-services.json` file and place it in the `android/app/` directory.

3.  **Configure Android Signing:**
    - For release builds, you need to create a `key.properties` file in the `android/` directory with the following content:
      ```properties
      storePassword=<YOUR_STORE_PASSWORD>
      keyPassword=<YOUR_KEY_PASSWORD>
      keyAlias=<YOUR_KEY_ALIAS>
      storeFile=<PATH_TO_YOUR_KEYSTORE_FILE>
      ```

4.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

### Running the Application

- **Run in Debug Mode:**
  ```sh
  flutter run
  ```
- **Run in Release Mode:**
  ```sh
  flutter run --release
  ```

## 📂 Project Structure

The project is organized into the following main directories:

```
lib/
├── Constants/      # App-wide constants (assets, colors, strings)
├── Controllers/    # GetX controllers for managing state and business logic
├── Models/         # Data models (UserProfile, Lesson, etc.)
├── Screens/        # UI screens for different parts of the app
├── Services/       # Services for auth, database, and network calls
└── Utils/          # Helper classes and utility functions
assets/
├── audio/          # Audio files for lessons
├── images/         # SVG and PNG images
├── lessons/        # JSON files defining lesson content
└── lottie/         # Lottie animation files
```

## 📦 Building for Production

To build the application for production, use the following Flutter CLI commands:

- **Android (App Bundle):**
  ```sh
  flutter build appbundle --release
  ```

- **Android (APK):**
  ```sh
  flutter build apk --release
  ```

Make sure your signing configuration in `android/app/build.gradle.kts` and the `key.properties` file are set up correctly before building.

if transcription is happening with deepinfra api then isWhisperInitialized will be true
