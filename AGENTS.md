# Ultimate Calculator - AI Coding Rules

## 1. Project Overview

This project is a production-ready Flutter mobile application named:

Ultimate Calculator

Application ID:
com.witchyu.ultimate_calculator

Primary target:
- Android

Future target:
- iOS

The project must be designed from the beginning so that future iOS development
does not require rewriting the application architecture.

---

## 2. Technology

Use:

- Flutter
- Dart
- Material 3
- Feature-based project structure
- Offline-first architecture

Do not replace Flutter with another framework unless explicitly requested.

Do not remove the existing iOS project.

Do not introduce unnecessary backend services.

---

## 3. Platform Requirements

Android is the current primary platform.

iOS must remain supported by the architecture.

When adding packages, prefer packages that support both:

- Android
- iOS

Before adding a dependency, verify that it is compatible with the project.

Do not add Android-only dependencies when a cross-platform solution exists.

---

## 4. Architecture

Use a simple feature-based architecture.

Preferred structure:

lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── extensions/
├── features/
│   ├── calculator/
│   ├── history/
│   ├── favorites/
│   ├── settings/
│   └── premium/
├── services/
│   ├── storage/
│   ├── ads/
│   └── billing/
└── shared/
    └── widgets/

Keep features separated.

Avoid putting the entire application inside main.dart.

Avoid creating unnecessarily complicated enterprise architecture.

Prefer readable and maintainable code.

---

## 5. UI / UX

Use Material 3.

The interface should be:

- Clean
- Modern
- Simple
- Fast
- Mobile-first
- Easy to understand
- Accessible

Support:

- Light mode
- Dark mode
- System theme

The application should work well on different Android screen sizes.

Avoid unnecessary animations.

Animations must not negatively affect performance.

---

## 6. Calculator Requirements

The calculator must correctly support:

### Basic

- Addition
- Subtraction
- Multiplication
- Division
- Percentage
- Positive / negative
- Decimal numbers
- Parentheses
- Operator precedence

### Scientific

- sin
- cos
- tan
- log
- ln
- square root
- square
- power
- pi
- e
- factorial
- parentheses
- DEG / RAD

### Error handling

Handle:

- Division by zero
- Invalid expressions
- Invalid mathematical operations
- Extremely large values
- Invalid factorial input
- Invalid logarithm input

Never allow a calculator error to crash the application.

---

## 7. Calculation Accuracy

Avoid unnecessary floating-point errors.

Important test case:

0.1 + 0.2

The displayed result should be handled appropriately for a calculator.

Test:

1 + 1 = 2

10 - 5 = 5

5 × 5 = 25

100 ÷ 4 = 25

10% = appropriate calculator result

2 + 3 × 4 = 14

(2 + 3) × 4 = 20

Division by zero = error state, never crash

---

## 8. History

Calculation history should support:

- Saving calculations
- Viewing previous calculations
- Tapping a calculation to reuse it
- Copying results
- Deleting individual records
- Clearing history

History should persist locally.

Do not require an internet connection.

---

## 9. Favorites

Favorites should support:

- Saving frequently used calculations
- Viewing favorites
- Reusing favorites
- Removing favorites

Persist favorites locally.

---

## 10. Offline First

Core calculator functionality must work completely offline.

Do not make calculator operations dependent on:

- Internet
- Backend APIs
- Cloud services

Internet should only be required for services that genuinely need it,
such as advertisements or store-related functionality.

---

## 11. Advertising

The application may use Google AdMob.

Use:

Rewarded Ads

as the primary monetization method for premium temporary unlocks.

Rewarded advertisements must always be:

- Optional
- User initiated
- Clearly identified
- Never deceptive

Never automatically force users to watch an advertisement.

Do not use intrusive advertisements that interrupt normal calculator usage.

During development use test advertisements.

Never commit real production ad IDs into source code.

---

## 12. Premium

Premium users should be able to:

