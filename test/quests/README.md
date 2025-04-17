# QuestKeeper Tests

This directory contains tests for the QuestKeeper application.

## Badge Tests

Badge-related tests are located in the `/quests` directory:

### Running Tests

To run all badge tests at once:

```bash
flutter test test/quests/badges_test.dart
```

To run a specific test file:

```bash
flutter test test/quests/models/badge_model_test.dart
```

### Test Structure

- **Models**
  - `badge_model_test.dart`: Tests for the Badge data model
  - `user_badge_model_test.dart`: Tests for the UserBadge data model

- **Repositories**
  - `badges_repository_test.dart`: Tests for the BadgesRepository class that handles API interactions

- **Providers**
  - `badges_provider_test.dart`: Tests for the BadgesManager provider (state management)

- **Widgets**
  - `achievement_list_test.dart`: Widget tests for the AchievementList component

### Helpers

The `test/helpers/mock_helpers.dart` file contains common mock classes and test data used across tests.

## Test Coverage

These tests cover:

1. Data model serialization/deserialization
2. Repository API interactions
3. State management through providers
4. Widget rendering and interactions

## Adding New Tests

When adding new tests:

1. Follow the existing directory structure
2. Import and add new test suites to the appropriate group test file
3. Use the mock helpers for consistent test data
4. Ensure proper isolation between tests 