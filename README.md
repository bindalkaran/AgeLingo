# AgeLingo

A Flutter application that bridges the communication gap between generations by translating slang and generational language.

![AgeLingo Logo](https://agelingo.com/favicon.png)

## Live Demo

Visit the web app: [AgeLingo Web App](https://agelingo.com)

## About

AgeLingo is designed to facilitate better understanding across different generations. The app provides translation, dictionary lookup, and custom terminology features that help users understand and communicate across the Baby Boomer, Gen X, Millennial, Gen Z, and Gen Alpha generations.

## Features

- **Real-time Translation**: Translate phrases and slang between different generations
- **Comprehensive Dictionary**: Browse a collection of generational terms and their meanings
- **Speech-to-Text**: Speak your phrase for quick translation
- **Dark Mode**: Toggle between light and dark themes for comfortable viewing
- **Search History**: Keep track of your recent translations
- **Custom Terms**: Add your own generational terms to expand the database
- **Haptic Feedback**: Enhanced user experience with subtle vibrations
- **Animations**: Smooth, delightful interface transitions and interactions

## Installation

### Web (Recommended)

The easiest way to use AgeLingo is through the web app at [agelingo.com](https://agelingo.com).

### Building from Source

If you want to run the app locally:

1. Make sure you have Flutter installed ([Flutter Installation Guide](https://flutter.dev/docs/get-started/install))
2. Clone this repository:
   ```
   git clone https://github.com/bindalkaran/AgeLingo.git
   ```
3. Navigate to the project directory:
   ```
   cd AgeLingo/age_lingo
   ```
4. Get dependencies:
   ```
   flutter pub get
   ```
5. Run the app:
   ```
   flutter run
   ```

## Technology Stack

- **Flutter**: Cross-platform UI toolkit
- **Dart**: Programming language
- **Provider**: State management
- **Shared Preferences**: Local storage for user settings
- **Speech-to-Text**: Voice input processing
- **GitHub Pages**: Web hosting
- **GitHub Actions**: CI/CD pipeline

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
├── screens/               # App screens
├── utils/                 # Utilities and helpers
└── widgets/               # Reusable UI components
```

## Recent Updates (v1.1.0)

- Added support for Generation Alpha (born 2013-present)
- Implemented search history feature
- Added speech-to-text functionality with toggle in settings
- Enhanced animations and transitions throughout the app
- Improved loading performance and UI responsiveness
- Added haptic feedback for better user experience
- Updated UI with better visual cues for translated terms
- Added developer information

## Contributing

Contributions to improve AgeLingo are welcome! Feel free to:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature`)
6. Create a new Pull Request

## Developer

AgeLingo is developed by Karan Bindal, a passionate software engineer interested in human-computer interaction and cross-generational communication.

## License

Copyright © 2025 Karan Bindal. All rights reserved. 