- Remove advertisements
- Unlock premium calculator features
- Access future premium functionality

Premium should be designed to support:

- Google Play Billing
- Apple App Store purchases in the future

Do not hard-code platform-specific purchase logic throughout the UI.

Keep billing logic inside services.

---

## 13. Secrets

Never hard-code:

- API keys
- Secret keys
- Passwords
- Private tokens
- Production credentials

Never commit secrets to GitHub.

Use appropriate configuration or environment mechanisms.

---

## 14. Localization

Design the application so additional languages can be added later.

Do not hard-code large amounts of user-facing text directly throughout widgets.

Future languages may include:

- Thai
- English
- Chinese

The architecture must make localization possible without rewriting the UI.

---

## 15. Accessibility

Consider:

- Readable text sizes
- Sufficient touch target sizes
- Semantic labels
- Screen reader compatibility
- Good contrast
- Clear error messages

Do not rely only on color to communicate important information.

---

## 16. Performance

The calculator should feel instant.

Avoid:

- Unnecessary rebuilds
- Heavy background processing
- Unnecessary network requests
- Large dependencies without justification

Keep startup time fast.

---

## 17. Testing

Before major changes:

Run:

flutter analyze

and:

flutter test

New functionality should include appropriate tests.

At minimum, calculator logic should have unit tests.

Do not knowingly commit code with analyzer errors.

Do not knowingly commit broken tests.

---

## 18. Git Rules

Make small, logical commits.

Use descriptive commit messages.

Before committing:

flutter analyze
flutter test
git status

Never use destructive Git commands unless explicitly requested.

Do not delete project files without confirming that they are unnecessary.

---

## 19. AI Coding Agent Rules

When modifying the project:

1. Inspect the existing code first.
2. Understand the current architecture.
3. Make the smallest reasonable change.
4. Do not rewrite unrelated files.
5. Do not remove working functionality.
6. Do not change dependencies unnecessarily.
7. Test changes.
8. Run flutter analyze.
9. Run flutter test.
10. Report what was changed.

Do not assume that a generated solution is correct.

If a package is required, explain why it is needed.

Prefer built-in Flutter/Dart functionality when sufficient.

---

## 20. Reusable Architecture

This application will become the foundation for future utility applications.

Future applications may include:

1. Student Calculator
2. Finance Calculator
3. Date & Time Calculator
4. Health Calculator
5. Unit Converter
6. Image Tools
7. PDF Tools
8. QR & Barcode Tools
9. Text & Utility Tools

Reusable components should therefore be written in a way that allows future
projects to reuse:

- Theme
- Navigation
- Settings
- Localization
- Storage
- Ads
- Premium
- Analytics
- Common widgets
- Common utilities

Do not tightly couple calculator-specific logic to reusable infrastructure.

---

## 21. Analytics

Analytics may be added later.

Possible metrics:

- App opens
- Active users
- Most-used calculator functions
- Rewarded ad usage
- Premium conversion
- Crash reports

Analytics must respect platform policies and privacy requirements.

Do not add analytics unless explicitly required.

---

## 22. Privacy

Privacy must be considered from the beginning.

The Privacy Policy and Google Play Data Safety declarations must accurately
reflect the actual application behavior and SDKs being used.

Never claim that the application collects no data if a third-party SDK
actually collects data.

---

## 23. Release Requirements

Before production release:

- Run flutter analyze
- Run flutter test
- Build release version
- Verify application ID
- Verify app name
- Verify icons
- Verify signing configuration
- Verify AdMob configuration
- Verify billing configuration
- Verify privacy policy
- Verify Google Play Data Safety information
- Test on real Android devices

Use Android App Bundle (.aab) for Google Play release.

---

## 24. Important Rule

Do not over-engineer the application.

The goal is:

Simple code
+
Reliable functionality
+
Clean UI
+
Offline-first
+
Easy maintenance
+
Future iOS compatibility
+
Reusable architecture

Every technical decision should support these goals.
