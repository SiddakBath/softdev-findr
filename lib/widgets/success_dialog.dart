/**
 * success_dialog.dart
 * 
 * Success dialog widget for user feedback
 * 
 * Provides reusable success dialog with customizable text and styling.
 * Includes helper function for easy dialog display.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 * Version: v1
 */

import 'package:flutter/material.dart';

/**
 * Success dialog widget for user feedback
 * 
 * Creates a modal dialog that displays success messages to users after
 * completing actions like creating, updating, or deleting reports.
 * 
 * Dialog Features:
 * - Modal presentation with backdrop
 * - Customizable content and styling
 * - Single OK button for dismissal
 * - Callback support for dismiss action
 * - Consistent visual design with app theme
 * - Positive visual feedback with purple theme
 */
class SuccessDialog extends StatelessWidget {
  // Dialog content
  final String title; // Dialog title (default: 'Success!')
  final String message; // Dialog message/description
  final VoidCallback? onDismiss; // Optional callback when dialog is dismissed

  /**
   * Constructor for SuccessDialog widget
   * 
   * Input: Key? key, String title, message, VoidCallback? onDismiss
   * Processing: Initialize SuccessDialog with dialog content and dismiss callback
   * Output: SuccessDialog instance
   */
  const SuccessDialog({
    Key? key,
    this.title = 'Success!',
    this.message = 'Action completed successfully.',
    this.onDismiss,
  }) : super(key: key);

  /**
   * Build the success dialog UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create modal dialog with custom styling
   * - Display title and message
   * - Add OK button for dismissal
   * - Handle button interaction with callback
   * Output: Widget - Complete success dialog interface
   */
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors.transparent, // Transparent background for custom styling
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.purple[50], // Light purple background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.purple[400]!, // Thick purple border
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size to content
          children: [
            // Dialog title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Dialog message
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // OK button for dismissal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onDismiss?.call(); // Execute dismiss callback if provided
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400], // Purple background
                  foregroundColor: Colors.white, // White text
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * Helper function to show success dialog
 * 
 * Input: BuildContext context, String title, message, VoidCallback? onDismiss
 * Processing: 
 * - Create and display success dialog
 * - Handle dialog dismissal
 * - Execute optional dismiss callback
 * Output: void - No return value, dialog is displayed modally
 */
void showSuccessDialog(
  BuildContext context, {
  String title = 'Success!',
  String message = 'Action completed successfully.',
  VoidCallback? onDismiss,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return SuccessDialog(
        title: title,
        message: message,
        onDismiss: onDismiss,
      );
    },
  );
}
