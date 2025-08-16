/**
 * report_card.dart
 * 
 * Report card widget for displaying lost and found items
 * 
 * Creates visual card representation of reports with image display,
 * color coding, and owner-specific action menu.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report.dart';

/**
 * Report card widget for displaying lost and found items
 * 
 * Creates a card-based UI component that displays report information in a
 * visually appealing format. Supports user interactions and owner-specific
 * actions through a context menu.
 * 
 * Widget Structure:
 * - Image section (top 60% of card)
 * - Content section (bottom 40% of card)
 * - Action menu (owner-only, top-right corner)
 * 
 * Interaction Features:
 * - Tap to view report details
 * - Owner menu for edit/delete/resolve actions
 * - Visual feedback for user interactions
 */
class ReportCard extends StatelessWidget {
  // Report data to display
  final Report report;

  // Callback functions for user interactions
  final VoidCallback? onTap; // Navigate to detail view
  final VoidCallback? onDelete; // Delete report
  final VoidCallback? onEdit; // Edit report
  final VoidCallback? onResolve; // Mark as resolved

  /**
   * Constructor for ReportCard widget
   * 
   * Input: Report report, VoidCallback? onTap, onDelete, onEdit, onResolve
   * Processing: Initialize ReportCard with report data and callback functions
   * Output: ReportCard instance
   */
  ReportCard({
    required this.report,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onResolve,
  });

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
   * Build the report card UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create card container with image and content sections
   * - Display report image or placeholder
   * - Show owner action menu if applicable
   * - Build content section with title, description, and tags
   * Output: Widget - Complete report card interface
   */
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap to navigate to detail view
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section (top 60% of card)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getImageColor(), // Background color for image area
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    // Display report image or placeholder
                    report.imageUrl != null
                        ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            report.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder(); // Fallback on error
                            },
                          ),
                        )
                        : _buildImagePlaceholder(), // Show placeholder if no image

                    // Owner action menu (three dots) - only visible to report owner
                    if (isOwner &&
                        (onEdit != null ||
                            onDelete != null ||
                            onResolve != null))
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.8,
                            ), // Semi-transparent background
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            onSelected: (value) {
                              // Handle menu item selection
                              switch (value) {
                                case 'edit':
                                  onEdit?.call();
                                  break;
                                case 'delete':
                                  onDelete?.call();
                                  break;
                                case 'resolve':
                                  onResolve?.call();
                                  break;
                              }
                            },
                            itemBuilder:
                                (context) => [
                                  // Resolve option (only if not already resolved)
                                  if (onResolve != null && !report.resolved)
                                    PopupMenuItem(
                                      value: 'resolve',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Mark as resolved'),
                                        ],
                                      ),
                                    ),
                                  // Edit option
                                  if (onEdit != null)
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                  // Delete option (with red styling)
                                  if (onDelete != null)
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Content section (bottom 40% of card)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Report title with resolved indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1, // Limit to single line
                            overflow:
                                TextOverflow
                                    .ellipsis, // Show ellipsis if truncated
                          ),
                        ),
                        // Resolved indicator
                        if (report.resolved)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'RESOLVED',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Report description
                    Text(
                      report.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3, // Line height for better readability
                      ),
                      maxLines: 2, // Limit to two lines
                      overflow:
                          TextOverflow.ellipsis, // Show ellipsis if truncated
                    ),

                    const Spacer(), // Push tags to bottom
                    // Tags display (limited to first 3 tags)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children:
                          report.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[200], // Light grey background
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * Build placeholder widget when no image is available
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Create visual placeholder with icon
   * - Use same background color as image section
   * - Handle cases when image is not available or loading fails
   * Output: Widget - Placeholder container with image icon
   */
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: _getImageColor(), // Use same color as image background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Icon(
        Icons.image,
        color: Colors.white,
        size: 40,
      ), // Image placeholder icon
    );
  }

  /**
   * Get background color for image section based on report color
   * 
   * Input: None (uses report data)
   * Processing: 
   * - Parse hex color code from report's colour field
   * - Convert to Flutter Color object
   * - Use grey as fallback if parsing fails
   * Output: Color - Background color for the image section
   */
  Color _getImageColor() {
    // Parse hex color from the report's colour field
    if (report.colour.startsWith('#')) {
      try {
        final hexCode = report.colour.substring(1);
        if (hexCode.length == 6) {
          return Color(
            int.parse(hexCode, radix: 16) + 0xFF000000, // Add alpha channel
          );
        }
      } catch (e) {
        // Fall through to grey if parsing fails
      }
    }

    // Fallback: Use grey for invalid colors
    return Colors.grey[400]!;
  }
}
