# Padhai - CBSE Adaptive Learning App
AI-powered learning app for CBSE Class 8 students with adaptive quiz difficulty and personalized learning paths.

## Features

- 📚 **Structured Learning**: Science & Mathematics chapters with detailed topics
- 🎯 **Adaptive Quizzes**: Difficulty adjusts based on performance
- 📊 **Progress Tracking**: Track completion across topics and chapters
- 🔖 **Bookmarks**: Save topics and questions for later
- 📈 **Analytics**: View detailed performance insights
- 🔄 **Review Mode**: Practice incorrect answers
- 🔥 **Streaks**: Maintain daily learning streaks

## Tech Stack

- **Framework**: Flutter 3.38.9
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Architecture**: Clean Architecture
- **DI**: GetIt + Injectable

## Project Structure

```
lib/
├── app/              # App configuration, theme, router
├── core/             # Database, DI, network, storage
├── features/         # Feature modules (auth, dashboard, quiz, etc.)
└── shared/           # Shared widgets and utilities
```

## Getting Started

```bash
# Get dependencies
flutter pub get

# Generate code (Drift, Injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run app
flutter run
```

## Architecture

Each feature follows Clean Architecture:
- **Presentation**: Screens, Widgets, Providers (Riverpod)
- **Domain**: Entities, Use Cases, Services
- **Data**: Models, Data Sources, Repositories

## Documentation

See `/docs` folder for complete specifications:
- DOC-001: Master Index
- DOC-002: App Requirements
- DOC-003: Database Schema
- DOC-004: Architecture Guide
- DOC-005: UI Specification
- DOC-006: API Contracts
- DOC-007: Business Logic
- DOC-008: Testing Specification
- DOC-009: Phase Execution
- DOC-010: Quality Gates

## Version

**v1.0.0** - Initial Release for CBSE Class 8

## License

Private - All rights reserved