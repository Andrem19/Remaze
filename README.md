# Remaze

Flutter maze game prototype with multiplayer-oriented game systems.

Remaze is a cross-platform Flutter project built around maze navigation, map editing, battles, leaderboards, QR-based invitations, audio effects, Firebase-backed state, and mobile ads. The project is an archived game prototype kept public as a portfolio example of a larger Flutter app with controllers, routes, views, services, and custom game assets.

## Features

- Maze gameplay screens and reusable map tile widgets.
- Map editor flow for building maze layouts.
- Battle and multiplayer-oriented controllers.
- Search/invite flow with QR code support.
- Leaderboard and profile settings screens.
- Audio effects and game theme assets.
- Firebase integration points for database, storage, and Firestore.
- Google Mobile Ads integration using official test ad unit IDs.
- Cross-platform Flutter project structure for Android, iOS, macOS, web, Linux, and Windows.

## Tech Stack

- Flutter
- Dart
- GetX
- Firebase Core
- Firebase Realtime Database
- Cloud Firestore
- Firebase Storage
- Flame Audio
- Google Mobile Ads
- QR scanner and QR rendering packages

## Repository Structure

```text
lib/
  controllers/  Game, battle, routing, QR, profile, and editor controllers
  models/       Maze, cube, player, leader, and game state models
  services/     Utility services for validation, conversion, device info, dialogs
  views/        Game, editor, leaderboard, profile, and widget UI
assets/
  audio/        Game sound effects and theme audio
  images/       Maze, icon, teleport, and snowflake assets
```

## Firebase Setup

Project-specific Firebase generated files are intentionally not tracked in this public repository.

To run the app with your own Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This regenerates `lib/firebase_options.dart` and platform config files such as `google-services.json` and `GoogleService-Info.plist`.

## Local Development

```bash
flutter pub get
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Notes

This is an archived prototype. The repository uses placeholder Firebase configuration in the public copy, so a real Firebase project must be configured before running the full online feature set.
