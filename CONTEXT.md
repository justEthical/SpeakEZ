
Based on my analysis of the `lib` folder, here's what I understand about the SpeakEZ application:

*   **Architecture and State Management**: The application is built using Flutter and leverages the GetX framework for state management, dependency injection, and navigation. It follows a structured model-view-controller (MVC) like pattern, with clear separation of concerns into `Models`, `Screens`, and `Controllers`.

*   **Core Functionality**:
    *   **English Learning Lessons**: The app provides structured English lessons categorized by CEFR levels (A1-C2). Lessons include vocabulary, grammar tips, and various question types like multiple-choice, sentence rearrangement, and speaking exercises.
    *   **AI-Powered Speaking Practice**: A key feature is the ability to practice speaking with an AI partner ("Natasha") in various real-life scenarios (e.g., job interviews, ordering food). The app records user speech, transcribes it using an on-device Whisper model, and provides AI-generated feedback on fluency, grammar, and vocabulary.
    *   **Onboarding and Personalization**: The app has a comprehensive onboarding process that gathers user information (e.g., motivation, confidence level) to personalize the learning experience.

*   **Technical Implementation**:
    *   **Authentication**: It uses Firebase for user authentication, supporting both email/password and Google Sign-In.
    *   **Database**: Cloud Firestore is used to store user profiles and progress.
    *   **AI and Machine Learning**:
        *   It uses the Gemini API for generating AI responses and providing feedback on conversations.
        *   An on-device, offline speech-to-text model (Sherpa/ONNX with Whisper) is used for transcribing user audio, which is downloaded in the background.
    *   **Local Storage**: `shared_preferences` is used to store the user's authentication state and other session data.
    *   **Asset Management**: All assets (images, Lottie animations, audio files) and constants (colors, strings) are centrally managed in the `Constants` directory for easy maintenance.

*   **User Interface**:
    *   The UI is organized into distinct screens for onboarding, login/signup, home, lessons, practice, and settings.
    *   It features a tabbed navigation structure for easy access to the main "Progress" and "Practice" sections.
    *   The app uses Lottie animations for a more engaging user experience, especially for loaders, results, and alerts.

*   **Utilities and Helpers**: The project has a well-organized `Utils` directory containing helpers for common tasks like audio recording, text-to-speech (TTS), showing custom dialogs, and managing the Whisper AI model in a separate isolate for better performance.
