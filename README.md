# Project Master Template

A comprehensive Flutter project template designed by Locio Raihan using **GetX** state management pattern. This template provides a solid foundation for building scalable Flutter applications with modern architecture patterns, best practices, and essential features.

## 🚀 Features

### **Core Architecture**
- ✅ **GetX State Management** - Reactive state management with dependency injection
- ✅ **Clean Architecture** - Organized folder structure with separation of concerns
- ✅ **Dependency Injection** - Service initialization and management
- ✅ **Environment Configuration** - Multiple environment support (dev, staging, prod)

### **UI/UX Components**
- ✅ **Dark/Light Theme** - Automatic theme switching with system preference
- ✅ **Custom Widget Library** - Reusable UI components (buttons, cards, inputs, etc.)
- ✅ **Loading States** - Loading, error, and empty state widgets
- ✅ **Responsive Design** - Consistent spacing and sizing system
- ✅ **Custom Typography** - Nunito font family integration

### **Networking & Data**
- ✅ **HTTP Client (Dio)** - Pre-configured with interceptors for logging and error handling
- ✅ **Local Storage** - SharedPreferences wrapper service
- ✅ **Connectivity Monitoring** - Real-time network status tracking
- ✅ **API Service** - Structured API calls with error handling

### **Developer Experience**
- ✅ **Comprehensive Logging** - Logger service with different log levels
- ✅ **Form Validation** - Common validators for forms
- ✅ **Utility Functions** - Helper functions for common tasks
- ✅ **Strict Linting** - Enhanced analysis options for code quality
- ✅ **Snackbars & Dialogs** - Pre-built notification and dialog systems

## 📁 Project Structure

```
lib/
├── app/
│   ├── core/                 # Core functionality
│   │   ├── config/          # Environment configuration
│   │   ├── services/        # Core services (connectivity, logging, DI)
│   │   ├── theme/           # Theme management and dimensions
│   │   ├── utils/           # Utility functions and validators
│   │   └── values/          # Constants and strings
│   ├── data/                # Data layer
│   │   ├── models/          # Data models
│   │   ├── service/         # API and storage services
│   │   ├── shared/          # Shared data components
│   │   └── themes/          # Color themes and styling
│   ├── modules/             # Feature modules
│   │   └── home/           # Home module example
│   │       ├── bindings/   # Dependency injection
│   │       ├── controllers/# Business logic
│   │       └── views/      # UI components
│   ├── routes/             # Navigation and routing
│   └── widgets/            # Reusable UI components
│       ├── buttons/        # Button components
│       ├── cards/          # Card components
│       ├── dialogs/        # Dialog and snackbar components
│       ├── inputs/         # Input field components
│       ├── loading/        # Loading components
│       └── states/         # State widgets (empty, error, loading)
└── main.dart               # Application entry point
```

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (^3.7.0)
- Dart SDK
- Android Studio / VS Code
- GetX CLI (optional but recommended)

### Installation

1. **Clone this template:**
   ```bash
   git clone <repository-url>
   cd project_master_template
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

### Environment Setup

The template supports multiple environments. You can run the app with different configurations:

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=production
```

## 📱 Usage Examples

### Creating a New Module

Use GetX CLI to generate new modules:

```bash
# Create a new page with controller, view, and binding
get create page:profile

# Create a new controller in existing module
get create controller:profile_settings on profile

# Create a new view in existing module
get create view:profile_edit on profile
```

### Using Custom Widgets

```dart
// Custom Button
AppButton(
  text: 'Submit',
  onPressed: () => controller.submit(),
  isLoading: controller.isLoading.value,
  icon: Icon(Icons.send),
)

// Custom Text Field
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  validator: AppValidator.email,
  onChanged: (value) => controller.updateEmail(value),
)

// Custom Card
AppCard(
  padding: AppSpacing.m,
  child: Column(
    children: [
      AutoSizeText('Card Title'),
      AutoSizeText('Card content'),
    ],
  ),
)
```

### Using Services

```dart
// Connectivity Service
final connectivityService = Get.find<ConnectivityService>();
if (connectivityService.hasConnection) {
  // Make API call
}

// Logger Service
final logger = Get.find<LoggerService>();
logger.info('User logged in');
logger.error('Error occurred', error);

// Storage Service
final storage = Get.find<StorageService>();
await storage.setString('user_token', token);
String? token = storage.getString('user_token');

// Theme Controller
final themeController = Get.find<ThemeController>();
themeController.toggleTheme();
```

### Showing Notifications

```dart
// Success message
AppSnackbar.success(
  title: 'Success',
  message: 'Operation completed successfully',
);

// Error message
AppSnackbar.error(
  title: 'Error',
  message: 'Something went wrong',
);

// Confirmation dialog
final confirmed = await AppDialog.confirm(
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
);
```

## 🎨 Theming

The template includes a comprehensive theming system:

### Colors
- Primary and secondary color schemes
- Material color palettes
- Dark and light theme variants
- Semantic colors (error, warning, success)

### Typography
- Nunito font family
- Consistent text styles
- Responsive font sizes

### Spacing & Sizing
- Consistent padding and margins
- Standardized component sizes
- Responsive breakpoints

## 🔧 Configuration

### API Configuration
Update the API base URL in `lib/app/core/config/environment.dart`:

```dart
static String get apiBaseUrl {
  switch (_environment) {
    case AppEnvironment.development:
      return 'https://your-dev-api.com';
    case AppEnvironment.production:
      return 'https://your-api.com';
    default:
      return 'https://your-dev-api.com';
  }
}
```

### App Configuration
Update app-specific configurations in `lib/app/core/values/app_values.dart`:

```dart
class AppValues {
  static const String appName = 'Your App Name';
  static const Duration connectTimeout = Duration(seconds: 30);
  // ... other configurations
}
```

## 📦 Dependencies

### Core Dependencies
- **get**: State management and dependency injection
- **dio**: HTTP client for API calls
- **shared_preferences**: Local data storage
- **connectivity_plus**: Network connectivity monitoring
- **logger**: Logging functionality
- **intl**: Internationalization support

### UI Dependencies
- **loading_animation_widget**: Loading animations
- **animated_bottom_navigation_bar**: Animated navigation
- **material_symbols_icons**: Extended icon set
- **auto_size_text**: Responsive text sizing

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate test coverage
flutter test --coverage
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

If you have any questions or need help with this template, please:
- Create an issue in the repository
- Check the documentation
- Review the example implementations

---

**Happy Coding!** 🚀
