# Flutter Firebase Authentication App - Technical Test

A comprehensive Flutter application demonstrating Firebase Authentication with email verification, password reset, and user management features. This project was built as a technical assessment for PT. FAN INTEGRASI TEKNOLOGI.

## 🛠 Technology Stack

- **Framework**: Flutter 3.16+ (Cross-platform mobile development)
- **Backend**: Firebase (Authentication, Firestore Database)
- **State Management**: Provider (Recommended by Flutter team)
- **Programming Language**: Dart
- **Build System**: Gradle (Android), Xcode (iOS)

## 📦 Dependencies

### Core Dependencies
```yaml
firebase_core: ^2.24.2          # Firebase SDK core
firebase_auth: ^4.15.3          # Authentication services
cloud_firestore: ^4.13.6       # NoSQL database
provider: ^6.1.1                # State management
```

### UI & Validation
```yaml
email_validator: ^2.1.17       # Email format validation
flutter_spinkit: ^5.2.0        # Loading animations
```

### Development & Testing
```yaml
mockito: ^5.4.4                 # Mock objects for testing
build_runner: ^2.4.7           # Code generation
flutter_lints: ^3.0.0          # Dart linting rules
```

### Why These Libraries?

- **Provider**: Chosen for its simplicity and official Flutter team support
- **Firebase**: Industry-standard backend-as-a-service for authentication and database
- **Email Validator**: Ensures proper email format validation
- **Mockito**: Essential for unit testing with mock objects

## 🚀 Installation Guide

### Prerequisites

1. **Flutter SDK**: Version 3.16.0 or higher
   ```bash
   flutter --version
   # If not installed: https://flutter.dev/docs/get-started/install
   ```

2. **Development Environment**:
   - Android Studio or VS Code
   - Xcode (for iOS development - macOS only)
   - Git version control

3. **Firebase Account**: Create at [Firebase Console](https://console.firebase.google.com)

### Step-by-Step Installation

#### 1. Clone Repository
```bash
git clone https://github.com/FadhlanMinallah/fan_technical_mdtest.git
cd fan_technical_mdtest
```

#### 2. Install Flutter Dependencies
```bash
flutter pub get
```

#### 3. Firebase Project Setup

**Create Firebase Project:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Enter project name: `fan-technical-mdtest`
4. Enable Google Analytics (optional)
5. Click "Create project"

**Enable Authentication:**
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider
5. Save changes

**Create Firestore Database:**
1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode"
4. Select your preferred location
5. Click "Done"

#### 4. Android Configuration

**Add Android App:**
1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.example.fan_technical_mdtest`
3. Enter app nickname: `Fan Technical MDTest`
4. Download `google-services.json`
5. Place the file in `android/app/` directory

**Configure Android Build:**

Edit `android/build.gradle`:
```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

#### 5. iOS Configuration (macOS only)

**Add iOS App:**
1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID: `com.example.fanTechnicalMdtest`
3. Download `GoogleService-Info.plist`
4. Add the file to `ios/Runner/` in Xcode

#### 6. Verify Installation
```bash
# Check Flutter configuration
flutter doctor -v

# Clean build
flutter clean
flutter pub get

# Test run
flutter run
```

### Local Properties Configuration

Create/edit `android/local.properties`:
```properties
sdk.dir=/Users/yourusername/Library/Android/sdk
flutter.sdk=/Users/yourusername/development/flutter
flutter.versionCode=1
flutter.versionName=1.0.0
```

## 🏗 Project Structure

```
lib/
├── main.dart                     # Application entry point
├── models/                       # Data models
│   └── user_model.dart          # User data structure
├── services/                     # Business logic layer
│   ├── auth_service.dart        # Firebase Authentication operations
│   └── firestore_service.dart   # Firestore database operations
├── providers/                    # State management
│   └── auth_provider.dart       # Authentication state management
├── screens/                      # UI screens
│   ├── auth/                    # Authentication screens
│   │   ├── login_screen.dart    # User login interface
│   │   ├── register_screen.dart # User registration interface
│   │   └── forgot_password_screen.dart # Password reset interface
│   └── home/                    # Main application screens
│       └── home_screen.dart     # Dashboard with user management
├── widgets/                      # Reusable UI components
│   ├── custom_button.dart       # Styled button component
│   ├── custom_text_field.dart   # Styled input field component
│   └── loading_widget.dart      # Loading animation component
└── utils/                        # Utility functions and constants
    └── constants.dart           # Application constants
```

## 🔧 Configuration Files

### Firebase Security Rules (Production)

**Firestore Rules** (`firestore.rules`):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read all users for the list feature
    match /users/{document=**} {
      allow read: if request.auth != null;
    }
  }
}
```

### Gradle Configuration

**android/gradle.properties**:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m
android.useAndroidX=true
android.enableJetifier=true
android.compileSdkVersion=34
android.targetSdkVersion=34
org.gradle.parallel=true
org.gradle.configureondemand=true
org.gradle.daemon=true
org.gradle.caching=true
```

