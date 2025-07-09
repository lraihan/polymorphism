# Polymorphism Portfolio

A modern, responsive Flutter Web portfolio showcasing the identity of an Ultimate Polymorphism who balances engineering, art, and design.

## ✨ Features

- **Responsive Design** - Optimized for mobile, tablet, and desktop
- **Interactive Animations** - Cursor reveal effects, scroll animations, and smooth transitions
- **Modern UI/UX** - Dark theme with elegant typography and spacing
- **Real-time Contact Form** - Integrated EmailJS functionality with secure environment variables
- **Dynamic Timeline** - Interactive career progression showcase
- **Project Gallery** - Responsive layouts for mobile and desktop projects
- **Real-time Clock** - Jakarta timezone display in footer
- **Secure Configuration** - Environment variables for API credentials

## 🛠 Tech Stack

- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **GetX** - State management and dependency injection
- **Custom Animations** - Scroll reveal and cursor effects

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  get: ^4.6.6
  url_launcher: ^6.3.1
  google_fonts: ^6.2.1
  visibility_detector: ^0.4.0
  grain: ^0.0.1
  auto_size_text: ^3.0.0
  flutter_tilt: ^3.2.1
  stacked_card_carousel: ^0.0.4
  intl: ^0.19.0
  lucide_icons_flutter: ^3.0.6
```

## 🏗 Project Structure

```
lib/
├── core/
│   ├── constant.dart           # Screen utilities and spacing
│   ├── services/               # Email service
│   └── theme/                  # App theme and colors
├── data/
│   └── models/                 # Career events model
├── modules/
│   ├── contact/                # Contact form section
│   ├── home/                   # Hero, about sections and main page
│   ├── standout/               # Typography showcase section
│   ├── timeline/               # Career timeline section
│   └── works/                  # Projects showcase section
├── shared/
│   ├── animations/             # Scroll reveal animations
│   ├── footer/                 # Global footer
│   ├── widgets/                # Reusable UI components
│   └── scroll_timeline_indicator.dart
└── main.dart                   # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.7.0)
- Dart SDK
- Web browser for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/lraihan/polymorphism-portfolio.git
cd polymorphism-portfolio
```

2. Install dependencies:
```bash
flutter pub get
```

3. **Set up environment variables** (required for email functionality):
```bash
cp .env.example .env.local
# Edit .env.local with your EmailJS credentials
```
See [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) for detailed instructions.

4. Run the application:
```bash
./run_dev.sh
```
Or manually:
```bash
flutter run -d chrome --dart-define=EMAILJS_SERVICE_ID="your_service_id" --dart-define=EMAILJS_TEMPLATE_ID="your_template_id" --dart-define=EMAILJS_PUBLIC_KEY="your_public_key"
```

### Build for Production

```bash
./build_prod.sh
```
Or manually:
```bash
flutter build web --release --dart-define=EMAILJS_SERVICE_ID="your_service_id" --dart-define=EMAILJS_TEMPLATE_ID="your_template_id" --dart-define=EMAILJS_PUBLIC_KEY="your_public_key"
```

## 🎨 Customization

### Personal Information

Update personal details in:
- `lib/modules/home/cursor_reveal_hero_section.dart` - Name and titles
- `lib/modules/home/about_section.dart` - About text and statistics
- `lib/data/models/career_event.dart` - Career timeline events
- `lib/shared/footer/footer.dart` - Social links and contact info

### Projects

Add your projects in `lib/modules/works/works_section.dart`:

```dart
_buildProject(
  context,
  'Your Project Title',
  'Project description and details',
  'assets/images/works/your-project-1.png',
  ProjectType.mobile, // or ProjectType.desktop
),
```

### Assets

Place your images in:
- `assets/images/` - General images (logo, backgrounds)
- `assets/images/works/` - Project screenshots
- `assets/fonts/` - Custom fonts (if any)

### Contact Form

The contact form currently simulates email sending. To enable real email functionality:

1. Set up an email service (EmailJS, Firebase, or custom backend)
2. Update `lib/core/services/email_service.dart`
3. Configure your email credentials

### Theme Colors

Customize colors in `lib/core/theme/app_theme.dart`:

```dart
class AppColors {
  static const Color accent = Color(0xFFYourColor);
  static const Color textPrimary = Color(0xFFYourColor);
  static const Color bgDark = Color(0xFFYourColor);
}
```

## 🌐 Deployment

### GitHub Pages

1. Build the web version:
```bash
flutter build web --base-href "/your-repo-name/"
```

2. Deploy the `build/web` folder to GitHub Pages

### Netlify

1. Build for web:
```bash
flutter build web
```

2. Deploy the `build/web` folder to Netlify

## 📊 Performance

- **Lighthouse Score**: 95+ Performance
- **First Paint**: <1.5s
- **Interactive**: <2.0s
- **Mobile Optimized**: Full responsive design

## 🔧 Development

### Code Style

- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Keep functions small and focused
- Document complex logic

### Adding New Sections

1. Create a new widget in `lib/modules/your_section/`
2. Add it to the main page in `lib/modules/home/pages/home_page.dart`
3. Update navigation in `lib/shared/widgets/glass_navbar.dart`

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Contact

- **Email**: lraihan@hackermail.com
- **LinkedIn**: [Raihan Fadli](https://www.linkedin.com/in/raihan-fadli-dev/)
- **GitHub**: [@lraihan](https://github.com/lraihan)
- **Instagram**: [@locio_raihan](https://www.instagram.com/locio_raihan/)

---

**Built with ❤️ using Flutter Web**
