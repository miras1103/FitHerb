# FitHerb

**FitHerb** is a modern wellness and health-focused mobile application developed with Flutter. It is designed to help users discover vitamins, supplements, and healthy lifestyle content while providing tools for social interaction and personalized data management.

This project serves as a submission for the "Cross-platform mobile development" course, demonstrating a full development lifecycle from UI/UX design to cloud integration and automated testing.

---

## Core Midterm Features & Customizations

*   **Wellness & Vitamin Database**: A comprehensive library of wellness products and supplements with detailed nutritional insights, benefits, and usage guides.
*   **Social Review System**: A customized feedback system allowing users to share and read real reviews for products and healthy-eating locations.
*   **Visual Identity Update**:
    *   **Professional Branding**: Migrated the entire theme to a sleek, health-focused **Material Green** palette.
    *   **Logo Enhancement**: Increased brand impact with a high-resolution **250x250** brand logo.
    *   **Modern UI Components**: Redesigned authentication buttons into compact, **stadium-shaped** elements.
    *   **UX Optimization**: Enabled constant button interactivity, removing restrictive input length checks for a smoother user flow.

---

## Final Endterm Features: Firebase Cloud Integration

**Feature 1: Firebase Firestore Favorites**
*   **Implementation**: Migrated the local bookmarking system to **Cloud Firestore**.
*   **Real-time Synchronization**: Uses Firestore `snapshots()` to keep the UI (favorites list and heart icons) updated in real-time.
*   **Premium Favorite Cards**: Redesigned favorites as interactive cards with quick-remove functionality and high-quality image rendering.

**Feature 2: Product Reviews & Feedback System**
*   **Implementation**: Implemented a cloud-based feedback system for vitamins.
*   **Live Review Feed**: Reviews are displayed in real-time on the product details page with a modern, clean comment thread UI.

**Feature 3: Saving Order History**
*   **Implementation**: Migrated the order management system to **Cloud Firestore**.
*   **Digital Receipt UI**: Redesigned the order history as a series of modern digital receipts, featuring real-time status badges (e.g., "COMPLETED"), calculated totals, and order timestamps.
*   **Cloud Persistence**: All order data is securely stored under the user's UID for cross-device accessibility.

**Feature 4: Advanced Profile Management**
*   **Firestore Dashboard**: Transformed the account page into a personal wellness dashboard.
*   **Extended Attributes**: Users can customize their **First Name**, **Last Name**, and **Age**, stored securely in a dedicated Firestore `users` collection.
*   **Profile Analytics**: Added a visual stat bar showing **Total Orders** and **Favorites Count** for a more engaging user experience.
*   **Reactive Profile Header**: Implemented a premium profile header with a "Verified Member" badge and instant cloud synchronization via `StreamBuilder`.

---

## Technical Stability & Platform Support
*   **Windows Desktop**: Resolved critical C++ compilation issues to ensure stable Firebase and Drift performance.
*   **Android**: Fully optimized with **MultiDex** support and native performance tweaks.
*   **Clean Architecture**: Maintained a clear separation of concerns using **Riverpod** for state management and the **Repository Pattern**.

---

## Built With

*   [Flutter](https://flutter.dev) - Framework
*   [Riverpod](https://riverpod.dev) - State Management & DI
*   [Firebase](https://firebase.google.com) - Auth & Cloud Firestore
*   [Drift](https://drift.simonbinder.eu) - Local SQLite Database
*   [Chopper](https://pub.dev/packages/chopper) - Networking layer
*   [Freezed](https://pub.dev/packages/freezed) - Immutable modeling

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