## 🧪 Testing

### Running Tests
```bash
# Run all unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/providers/auth_provider_test.dart

# Generate mock files
flutter packages pub run build_runner build
```

### Test Coverage Areas

- **Authentication Services**: Login, registration, password reset
- **State Management**: Provider pattern implementation
- **Data Models**: User model serialization/deserialization
- **Error Handling**: Network failures, invalid inputs
- **Firestore Operations**: CRUD operations, real-time updates

### Sample Test Structure
```dart
// Example test file structure
group('AuthProvider Tests', () {
  late AuthProvider authProvider;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    authProvider = AuthProvider();
  });

  test('should handle sign in success', () async {
    // Test implementation
  });
});
```

## 📱 Usage Guide

### User Registration Flow
1. Open the app
2. Tap "Sign Up" on login screen
3. Fill in name, email, and password
4. Submit registration
5. Check email for verification link
6. Click verification link in email
7. Return to app and refresh status

### Authentication Features
- **Login**: Existing users can sign in with email/password
- **Registration**: New users create accounts with email verification
- **Password Reset**: Users can reset forgotten passwords via email
- **Email Verification**: Real-time status tracking and manual resend options

### Home Dashboard Features
- **Profile Info**: Display current user's verification status
- **User List**: Browse all registered users
- **Search**: Find users by name or email
- **Filter**: Show only verified or unverified users
- **Real-time Updates**: Automatic status updates when users verify emails

## 🔒 Security Features

- **Password Security**: Handled by Firebase Authentication
- **Email Verification**: Prevents unauthorized account usage
- **Input Validation**: Client-side validation for all forms
- **Error Handling**: Graceful handling of network and authentication errors
- **Firestore Rules**: Server-side security rules for data access

## 🚀 Build & Deployment

### Development Build
```bash
# Debug build for testing
flutter run --debug

# Profile build for performance testing
flutter run --profile
```

### Production Build

**Android:**
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

**iOS:**
```bash
# Build for iOS
flutter build ios --release

# Archive for App Store
# (Use Xcode for final submission)
```

### Build Optimization
- **Code Obfuscation**: Enabled in release builds
- **Tree Shaking**: Removes unused code
- **Asset Optimization**: Compressed images and resources

## 🔧 Troubleshooting

### Common Issues & Solutions

**Firebase Configuration Issues:**
```bash
# Verify Firebase files are in correct locations
ls -la android/app/google-services.json
ls -la ios/Runner/GoogleService-Info.plist

# Reconfigure Firebase if needed
flutterfire configure
```

**Build Errors:**
```bash
# Clean build cache
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# Reset Gradle cache
rm -rf ~/.gradle/caches/
```

**Deprecated API Warnings:**
- These warnings don't affect functionality
- Update dependencies regularly: `flutter pub upgrade`
- Use `flutter pub outdated` to check for updates

**Email Verification Issues:**
- Check spam/junk email folders
- Verify Firebase project settings
- Ensure Authentication is enabled in Firebase Console

### Performance Optimization
- Use `flutter analyze` for code quality checks
- Monitor app size with `flutter build apk --analyze-size`
- Profile performance with `flutter run --profile`

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### Code Standards
- Follow Dart/Flutter style guide
- Write unit tests for new features
- Update documentation for API changes
- Use meaningful commit messages

### Testing Requirements
- Unit tests required for all new features
- Integration tests for critical user flows
- Maintain >80% test coverage

### Technical Support
- Create issues in GitHub repository for bugs
- Use discussions for feature requests
- Check existing issues before creating new ones

## 🎯 Future Enhancements

### Planned Features
- **Profile Management**: User profile editing and photo upload
- **Social Authentication**: Google, Apple, Facebook login options
- **Push Notifications**: Real-time notifications for important events
- **Offline Support**: Local data caching and sync
- **Advanced Analytics**: User behavior tracking and reporting
- **Multi-language Support**: Internationalization (i18n)
- **Dark Mode Theme**: Alternative UI theme
- **Biometric Authentication**: Fingerprint/Face ID support

### Technical Improvements
- **CI/CD Pipeline**: Automated testing and deployment
- **Code Coverage Reports**: Detailed test coverage analysis
- **Performance Monitoring**: Firebase Performance integration
- **Crash Reporting**: Firebase Crashlytics integration
- **A/B Testing**: Firebase Remote Config for feature flags

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Guide](https://dart.dev/guides/language)
- [Provider State Management](https://pub.dev/packages/provider)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)