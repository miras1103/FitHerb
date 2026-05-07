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
*   **Robust Error Handling**: Updated `user_dao.dart` with localized, user-friendly error messages:
    *   Shows **"Incorrect email or password"** instead of generic "internal error".
    *   Handles **"This account already exists"** for registration.
    *   Specific feedback for invalid email formats and network connectivity issues.

### 2. Redesigned Login Experience (Green Theme)
*   **Visual Overhaul**: Switched the primary theme from pink to a professional **Material Green** palette.
*   **Logo Enhancement**: Increased the brand logo size to **250x250** for a more impactful first impression.
*   **Modern Components**: Redesigned Login and Sign Up buttons into compact, stadium-shaped elements.
*   **Improved UX**: Buttons are now always active and clickable, removing the previous restriction on character input length.

### 3. Dynamic User Profiles & Session Management
*   **Live Data**: The `AccountPage` now pulls the user's real email and display name directly from Firebase in real-time.
*   **Secure Logout**: Implemented a complete sign-out flow that clears the Firebase session and safely redirects the user to the login screen.

### 4. Navigation Optimization
*   **Simplified UI**: Removed non-functional and placeholder tabs ("Recipes" and "Groceries") from the bottom navigation bar to focus on core features: Explore, Orders, Chat, and Account.
*   **Navigation**: Refined `GoRouter` logic in `main.dart` and `home.dart` for more reliable tab-based navigation.

### 5. Technical Stability
*   **Windows Build Fix**: Resolved critical C++ compilation issues (`C2665` in `encodable_value.h`) encountered during Windows deployment by aligning and upgrading Firebase plugin versions.
