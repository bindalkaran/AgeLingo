# AgeLingo

AgeLingo is a mobile and web app designed to bridge the communication gap between generations by translating slang and generational language. It supports five generations: Baby Boomers, Gen X, Millennials, Gen Z, and Gen Alpha.

## Live Demo

Visit the live web app: [AgeLingo Web App](https://agelingo.com)

## Features

- **Real-time Translation**: Translate phrases between different generations
- **Comprehensive Dictionary**: Browse a collection of generational terms and their meanings
- **Speech-to-Text**: Speak your phrase for quick translation
- **Dark Mode**: Toggle between light and dark themes
- **Search History**: Keep track of your recent translations
- **Custom Terms**: Add your own generational terms

## GitHub Pages Deployment

The app is deployed using GitHub Pages with a custom domain. Here's how it's set up:

1. The web build is automatically deployed via GitHub Actions workflow
2. A custom domain (agelingo.com) is configured through GitHub Pages settings
3. CNAME file is included in the web build directory

To update the custom domain:
1. Go to repository Settings > Pages
2. Enter your custom domain in the "Custom domain" field
3. Save the configuration
4. The GitHub Actions workflow will maintain the CNAME file for you

## Deployment Guide

### Web Deployment

The app is built and ready for web deployment. To deploy the web version:

1. Use the pre-built files in the `build/web` directory
2. Upload the entire `build/web` directory to your web hosting service
3. Configure your web server to serve the `index.html` file as the entry point

### Android Deployment

To prepare the Android app for deployment:

1. Update the `applicationId` in `android/app/build.gradle.kts` to your unique ID
2. Configure signing keys in the `android/app/build.gradle.kts` file
3. Run `flutter build apk --release` to create a release APK
4. The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

### iOS Deployment

To prepare the iOS app for deployment:

1. Run `flutter create --platforms=ios .` to add iOS configuration
2. Open the iOS project in Xcode: `open ios/Runner.xcworkspace`
3. Configure app signing, bundle ID, and capabilities in Xcode
4. Run `flutter build ios --release` to create a release build
5. Archive and distribute through App Store Connect

## Recent Changes (v1.1.0)

- Added support for Generation Alpha (born 2013-present)
- Implemented search history feature
- Added speech-to-text functionality with toggle in settings
- Expanded vocabulary to 48 terms across all generations
- Enhanced translation accuracy and visual feedback
- Fixed issue with Generation Alpha years not appearing in dropdowns
- Improved UI with better visual cues for translated terms
- Added example phrases based on generation
- Enabled dark mode support

## Development

To set up the development environment:

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app in debug mode

## Technologies Used

- Flutter
- Dart
- Provider for state management
- Shared Preferences for local storage
- Speech-to-Text for voice input
- GitHub Pages for web hosting

## Credits

Developed by Karan Bindal

## License

Copyright © 2025 AgeLingo 