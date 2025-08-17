/**
 * auth_service.dart
 * 
 * Firebase Authentication service for user management
 * 
 * Handles user registration, login, logout, and authentication state monitoring.
 * Provides user-friendly error messages for common authentication scenarios.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 * Version: v1.7
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
   * Input: None
   * Processing: Retrieve current user from Firebase Auth
   * Output: User? - Current Firebase user or null if not authenticated
   */
  User? get currentUser => _auth.currentUser;

  /**
   * Stream of authentication state changes
   * 
   * Input: None
   * Processing: Get stream of authentication state changes from Firebase
   * Output: Stream<User?> - Stream of user authentication state changes
   */
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /**
   * Register a new user with email and password
   * 
   * Input: String email, String password
   * Processing: 
   * - Create new user account in Firebase Auth
   * - Handle authentication exceptions
   * - Convert Firebase errors to user-friendly messages
   * Output: Future<UserCredential> - Firebase user credential on success
   * Throws: String - User-friendly error message on failure
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
   * Input: String email, String password
   * Processing: 
   * - Authenticate user with provided credentials
   * - Handle authentication exceptions
   * - Convert Firebase errors to user-friendly messages
   * Output: Future<UserCredential> - Firebase user credential on success
   * Throws: String - User-friendly error message on failure
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
   * Input: None
   * Processing: Sign out currently authenticated user and clear session
   * Output: Future<void> - Completes when sign out is successful
   */
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /**
   * Handle Firebase Auth exceptions and convert to user-friendly messages
   * 
   * Input: FirebaseAuthException e
   * Processing: Map Firebase error codes to human-readable error messages
   * Output: String - User-friendly error message
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
