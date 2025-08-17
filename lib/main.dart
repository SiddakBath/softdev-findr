/**
 * main.dart
 * 
 * Main entry point for the Findr Lost & Found application
 * 
 * Handles Firebase initialization and authentication routing.
 * Routes users to HomeScreen if authenticated, LoginScreen if not.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 * Version: v1.7
 * Recent Maintenance: Resolved authentication state management issues by implementing AuthWrapper, which now properly handles user session persistence and automatically navigates between authenticated and unauthenticated states.
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

/**
 * Data Sources:
 * - Firebase Authentication: Used for secure user sign-up, login, and session management, ensuring only authorized users can create or manage reports.
 * - Firebase Firestore: Chosen for its scalable, real-time NoSQL database capabilities, enabling efficient storage and live updates of lost and found reports.
 * - Firebase Storage: Utilised for storing and retrieving user-uploaded images associated with reports, supporting large file uploads and secure access.
 * 
 * Data Types:
 * - User: Represents authenticated individuals interacting with the app; essential for associating reports with specific users and managing permissions.
 * - Report: Custom model encapsulating all details of a lost or found item (e.g., description, status, image URL); central to the app’s core functionality.
 * - Image: Represents media files attached to reports, providing visual context and aiding in item identification.
 * 
 * Data Structures:
 * - List<Report>: Used to efficiently manage and display collections of reports (e.g., in lists or feeds), supporting dynamic updates and filtering.
 * - Map<String, dynamic>: Enables flexible serialisation/deserialisation of report data for Firestore storage, allowing for easy conversion between Dart objects and Firestore documents.
 */

/**
 * Main application entry point
 * 
 * Input: None
 * Processing: 
 * - Initialise Flutter bindings
 * - Initialise Firebase with platform-specific options
 * - Start the Flutter application
 * Output: void (none)
 */
void main() async {
  // Ensure Flutter bindings are initialised before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Start the application
  runApp(MyApp());
}

/**
 * Root application widget
 * 
 * Input: BuildContext context
 * Processing: Configure MaterialApp with theme settings and routing logic
 * Output: MaterialApp widget
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost & Found', // App title displayed in task manager
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ), // Purple theme for consistency
      debugShowCheckedModeBanner: false, // Hide debug banner in release builds
      home: AuthWrapper(), // Use AuthWrapper to handle authentication routing
    );
  }
}

/**
 * Authentication state wrapper
 * 
 * Input: BuildContext context
 * Processing: 
 * - Monitor Firebase authentication state changes
 * - Route users based on authentication status
 * Output: Widget - HomeScreen if authenticated, LoginScreen if not
 */
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to Firebase authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if user data exists and is not null (user is signed in)
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(); // Navigate to main app interface
        }
        // User is not signed in, show login screen
        return LoginScreen();
      },
    );
  }
}
