# Recall — Exam Flashcards

Offline-first Flutter app for students preparing for an exam. Build decks of
question/answer cards, flip through them, and mark each as known or missed.
Missed cards come back sooner (spaced repetition), and the app counts down to
the exam date and plans each day's study.

## Features

- Onboarding: exam name and date, optional name, daily goal
- Home: countdown, due cards, study streak, deck shortcuts
- Arabic (default, RTL) and English, light and dark themes

Decks, study sessions, exam mode, stats, plan and settings are in progress.

## Stack

| Concern | Choice |
|---|---|
| State | `flutter_bloc` (Cubit) |
| Navigation | `go_router` (`StatefulShellRoute` for the bottom nav) |
| DI | `get_it` |
| Data | `sqflite` (decks, cards, reviews), `shared_preferences` (settings) |
| Errors | custom `Result<T, Failure>` (no `dartz`) |
| i18n | Flutter Intl (`intl_utils`), ARB files in `lib/l10n` |

There is no backend: no network, accounts or sync.

## Getting started

```bash
flutter pub get
flutter run
```

Debug builds seed sample decks on first launch so Home is not empty.
Release builds start empty.

### Code generation

Generated files are committed. Regenerate after changing models or ARB files:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run intl_utils:generate
```

### Checks

```bash
flutter analyze
flutter test
```

## Project layout

```
lib/
  core/        shared theme, widgets, models, repos, domain, DI, routing
  features/    onboarding, home, ... (views, cubits and widgets only)
  l10n/        ARB sources
```

Engineering rules live in [CLAUDE.md](CLAUDE.md); the design handoff is
`recall-exam-flashcards.html` and `design-tokens.tokens.json`.
