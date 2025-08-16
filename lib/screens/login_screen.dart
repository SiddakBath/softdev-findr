/**
 * login_screen.dart
 * 
 * User authentication login screen
 * 
 * Provides login interface with form validation and error handling.
 * Includes navigation to signup screen for new users.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

/**
 * Login screen widget for user authentication
 * 
 * Provides a clean, user-friendly interface for existing users to log in
 * to the Findr application. Handles form state, validation, and authentication
 * flow with proper error handling and loading states.
 * 
 * Navigation Flow:
 * - Successful login: Automatically navigates to HomeScreen via AuthWrapper
 * - Failed login: Displays error message and allows retry
 * - Sign up link: Navigates to SignupScreen for new user registration
 */
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/**
 * State class for the login screen
 * 
 * Manages the login form state including:
 * - Email and password input controllers
 * - Form validation state
 * - Loading state during authentication
 * - Error message display
 * - Authentication service integration
 * 
 * State Variables:
 * - emailController: TextEditingController for email input
 * - passwordController: TextEditingController for password input
 * - formKey: GlobalKey<FormState> for form validation
 * - _authService: AuthService instance for authentication
 * - errorMessage: String? for displaying authentication errors
 * - isLoading: bool for showing loading state during authentication
 */
class _LoginScreenState extends State<LoginScreen> {
  // Form input controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form validation key
  final formKey = GlobalKey<FormState>();

  // Authentication service instance
  final AuthService _authService = AuthService();

  // UI state variables
  String? errorMessage; // Error message to display
  bool isLoading = false; // Loading state during authentication

  /**
   * Handle user login authentication
   * 
   * Input: None (uses form controllers)
   * Processing: 
   * - Validate form inputs
   * - Set loading state to true
   * - Clear any previous error messages
   * - Attempt authentication with Firebase
   * - Handle success (navigation handled by AuthWrapper)
   * - Handle errors with user-friendly messages
   * - Reset loading state
   * Output: void (none)
   */
  void login() async {
    // Validate form before attempting authentication
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show loading indicator
        errorMessage = null; // Clear previous errors
      });

      try {
        // Attempt authentication with provided credentials
        await _authService.signInWithEmailAndPassword(
          emailController.text.trim(), // Remove whitespace from email
          passwordController.text.trim(), // Remove whitespace from password
        );
        // Navigation is now handled by AuthWrapper in main.dart
        // Successful login will automatically navigate to HomeScreen
      } catch (e) {
        // Handle authentication errors
        if (mounted) {
          setState(() {
            errorMessage = e.toString(); // Display error message
          });
        }
      } finally {
        // Reset loading state regardless of success/failure
        if (mounted) {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  /**
   * Build the login screen UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create scaffold with app bar
   * - Build form with email and password fields
   * - Add validation and error handling
   * - Include loading states and navigation
   * Output: Widget - Complete login screen interface
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple[400]!, width: 3),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Application title
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error message display
                if (errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50], // Light red background
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email input field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'example@example.com',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter email';
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(v))
                            return 'Enter a valid email address';
                          return null;
                        },
                        enabled: !isLoading, // Disable during authentication
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Password input field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: '••••••••',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        obscureText: true, // Hide password characters
                        validator:
                            (v) =>
                                v!.isEmpty
                                    ? 'Enter password'
                                    : null, // Form validation
                        enabled: !isLoading, // Disable during authentication
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : login, // Disable during loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),

                // Navigation to signup screen
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          ),
                  child: Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: Colors.purple[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
