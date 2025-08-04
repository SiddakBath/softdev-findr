/**
 * success_dialog.dart
 * 
 * Success dialog widget for user feedback
 * 
 * Provides reusable success dialog with customizable text and styling.
 * Includes helper function for easy dialog display.
 * 
 * Author: [Your Name]
 * Created: [Date]
 * Last Modified: [Date]
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
   * Parameters:
   * - key: Key? - Widget key for identification
   * - title: String - Dialog title (default: 'Success!')
   * - message: String - Dialog message (default: 'Action completed successfully.')
   * - onDismiss: VoidCallback? - Optional callback for dismiss action
   */
  const SuccessDialog({
    Key? key,
    this.title = 'Success!',
    this.message = 'Action completed successfully.',
    this.onDismiss,
  }) : super(key: key);

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
 * Convenience function that creates and displays a success dialog
 * with the specified parameters. The dialog is non-dismissible to
 * ensure users acknowledge the success message.
 * 
 * Parameters:
 * - context: BuildContext - The build context for showing the dialog
 * - title: String - Dialog title (default: 'Success!')
 * - message: String - Dialog message (default: 'Action completed successfully.')
 * - onDismiss: VoidCallback? - Optional callback for dismiss action
 * 
 * Returns: void - No return value, dialog is displayed modally
 * 
 * Usage Example:
 * ```dart
 * showSuccessDialog(
 *   context,
 *   title: 'Success!',
 *   message: 'Report created successfully!',
 *   onDismiss: () {
 *     // Handle dismiss callback
 *   },
 * );
 * ```
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
