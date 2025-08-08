/**
 * signup_screen.dart
 * 
 * User registration screen for new account creation
 * 
 * Provides registration interface with password confirmation and form validation.
 * Includes navigation back to login screen for existing users.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

/**
 * Signup screen widget for new user registration
 * 
 * Provides a clean, user-friendly interface for new users to create accounts
 * in the Findr application. Handles form state, validation, and registration
 * flow with proper error handling and loading states.
 * 
 * Registration Flow:
 * - Form validation (email, password, password confirmation)
 * - Password matching validation
 * - Firebase account creation
 * - Automatic navigation to HomeScreen on success via AuthWrapper
 * - Error display and retry capability on failure
 */
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

/**
 * State class for the signup screen
 * 
 * Manages the registration form state including:
 * - Email, password, and confirm password input controllers
 * - Form validation state
 * - Loading state during registration
 * - Error message display
 * - Authentication service integration
 * 
 * State Variables:
 * - emailController: TextEditingController for email input
 * - passwordController: TextEditingController for password input
 * - confirmPasswordController: TextEditingController for password confirmation
 * - formKey: GlobalKey<FormState> for form validation
 * - _authService: AuthService instance for authentication
 * - errorMessage: String? for displaying registration errors
 * - isLoading: bool for showing loading state during registration
 */
class _SignupScreenState extends State<SignupScreen> {
  // Form input controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form validation key
  final formKey = GlobalKey<FormState>();

  // Authentication service instance
  final AuthService _authService = AuthService();

  // UI state variables
  String? errorMessage; // Error message to display
  bool isLoading = false; // Loading state during registration

  /**
   * Handle user registration
   * 
   * Input: None (uses form controllers)
   * Processing: 
   * - Validate form inputs
   * - Check password confirmation match
   * - Set loading state to true
   * - Clear any previous error messages
   * - Attempt account creation with Firebase
   * - Handle success (navigation handled by AuthWrapper)
   * - Handle errors with user-friendly messages
   * - Reset loading state
   * Output: void (none)
   */
  void signUp() async {
    // Validate form before attempting registration
    if (formKey.currentState!.validate()) {
      // Check if passwords match
      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          errorMessage = 'Passwords do not match';
        });
        return;
      }

      setState(() {
        isLoading = true; // Show loading indicator
        errorMessage = null; // Clear previous errors
      });

      try {
        // Attempt to create new user account
        await _authService.signUpWithEmailAndPassword(
          emailController.text.trim(), // Remove whitespace from email
          passwordController.text.trim(), // Remove whitespace from password
        );
        // Navigation is now handled by AuthWrapper in main.dart
        // Successful registration will automatically navigate to HomeScreen
      } catch (e) {
        // Handle registration errors
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
   * Build the signup screen UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create scaffold with app bar
   * - Build form with email, password, and confirm password fields
   * - Add validation and error handling
   * - Include loading states and navigation
   * Output: Widget - Complete signup screen interface
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
                  'Sign Up',
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
                          helperText: 'Format: name@example.com',
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
                        enabled: !isLoading, // Disable during registration
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
                        enabled: !isLoading, // Disable during registration
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Confirm password input field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm Password',
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
                        controller: confirmPasswordController,
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
                                    ? 'Confirm password'
                                    : null, // Form validation
                        enabled: !isLoading, // Disable during registration
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Registration submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : signUp, // Disable during loading
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

                // Navigation back to login screen
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () => Navigator.pop(context), // Go back to login
                  child: Text(
                    'Already have an account? Login',
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
