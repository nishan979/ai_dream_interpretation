# AI Dream Interpretation

[![GitHub Repo](https://img.shields.io/badge/repo-nishan979/ai__dream__interpretation-0db7ed)](https://github.com/nishan979/ai_dream_interpretation) [![Flutter](https://img.shields.io/badge/flutter-%2302569B.svg?logo=flutter&logoColor=white)](https://flutter.dev) [![License](https://img.shields.io/github/license/nishan979/ai_dream_interpretation)](https://github.com/nishan979/ai_dream_interpretation/blob/main/LICENSE)

A Flutter app that interprets dreams using an AI-backed server and provides audio playback and speech features.

Repository: https://github.com/nishan979/ai_dream_interpretation

This README is intentionally complete and contains setup, build, troubleshooting, and publishing guidance so you can publish directly to GitHub.

---

## Repository at a glance

- Language: Dart (Flutter)
- Key packages: GetX, flutter_tts, audioplayers, speech_to_text, firebase_core, firebase_auth, google_sign_in, flutter_screenutil, flutter_stripe
- Main folders: `lib/`, `assets/`, `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`

## Screenshots

Click to enlarge. These files are included in `assets/ss/`.

![Screenshot 1](assets/ss/Screenshot_1761627142.png)

![Screenshot 2](assets/ss/Screenshot_1761627146.png)

![Screenshot 3](assets/ss/Screenshot_1761627153.png)

![Screenshot 4](assets/ss/Screenshot_1761627157.png)

---

## Quick start (development)

Prerequisites

- Flutter SDK (use a stable release compatible with Dart SDK `^3.8.0` — see `pubspec.yaml` environment).
- Platform SDKs for your targets (Android SDK for Android, Xcode for iOS, Visual Studio for Windows, etc.).

Verify your environment:

```powershell
flutter doctor
```

Clone and run

```powershell
git clone https://github.com/nishan979/ai_dream_interpretation.git
cd ai_dream_interpretation
flutter pub get

# Run on the default connected device
flutter run
```

Builds

Android APK (release):

```powershell
flutter build apk --release
```

iOS (release):

```powershell
# On macOS with Xcode configured
flutter build ios --release
```

Web (Chrome):

```powershell
flutter run -d chrome
```

Windows:

```powershell
flutter run -d windows
```

---

## Static analysis and formatting

Run the analyzer and formatter:

```powershell
flutter analyze
flutter format .
```

Notes:

- After comments were removed, `flutter analyze` may report `empty_catches` in a few places since some suppression comments were removed. I can either re-insert small no-op handlers (for example `final _ = e;`) or restore the original comments from `.comments_backup`.
- There are also a few `deprecated_member_use` notices around the `speech_to_text` plugin (it suggests migrating to `SpeechListenOptions`). I can update that code if you want.

---

## Tests

Run tests:

```powershell
flutter test
```

The repo contains a basic `test/widget_test.dart`. Add more unit / widget tests to `test/` as needed.

## Troubleshooting common issues

- Missing asset at runtime: confirm path declared in `pubspec.yaml` and run `flutter pub get`.
- Microphone / audio permission issues: confirm runtime permissions are requested (the app uses `permission_handler`).
- Audio served via ngrok: if you get HTML instead of audio, ensure your backend returns a direct audio URL or include the `ngrok-skip-browser-warning=true` cookie when fetching bytes.

---

## Features (at a glance)

- Dream entry: type or record your dream text and send to the AI backend for interpretation.
- Interactive follow-ups: the backend can return follow-up questions to clarify the dream.
- Audio output: interpretations can be returned as audio (TTS or pre-generated audio) and played inside the app.
- Speech-to-text input: use the microphone to dictate dreams (uses `speech_to_text`).
- Authentication & subscriptions: sign-up, login, and subscription flow with optional Stripe checkout integration.
- Offline-friendly playback: audio is streamed or downloaded then played using `audioplayers`.

---

## How it works (high-level)

1. The app sends the dream text (or recorded voice) to the backend endpoints (configured via `lib/constants.dart`).
2. The backend returns a JSON response with interpretation text, optional follow-up questions, and an `audio_url` when audio is generated.
3. The client plays audio either by streaming the URL or fetching bytes (with ngrok cookie handling for local tunnels) and uses TTS as fallback when needed.

---

## Configure backend & environment

- Open `lib/constants.dart` and set `baseUrl` to your backend (for emulator use `http://10.0.2.2:PORT` when testing locally).
- Ensure your backend exposes the endpoints the client expects (paths such as `/chatbot/dream/`, `/chatbot/voice/`, `/chatbot/voice-generate/`, `/auth/*`).

If your backend uses authentication, the client stores tokens in `flutter_secure_storage` and sends them as `Authorization: Bearer <token>` headers.

---

## Add your screenshots to the app (optional)

You added screenshots under `assets/ss/`. To include them in the built app add the path to `pubspec.yaml`:

```yaml
flutter:
	assets:
		- assets/images/
		- assets/icons/
		- assets/ss/
```

Then run:

```powershell
flutter pub get
```

---

## Recommended small housekeeping before publishing

- Remove or protect any private keys (for example in `android/` or `ios/` platform configs).
- Add `google-services.json` and other environment-specific files to `.gitignore` if they should not be public.
- Run `flutter analyze` and address warnings you care about (I can help insert small non-comment no-ops for empty catches if you want the analyzer clean).

---

## CI suggestion (GitHub Actions)

Create `.github/workflows/flutter-ci.yml` with the workflow shown earlier to run `flutter analyze` and `flutter test` on push/PR.

---

## Contributing

If you'd like help with any of the following I can prepare a branch + PR:

- Add `assets/ss/` to `pubspec.yaml` and run `flutter pub get`.
- Automatically insert small no-op exception handlers to silence `empty_catches` analyzer issues.
- Migrate deprecated `speech_to_text` arguments to `SpeechListenOptions`.
- Generate a human-readable changelog listing every automated edit (diff per file).

Tell me which action(s) and I will create a PR for you.
