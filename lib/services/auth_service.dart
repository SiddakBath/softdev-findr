/**
 * auth_service.dart
 * 
 * Firebase Authentication service for user management
 * 
 * Handles user registration, login, logout, and authentication state monitoring.
 * Provides user-friendly error messages for common authentication scenarios.
 * 
 * Author: [Your Name]
 * Created: [Date]
 * Last Modified: [Date]
 */

import 'package:firebase_auth/firebase_auth.dart';

/**
 * Authentication service for managing user authentication
 * 
 * Provides methods for user registration, login, logout, and authentication
 * state monitoring. Uses Firebase Auth as the underlying authentication provider.
 * 
 * Key Features:
 * - User registration with email/password
 * - User login with email/password
 * - User logout
 * - Real-time authentication state monitoring
 * - Comprehensive error handling with user-friendly messages
 */
class AuthService {
  // Firebase Auth instance for authentication operations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /**
   * Get the currently authenticated user
   * 
   * Returns the current user if authenticated, null otherwise.
   * 
   * Returns: User? - Current Firebase user or null if not authenticated
   */
  User? get currentUser => _auth.currentUser;

  /**
   * Stream of authentication state changes
   * 
   * Provides real-time updates when user authentication state changes
   * (login, logout, token refresh, etc.)
   * 
   * Returns: Stream<User?> - Stream of user authentication state changes
   */
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /**
   * Register a new user with email and password
   * 
   * Creates a new user account in Firebase Auth. Throws a custom exception
   * with user-friendly error message if registration fails.
   * 
   * Parameters:
   * - email: String - User's email address
   * - password: String - User's password (minimum 6 characters)
   * 
   * Returns: Future<UserCredential> - Firebase user credential on success
   * 
   * Throws: String - User-friendly error message on failure
   * 
   * Common Error Scenarios:
   * - Weak password (less than 6 characters)
   * - Email already in use
   * - Invalid email format
   * - Network connectivity issues
   */
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Attempt to create new user account
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Convert Firebase exception to user-friendly message
      throw _handleAuthException(e);
    }
  }

  /**
   * Sign in existing user with email and password
   * 
   * Authenticates a user with their email and password. Throws a custom
   * exception with user-friendly error message if login fails.
   * 
   * Parameters:
   * - email: String - User's email address
   * - password: String - User's password
   * 
   * Returns: Future<UserCredential> - Firebase user credential on success
   * 
   * Throws: String - User-friendly error message on failure
   * 
   * Common Error Scenarios:
   * - User not found (email doesn't exist)
   * - Wrong password
   * - Invalid email format
   * - User account disabled
   * - Too many failed attempts
   */
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Attempt to sign in with provided credentials
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Convert Firebase exception to user-friendly message
      throw _handleAuthException(e);
    }
  }

  /**
   * Sign out the current user
   * 
   * Logs out the currently authenticated user and clears their session.
   * This method is safe to call even if no user is currently signed in.
   * 
   * Returns: Future<void> - Completes when sign out is successful
   */
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /**
   * Handle Firebase Auth exceptions and convert to user-friendly messages
   * 
   * Maps Firebase Auth error codes to human-readable error messages
   * that can be displayed to users in the UI.
   * 
   * Parameters:
   * - e: FirebaseAuthException - The Firebase exception to handle
   * 
   * Returns: String - User-friendly error message
   * 
   * Error Code Mapping:
   * - weak-password: Password too weak
   * - email-already-in-use: Account already exists
   * - user-not-found: No account for email
   * - wrong-password: Incorrect password
   * - invalid-email: Malformed email address
   * - user-disabled: Account disabled
   * - too-many-requests: Rate limiting
   * - operation-not-allowed: Auth method disabled
   */
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
