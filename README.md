# AI Dream Interpretation

AI Dream Interpretation is a Flutter mobile app that helps users record or type their dreams and receive AI-generated interpretations. The app also supports text-to-speech / audio-generation so users can listen to the interpretation.

This repository contains the Flutter client for the project and integrates with a backend that performs dream interpretation and generates audio files.

## Live demo / screenshots

Add screenshots or a short GIF in the `assets/` or `docs/` folder and show them here for best results.

## Features

- Type or record a dream and send it to the backend for interpretation.
- Receive natural-language interpretation(s) and follow-up questions.
- Play generated audio (text-to-speech / audio file) for any interpretation.
- Uses GetX for state management and routing.

## Tech stack

- Flutter (Dart)
- GetX (state management)
- audioplayers (audio playback)
- http / Multipart uploads
- A custom backend (not included) that exposes endpoints for dream interpretation and audio generation

## Quick start (client)

1. Prerequisites

   - Flutter SDK (stable) installed
   - Android Studio or VS Code for emulator/device
   - If you test against a local backend from the Android emulator, use `10.0.2.2` to reach your host machine.

2. Clone

   ```bash
   git clone https://github.com/nishan979/JVai_Projects.git
   cd JVai_Projects/ai_dream_interpretation
   ```

3. Get packages

   ```bash
   flutter pub get
   ```

4. Configure backend (required for interpretation & audio)

   - The app expects a backend `baseUrl` configured in `lib/constants.dart`. For local development you can set `baseUrl` to `http://10.0.2.2:5054` (Android emulator -> host machine).
   - The app uses endpoints such as `/chatbot/dream/` and `/chatbot/audio-generate/` to interact with the server.
   - If you expose your local backend over ngrok, the app handles ngrok audio responses by requesting audio bytes with the cookie `ngrok-skip-browser-warning=true`. Ensure your ngrok URL is returned by the backend in the `audio_url` field.

5. Run on an emulator or device

   ```bash
   flutter run
   ```

## Notes about audio playback & ngrok

- If your backend returns an `audio_url` hosted behind ngrok, ngrok may serve a browser-warning HTML page unless the `ngrok-skip-browser-warning=true` cookie is present. The Flutter client includes logic to fetch audio bytes using that cookie for ngrok-hosted files and play them from memory. If you host audio on a public server (HTTP/HTTPS) that supports direct access, the client will stream it normally.

## Troubleshooting

- If you see timeouts when loading audio:

  - Verify the `audio_url` is reachable from the emulator. Open the emulator browser and paste the URL.
  - If the backend uses `0.0.0.0`, replace it with `10.0.2.2` in responses for emulator testing or configure the backend to return a reachable host.
  - Check your backend logs to confirm the audio file exists and is being served.

- If playback fails with MEDIA_ERROR_UNKNOWN, try fetching the `audio_url` in a browser — if you get HTML instead of MP3, the client will attempt to fetch bytes with the ngrok cookie. If that still fails, check CORS or server configuration.

## Security / secrets

- Do NOT commit secrets or API keys. The client stores the `access_token` in `flutter_secure_storage` and sends it as a Bearer token in requests where required.

## Contributing

- Feel free to open issues and pull requests. If you want to contribute:
  1. Fork the repo and create a new branch for your feature.

2.  Write tests where applicable and keep changes focused.
3.  Open a pull request describing the change.

## License

This repository does not currently include a license file. If you want to open-source it, consider adding an OSI-approved license such as MIT. To add MIT, create a `LICENSE` file with the MIT text.

## Contact

- Project: https://github.com/nishan979/JVai_Projects
- Questions or feedback: open an issue on the repo or DM me on LinkedIn.

## Suggested README additions

- Add a short demo GIF or couple screenshots under a `docs/` folder.
- Add a simple `docker-compose` or local backend instructions if you plan to share the backend.
- Add badges (flutter, license, build) at the top of this README for credibility.

Enjoy!
