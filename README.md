# FitHerb

**FitHerb** is a modern wellness and health-focused mobile application developed with Flutter. It is designed to help users discover vitamins, supplements, and healthy lifestyle content while providing tools for social interaction and personalized data management.

This project serves as a **Midterm** submission for the "Cross-platform mobile development" course, demonstrating a full development lifecycle from UI/UX design to cloud integration and automated testing.

---

## Core Midterm Features & Customizations

*   **Wellness & Vitamin Database**: A comprehensive library of wellness products and supplements with detailed nutritional insights, benefits, and usage guides.
*   **Social Review System**: A customized feedback system allowing users to share and read real reviews for products and healthy-eating locations.
*   **Visual Identity Update**:
    *   **Professional Branding**: Migrated the entire theme to a sleek, health-focused **Material Green** palette.
    *   **Logo Enhancement**: Increased brand impact with a high-resolution **250x250** brand logo.
    *   **Modern UI Components**: Redesigned authentication buttons into compact, **stadium-shaped** elements.
    *   **UX Optimization**: Enabled constant button interactivity, removing restrictive input length checks for a smoother user flow.
*   **Interactive UI Experience**: Enhanced user engagement using custom animations, transitions, and **Opacity** effects in the login flow.

---

## Technical Implementation Journey (Ch 10–18)

### Chapter 10: Handling Shared Preferences
*   Implemented local persistence for simple UI states using the `shared_preferences` plugin.
*   Stored the user's last selected tab index and search history to maintain state across application restarts.

### Chapter 11: Serialization With JSON
*   Utilized `json_serializable` and **Freezed** for automated data model generation via `build_runner`.
*   Ensured type-safe parsing of complex JSON health data structures using `fromJson` and `toJson` factory methods.

### Chapter 12: Networking in Flutter
*   Established remote data fetching using the `http` package and migrated to **Chopper** for a professional networking layer.
*   Implemented **Request Interceptors** for automated API key management and **HttpLoggingInterceptor** for real-time traffic debugging.

### Chapter 13: Managing State (Riverpod)
*   Adopted **Riverpod** for robust global state management and **Dependency Injection (DI)** via `ProviderScope`.
*   Decoupled business logic from UI using the **Repository Pattern**, utilizing `overrides` for flexible service injection.

### Chapter 14: Working With Streams
*   Leveraged **Dart Streams**, `StreamController`, and **Broadcast Streams** to enable asynchronous, real-time UI updates.
*   Synchronized data across screens (e.g., Bookmarks and Grocery lists) using `StreamBuilder` for a reactive user experience.

### Chapter 15: Saving Data Locally (Drift)
*   Integrated the **Drift** library to provide a permanent local SQLite database with automated code generation (`.g.dart`).
*   Implemented **DAOs (Data Access Objects)** and handled **Schema Versioning** to manage structured storage with full offline support.

### Chapter 16: Firebase Cloud Firestore
*   Configured **Firebase Auth** for secure user registration, login, and real-time session management.
*   Developed a global real-time chat system using **Cloud Firestore** collections and configured **Security Rules** to protect user data.

### Chapter 17: Introduction to Testing
*   Established a unit testing suite using the **Arrange-Act-Assert (AAA)** pattern for core models (`Ingredient`, `Recipe`).
*   Utilized **Mockito** to create mock dependencies, enabling isolated testing of repositories without requiring a live database.

### Chapter 18: Widget Testing
*   Developed widget tests to verify UI structure and user interactions (tapping, checking) using the `WidgetTester` API and `pumpAndSettle`.
*   Implemented **Visual Regression Testing (Golden Tests)** via `golden_toolkit` to ensure design consistency across themes.

---

## Technical Stability & Platform Support
*   **Windows Desktop**: Resolved critical C++ compilation issues (`encodable_value.h`) to ensure stable Firebase and Drift performance on desktop.
*   **Android**: Fully optimized with **MultiDex** support and native performance tweaks for mobile devices.
*   **Clean Architecture**: Maintained a clear separation of concerns to ensure the codebase is scalable, maintainable, and testable.

---

## Getting Started

1.  **Generate Code**: This project uses `build_runner` for models, database, and mocks.
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
2.  **Run Tests**:
    ```bash
    flutter test
    ```
3.  **Update Goldens**:
    ```bash
    flutter test --update-goldens
    ```
