/**
 * report_detail_screen.dart
 * 
 * Detailed view screen for lost and found reports
 * 
 * Displays complete report information in organized sections.
 * Provides owner-specific actions for editing and deleting reports.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

import 'package:findr/models/report.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../widgets/success_dialog.dart';
import '../widgets/confirmation_dialog.dart';
import 'report_form_screen.dart';

/**
 * Report detail screen for viewing complete report information
 * 
 * Displays all information about a lost or found item in an organized,
 * visually appealing format. Provides owner-specific actions for
 * report management and contact options for resolution.
 * 
 * Screen Layout:
 * - App bar with title and owner actions
 * - Scrollable content with organized sections
 * - Image section with color-coded background
 * - Action button for contact/resolution
 * - Information sections for all report data
 * 
 * Owner Features:
 * - Edit report button
 * - Delete report button with confirmation
 * - Direct access to report modification
 */
class ReportDetailScreen extends StatelessWidget {
  final Report report; // Report data to display
  final FirestoreService _firestoreService =
      FirestoreService(); // Database service

  ReportDetailScreen({super.key, required this.report});

  /**
   * Check if current user is the owner of this report
   * 
   * Input: None (uses Firebase Auth and report data)
   * Processing: Compare current user's email with report's reporter email
   * Output: bool - True if current user is the report owner
   */
  bool get isOwner {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.email == report.reporterEmail;
  }

  /**
   * Build the report detail screen UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create scaffold with app bar and owner actions
   * - Build scrollable content with organized sections
   * - Display report information in structured layout
   * - Handle user interactions and navigation
   * Output: Widget - Complete report detail screen interface
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(), // Navigate back
        ),
        title: Text(
          report.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions:
            isOwner
                ? [
                  // Delete button (owner only)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await showConfirmationDialog(
                        context,
                        title: 'Delete Report',
                        message:
                            'Are you sure you want to delete this report? This action cannot be undone.',
                        confirmText: 'Delete',
                        cancelText: 'Cancel',
                      );

                      if (shouldDelete == true) {
                        await _firestoreService.deleteReport(report.id);
                        showSuccessDialog(
                          context,
                          title: 'Success!',
                          message: 'Report deleted successfully!',
                          onDismiss: () => Navigator.of(context).pop(),
                        );
                      }
                    },
                  ),
                  // Edit button (owner only)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportFormScreen(report: report),
                        ),
                      );
                    },
                  ),
                ]
                : null,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 24),
          _buildItemImage(), // Display item image or placeholder
          const SizedBox(height: 24),
          _buildActionButton(), // Contact or resolve action
          const SizedBox(height: 32),
          _buildDescriptionSection(), // Item description
          const SizedBox(height: 32),
          _buildDateTimeSection(), // When item was lost/found
          const SizedBox(height: 32),
          _buildTagsSection(), // Searchable tags
          const SizedBox(height: 32),
          _buildColorSection(), // Visual color representation
          const SizedBox(height: 32),
          _buildLocationSection(), // Where item was lost/found
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /**
   * Build item image section
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Display report image if available
   * - Show placeholder if no image
   * - Handle image loading errors
   * Output: Widget - Image section with background color
   */
  Widget _buildItemImage() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          image:
              report.imageUrl != null && report.imageUrl!.isNotEmpty
                  ? DecorationImage(
                    image: NetworkImage(report.imageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            report.imageUrl == null || report.imageUrl!.isEmpty
                ? const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 60,
                  ),
                )
                : null,
      ),
    );
  }

  /**
   * Build action button (contact or resolve)
   * 
   * Input: None (uses report data and owner status)
   * Processing: 
   * - Show resolve button for owner
   * - Show contact button for non-owner
   * - Handle button interactions with confirmation dialogs
   * Output: Widget - Action button with appropriate text and behavior
   */
  Widget _buildActionButton() {
    return Builder(
      builder:
          (context) => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (isOwner) {
                  if (report.resolved) {
                    // Report is already resolved - show info dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Report Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          content: const Text(
                            'This report has already been marked as resolved.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Resolve action for owner
                    final shouldResolve = await showConfirmationDialog(
                      context,
                      title: 'Mark as Resolved',
                      message:
                          'Are you sure you want to mark this report as resolved?',
                      confirmText: 'Resolve',
                      cancelText: 'Cancel',
                    );

                    if (shouldResolve == true) {
                      await _firestoreService.markResolved(report.id);
                      showSuccessDialog(
                        context,
                        title: 'Success!',
                        message: 'Report marked as resolved!',
                      );
                    }
                  }
                } else {
                  // Show reporter's email for non-owner
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reporter\'s Email:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Text(
                                report.reporterEmail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'You can contact the reporter directly using this email address.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.purple[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isOwner && report.resolved
                        ? Colors.green
                        : Colors.purple[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isOwner
                    ? (report.resolved ? 'Resolved' : 'Resolve')
                    : 'Show Contact',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
    );
  }

  /**
   * Build description section
   * 
   * Input: None (uses report data)
   * Processing: Create styled container with report description
   * Output: Widget - Description section with formatted text
   */
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            report.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /**
   * Build date and time section
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Format date and time using DateFormat
   * - Create row with two columns for date and time
   * Output: Widget - Date and time section with formatted display
   */
  Widget _buildDateTimeSection() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dateFormat.format(report.timeFoundLost),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeFormat.format(report.timeFoundLost),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   * Build tags section
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Create wrap layout for tags
   * - Style each tag with background color and border radius
   * Output: Widget - Tags section with styled tag chips
   */
  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              report.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  /**
   * Build color section
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Parse color text to Color object
   * - Create visual color representation
   * - Display color name and visual indicator
   * Output: Widget - Color section with visual color display
   */
  Widget _buildColorSection() {
    // Convert hex string to Color object
    Color colorFromHex(String hexString) {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write('ff'); // Add opacity
        buffer.write(hexString.replaceFirst('#', ''));
        return Color(int.parse(buffer.toString(), radix: 16));
      }
      return Colors.grey; // Default color if hex is invalid
    }

    final color = colorFromHex(report.colour);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Colour',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  report.colour,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /**
   * Build location section
   * 
   * Input: None (uses report data)
   * Processing: Create styled container with location information
   * Output: Widget - Location section with formatted text
   */
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            report.location,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
