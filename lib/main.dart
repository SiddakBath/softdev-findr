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
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

/**
 * Main application entry point
 * 
 * Input: None
 * Processing: 
 * - Initialize Flutter bindings
 * - Initialize Firebase with platform-specific options
 * - Start the Flutter application
 * Output: void (none)
 */
void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
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
