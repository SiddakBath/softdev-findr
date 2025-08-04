/**
 * confirmation_dialog.dart
 * 
 * Confirmation dialog widget for user action verification
 * 
 * Provides reusable confirmation dialog with customizable text and styling.
 * Includes helper function for easy dialog display.
 * 
 * Author: [Your Name]
 * Created: [Date]
 * Last Modified: [Date]
 */

import 'package:flutter/material.dart';

/**
 * Confirmation dialog widget for user action verification
 * 
 * Creates a modal dialog that prompts users to confirm an action before
 * proceeding. Used for destructive actions like delete, resolve, or other
 * important operations that require user confirmation.
 * 
 * Dialog Features:
 * - Modal presentation with backdrop
 * - Customizable content and styling
 * - Two-button layout (confirm/cancel)
 * - Callback support for both actions
 * - Consistent visual design with app theme
 */
class ConfirmationDialog extends StatelessWidget {
  // Dialog content
  final String title; // Dialog title
  final String message; // Dialog message/description
  final String confirmText; // Text for confirm button
  final String cancelText; // Text for cancel button

  // Callback functions
  final VoidCallback? onConfirm; // Called when user confirms
  final VoidCallback? onCancel; // Called when user cancels

  /**
   * Constructor for ConfirmationDialog widget
   * 
   * Parameters:
   * - key: Key? - Widget key for identification
   * - title: String - Dialog title (default: 'Are you sure?')
   * - message: String - Dialog message (default: 'This action cannot be undone.')
   * - confirmText: String - Confirm button text (default: 'Yes')
   * - cancelText: String - Cancel button text (default: 'Cancel')
   * - onConfirm: VoidCallback? - Optional callback for confirm action
   * - onCancel: VoidCallback? - Optional callback for cancel action
   */
  const ConfirmationDialog({
    Key? key,
    this.title = 'Are you sure?',
    this.message = 'This action cannot be undone.',
    this.confirmText = 'Yes',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
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
                fontSize: 20,
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

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(true); // Return true for confirmation
                  onConfirm?.call(); // Execute confirm callback if provided
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[50], // Light purple background
                  foregroundColor: Colors.black, // Black text
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.purple[400]!,
                      width: 2,
                    ), // Purple border
                  ),
                  elevation: 0, // No shadow
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(false); // Return false for cancellation
                  onCancel?.call(); // Execute cancel callback if provided
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[50], // Light purple background
                  foregroundColor: Colors.black, // Black text
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.purple[400]!,
                      width: 2,
                    ), // Purple border
                  ),
                  elevation: 0, // No shadow
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
 * Helper function to show confirmation dialog
 * 
 * Convenience function that creates and displays a confirmation dialog
 * with the specified parameters. Returns a Future<bool?> that resolves
 * to true if confirmed, false if cancelled, or null if dismissed.
 * 
 * Parameters:
 * - context: BuildContext - The build context for showing the dialog
 * - title: String - Dialog title (default: 'Are you sure?')
 * - message: String - Dialog message (default: 'This action cannot be undone.')
 * - confirmText: String - Confirm button text (default: 'Yes')
 * - cancelText: String - Cancel button text (default: 'Cancel')
 * - onConfirm: VoidCallback? - Optional callback for confirm action
 * - onCancel: VoidCallback? - Optional callback for cancel action
 * 
 * Returns: Future<bool?> - Future that resolves to:
 * - true: User confirmed the action
 * - false: User cancelled the action
 * - null: Dialog was dismissed
 * 
 * Usage Example:
 * ```dart
 * final shouldDelete = await showConfirmationDialog(
 *   context,
 *   title: 'Delete Report',
 *   message: 'Are you sure you want to delete this report?',
 *   confirmText: 'Delete',
 *   cancelText: 'Cancel',
 * );
 * 
 * if (shouldDelete == true) {
 *   // Proceed with deletion
 * }
 * ```
 */
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  String title = 'Are you sure?',
  String message = 'This action cannot be undone.',
  String confirmText = 'Yes',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
  );
}
