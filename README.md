# Ride Booking App

> [!NOTE]
> A Flutter app for booking rides, built as part of a technical test, made by Ivan Territo.

## Features
- Location selection using Google Maps SDK. It is possible to select a point in the map tapping on it, or inserting an address in the search bar.
- Passenger count selection (min 1 max 10)
- Date and time picker
- Ride booking confirmation showing all the past info and a map with the selected locations

## Setup Instructions

### Stack used and requirements
- Flutter (Channel stable, 3.27.2, on Microsoft Windows [Versione 10.0.22631.5039], locale it-IT)
- Android Studio Meerkat | 2024.3.1 Patch 1
- Google Maps API Key

### Getting Started
1. Clone this repository:
   git clone https://github.com/IvanTerrito/alps2alps.git
   cd ride-booking-app

2. Set up Google Maps API:
- Create a project in [Google Cloud Console](https://console.cloud.google.com/)
- Enable Maps SDK for Android/iOS
- Generate an API key or use the one provided in the demo project

3. (If you change API Key) Configure API Key:
- **Android**: In `android/app/src/main/AndroidManifest.xml`, add:
  ```xml
  <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_API_KEY" />
  ```
- **iOS**: In `ios/Runner/AppDelegate.swift`, add:
  ```swift
  GMSServices.provideAPIKey("YOUR_API_KEY")
  ```
- **GOOGLE_MAPS_API**: In `constants/strings.dart`, edit:
  ```dart
  final String GOOGLE_MAPS_API = "YOUR_API_KEY";
  ```
  And in `ios/Runner/Info.plist`:
  ```xml
  <key>io.flutter.embedded_views_preview</key>
  <true/>
  ```

4. Install dependencies:
   ```dart
    flutter pub get

5. Run the app:
   ```dart
   flutter run

## Project Structure
- `lib/core/`: constants, themes, and utils folders
- `lib/models/`: Data models
- `lib/screens/`: App screens
- `lib/providers/`: RideBookingProvider
- `lib/widgets/`: Reusable widgets
- `lib/services/`: API and business logic services
- `main.dart`: main.dart file