# Flutter WhatsApp Clone

## Overview

This project is a WhatsApp clone built using Flutter for the front-end and Firebase for the backend. 
It aims to provide a scalable and feature-rich messaging application with a user-friendly interface. 
The project leverages Flutter's expressive UI capabilities and Firebase's real-time database for seamless communication.

## Features

- **Real-time Messaging:** Utilize Firebase's real-time database to enable instant messaging between users.

- **Authentication:** Implement Firebase Authentication for secure user registration and login.

- **User Profiles:** Allow users to create and customize their profiles with profile pictures and status updates.

- **Media Sharing:** Enable users to share text messages, images, videos, and other media files seamlessly.

## Firebase


  <img src="https://miro.medium.com/v2/resize:fit:600/format:webp/1*R4c8lHBHuH5qyqOtZb3h-w.png" alt="Firebase Logo">


## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/WhatsApp-clone-Flutter.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd whatsapp-clone
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Configure Firebase:**
   - Create a new project on the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android/iOS app to your Firebase project.
   - Connect with flutter option

5. **Run the Application:**
   ```bash
   flutter run
   ```

## Configuration

In the `lib/config` directory, you'll find a `firebase_config.dart` file. Update the Firebase configuration with your own credentials.

```dart
class FirebaseConfig {
  static const String apiKey = 'YOUR_API_KEY';
  static const String authDomain = 'YOUR_AUTH_DOMAIN';
  static const String projectId = 'YOUR_PROJECT_ID';
  static const String storageBucket = 'YOUR_STORAGE_BUCKET';
  static const String messagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String appId = 'YOUR_APP_ID';
}
```

## Screenshots


## Contributing

If you'd like to contribute to this project, please follow the [Contributing Guidelines](CONTRIBUTING.md).

