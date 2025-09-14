# Repository Guidelines

## Project Structure & Module Organization
- Entry point: `lib/main.dart`. UI lives under `lib/Screens/`, logic in `lib/Controllers/`, data models in `lib/Models/`, services (network, auth, analytics) in `lib/Services/`, utilities in `lib/Utils/`, constants in `lib/Constants/`.
- Tests: `test/` (e.g., `test/unified_model_test.dart`).
- Assets: `assets/` (declare in `pubspec.yaml`). Platform code: `android/`, `ios/`.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`.
- Run analyzer: `flutter analyze` (fails on warnings per `analysis_options.yaml`).
- Format code: `dart format .` (use trailing commas to aid formatting).
- Run tests: `flutter test`.
- Run app: `flutter run -d <device>`.
- Build release: Android `flutter build apk`; iOS `flutter build ipa` (or open in Xcode).

## Coding Style & Naming Conventions
- Dart style with 2-space indent, null-safety, prefer `final` and immutability.
- File names: `snake_case.dart`; class/Widget names: `PascalCase`.
- Keep widgets small and composable; lift state into Controllers (GetX) where appropriate.
- Avoid `print`; prefer `debugPrint` and service-layer logging (e.g., `PostHogService`).

## Testing Guidelines
- Framework: `flutter_test` (unit + widget tests). Name tests `*_test.dart` and group with `group(...)`/`test(...)`.
- Cover: model parsing (see `Models/`), controller logic, and critical widgets. Add fixtures under `test/fixtures/` if needed.
- Run locally with `flutter test`; ensure deterministic tests (no real network—mock Services).

## Commit & Pull Request Guidelines
- Commits: imperative, concise subject, optional scope (e.g., `fix: guard null lesson intro`, `feat(controllers): unlock test flow`). Reference issues/PRs when relevant.
- PRs: clear description, link issues, list changes, include screenshots/GIFs for UI, and note testing done. CI must pass `analyze`, `format`, and `test`.

## Security & Configuration Tips
- Do not commit secrets. Keep `.env` local; prefer `--dart-define` for runtime config. Rotate keys if exposed.
- External services (Firestore/Auth, PostHog): gate calls in `Services/` and avoid leaking PII in logs/analytics.

