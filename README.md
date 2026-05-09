# FitHerb (Yummy)

A modern Flutter project focused on health, vitamins, and wellness.

## Project Evolution & Core Changes

1.  **Asset Refresh**: Updated assets for categories, restaurants, and food to align with the FitHerb brand.
2.  **Code Refactoring**:
    *   `restaurant.dart` -> `my_restaurant.dart`
    *   `post.dart` -> `my_post.dart`
    *   `food_category.dart` -> `my_food_category.dart`
3.  **Web Support**: Updated `index.html` title to **FitHerb**.
4.  **UI Localization**: Changed "Food near me" to "Vitamins" in `Restaurant_section.dart`.

## Midterm Feature Set
5.  **Interactive Animations**: Implemented opacity animations in the login flow.
6.  **Review System**: Customized the `buildReviewsSection` in `restaurant_page.dart`.
7.  **Vitamin Database**: Expanded and refined the content in `vitamins.dart`.

## Recent Advanced Improvements

### 1. Full Firebase Integration
*   **Cross-Platform Support**: Configured `firebase_core` and `firebase_auth` to work seamlessly on both Android and **Windows Desktop**.
*   **Robust Error Handling**: Updated `user_dao.dart` with localized, user-friendly error messages.
*   **Global Chat**: Real-time messaging system using **Cloud Firestore**.

### 2. Redesigned Login Experience (Green Theme)
*   **Visual Overhaul**: Switched the primary theme from pink to a professional **Material Green** palette.
*   **Logo Enhancement**: Updated brand identity with a high-resolution 250x250 logo.
*   **Modern UI**: Redesigned Login and Sign Up buttons into compact, stadium-shaped elements.

### 3. Navigation Optimization
*   **Simplified UI**: Removed non-functional and placeholder tabs to focus on Explore, Orders, Chat, and Account.
*   **Routing**: Refined `GoRouter` logic for more reliable tab-based navigation.

### 4. Automated Testing (Chapter 17)
*   **Unit Tests**: Added automated tests for core models (`Ingredient`, `Recipe`).
*   **Mocking**: Integrated `Mockito` to test `DBRepository` logic in isolation without a real database.
*   **Architecture**: Refactored code to use Dependency Injection for better stability and testability.

### 5. Technical Stability
*   **Windows Build Fix**: Resolved critical C++ compilation issues encountered during Windows deployment by aligning Firebase plugin versions.
