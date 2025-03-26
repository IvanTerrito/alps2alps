# ivan_territo_alps2alps
Interview project

# Ride Booking App

A Flutter app for booking rides, built as part of a technical test.

## Features
- Location selection using Google Maps SDK
- Passenger count selection
- Date and time picker
- Ride booking confirmation showing all the past info

## Setup Instructions

### Prerequisites
- Flutter SDK (2.5.0 or higher)
- Android Studio / XCode
- Google Maps API Key

### Getting Started
1. Clone this repository:
   git clone https://github.com/yourusername/ride-booking-app.git
   cd ride-booking-app

2. Set up Google Maps API:
- Create a project in [Google Cloud Console](https://console.cloud.google.com/)
- Enable Maps SDK for Android/iOS
- Generate an API key

3. Configure API Key:
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
  And in `ios/Runner/Info.plist`:
  ```xml
  <key>io.flutter.embedded_views_preview</key>
  <true/>
  ```

4. Install dependencies:
   flutter pub get

5. Run the app:
   flutter run

## Project Structure
- `lib/models/`: Data models
- `lib/screens/`: App screens
- `lib/widgets/`: Reusable widgets
- `lib/services/`: API and business logic services