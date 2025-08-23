# Flutter AI Development Prompt Rules & Design Schema

## 1. Project Structure Rules

### 1.1 Directory Organization
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   └── app_constants.dart
│   ├── themes/
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── extensions.dart
│   └── errors/
│       ├── failures.dart
│       └── exceptions.dart
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── datasources/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── controllers/
├── shared/
│   ├── widgets/
│   ├── animations/
│   └── services/
└── main.dart
```

### 1.2 File Naming Conventions
- Use **snake_case** for all Dart files
- Prefix private implementation files with underscore
- Group related files with common prefixes (e.g., `auth_screen.dart`, `auth_controller.dart`)

## 2. Design System Rules

### 2.1 Color Schema
```dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF..);     // Main brand color
  static const Color primaryLight = Color(0xFF..);
  static const Color primaryDark = Color(0xFF..);

  // Secondary Colors
  static const Color secondary = Color(0xFF..);
  static const Color accent = Color(0xFF..);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
}
```

### 2.2 Typography System
```dart
class AppTypography {
  // Display Styles
  static TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  // Headline Styles
  static TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  // Title Styles
  static TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
  );

  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Label Styles
  static TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
}
```

### 2.3 Spacing System
```dart
class AppSpacing {
  // Base unit: 8px
  static const double xs = 4.0;   // 0.5x
  static const double sm = 8.0;   // 1x
  static const double md = 16.0;  // 2x
  static const double lg = 24.0;  // 3x
  static const double xl = 32.0;  // 4x
  static const double xxl = 48.0; // 6x
  static const double xxxl = 64.0; // 8x

  // Component specific
  static const double cardPadding = 16.0;
  static const double screenPadding = 20.0;
  static const double listItemSpacing = 12.0;
}
```

### 2.4 Border Radius System
```dart
class AppRadius {
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}
```

## 3. Component Design Rules

### 3.1 Button Components
```dart
// ALWAYS create consistent button styles
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  // Variants: primary, secondary, tertiary, danger
  // Sizes: small (32h), medium (40h), large (48h)
}
```

### 3.2 Card Components
```dart
class AppCard extends StatelessWidget {
  // MUST include:
  // - Consistent padding (16px default)
  // - Elevation (1-4 based on hierarchy)
  // - Border radius (12px default)
  // - Background color (surface color)
}
```

### 3.3 Input Fields
```dart
class AppTextField extends StatelessWidget {
  // MUST include:
  // - Label text
  // - Helper text
  // - Error text
  // - Prefix/Suffix icons
  // - Consistent height (56px default)
  // - Border radius (8px)
  // - Focus states
  // - Validation states
}
```

## 4. Layout Rules

### 4.1 Responsive Design
```dart
class ResponsiveBreakpoints {
  static const double mobile = 0;      // 0-599
  static const double tablet = 600;    // 600-1023
  static const double desktop = 1024;  // 1024+

  // MUST use LayoutBuilder or MediaQuery for responsive layouts
  // MUST test on multiple screen sizes
}
```

### 4.2 Safe Area Usage
- **ALWAYS** wrap screens with SafeArea
- **NEVER** hardcode status bar or navigation bar heights
- Use `MediaQuery.of(context).padding` for custom implementations

### 4.3 Scrollable Content
- **ALWAYS** use SingleChildScrollView for forms
- Use ListView.builder for large lists
- Implement pull-to-refresh where appropriate
- Add scroll physics (BouncingScrollPhysics for iOS feel)

## 5. State Management Rules

### 5.1 Provider/Riverpod Pattern
```dart
// ALWAYS separate business logic from UI
class FeatureController extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;

  // Methods
  Future<void> performAction() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Business logic
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## 6. Animation Rules

### 6.1 Duration Standards
```dart
class AppAnimations {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // PREFER Material motion curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeOutCubic;
}
```

### 6.2 Common Animations
- Page transitions: 300ms with CupertinoPageRoute or custom
- Fade in/out: 200ms
- Scale animations: 200ms
- List item animations: Stagger by 50ms

## 7. Performance Rules

### 7.1 Widget Optimization
- **USE** `const` constructors wherever possible
- **PREFER** StatelessWidget over StatefulWidget when state isn't needed
- **EXTRACT** repeated widgets into separate widget classes
- **AVOID** unnecessary rebuilds with proper key usage

### 7.2 Image Handling
```dart
// ALWAYS specify dimensions for network images
CachedNetworkImage(
  imageUrl: url,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 8. Accessibility Rules

### 8.1 Semantic Labels
- **ALWAYS** add semanticLabel to images
- **ALWAYS** add tooltip to IconButtons
- **USE** Semantics widget for custom interactive elements

### 8.2 Touch Targets
- Minimum touch target: 48x48 logical pixels
- Add padding to small interactive elements
- Ensure adequate spacing between clickable items

## 9. Error Handling Rules

### 9.1 User Feedback
```dart
// ALWAYS provide visual feedback for:
// - Loading states (CircularProgressIndicator or Shimmer)
// - Empty states (illustrated message)
// - Error states (clear error message with retry option)
// - Success states (SnackBar or Dialog)
```

### 9.2 Form Validation
- Validate on submit AND on field blur
- Show inline error messages
- Disable submit button until form is valid
- Provide helpful error messages

## 10. Code Quality Rules

### 10.1 Documentation
```dart
/// Brief description of what this widget does.
///
/// Longer description if needed, explaining use cases
/// and important details.
///
/// Example:
/// ```dart
/// MyWidget(
///   param: value,
/// )
/// ```
class MyWidget extends StatelessWidget {
  /// Description of this parameter
  final String param;

  const MyWidget({
    Key? key,
    required this.param,
  }) : super(key: key);
}
```

### 10.2 Testing Requirements
- Widget tests for all custom widgets
- Unit tests for business logic
- Integration tests for critical user flows
- Golden tests for complex UI components

## Implementation Checklist

When implementing any Flutter screen or component, verify:

- [ ] Follows the defined directory structure
- [ ] Uses consistent color and typography systems
- [ ] Implements proper spacing using AppSpacing
- [ ] Handles all states (loading, error, empty, success)
- [ ] Is responsive across different screen sizes
- [ ] Includes proper animations
- [ ] Has semantic labels for accessibility
- [ ] Follows Material Design or iOS guidelines
- [ ] Includes error handling and user feedback
- [ ] Has proper documentation
- [ ] Includes relevant tests
- [ ] Uses const constructors where possible
- [ ] Implements proper state management pattern
- [ ] Follows null safety best practices

This comprehensive rule set ensures consistent, maintainable, and professional Flutter applications with excellent user experience and developer experience.

this is an example rule and you don't follow every structure and only create one at once, not create all at once


follow this rule and don't modify my style, my function unless I require
