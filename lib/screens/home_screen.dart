/**
 * home_screen.dart
 * 
 * Main dashboard screen for the Findr application
 * 
 * Displays grid of lost and found reports with filtering and search capabilities.
 * Provides report management actions and navigation to other screens.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 * Version: v1.7
 * Recent Maintenance: Implemented real-time search functionality with debounced text input and enhanced filtering options to improve the user experience when browsing through large numbers of reports.
 */

import 'package:flutter/material.dart';
import 'report_form_screen.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/report_card.dart';
import '../widgets/success_dialog.dart';
import '../widgets/confirmation_dialog.dart';
import '../models/report.dart';
import 'package:findr/screens/report_detail_screen.dart';

/**
 * Home screen widget displaying the main dashboard
 * 
 * Provides the primary interface for users to browse and manage lost and found
 * reports. Includes filtering, search, and report management capabilities.
 * 
 * State Management:
 * - Uses StatefulWidget for local state management
 * - Manages filter selection, search text, and UI state
 * - Integrates with FirestoreService for real-time data
 */
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/**
 * State class for the home screen
 * 
 * Manages the UI state including:
 * - Current filter selection (lost/found)
 * - Search text input
 * - Sort selection (latest/oldest)
 * - Service instances for data operations
 * 
 * Data Flow:
 * 1. StreamBuilder listens to Firestore reports stream
 * 2. Reports are filtered by type and search query
 * 3. Reports are sorted by selected criteria
 * 4. Filtered and sorted reports displayed in grid layout
 * 5. User interactions trigger appropriate service calls
 */
class _HomeScreenState extends State<HomeScreen> {
  // Service instances for data operations
  final firestore = FirestoreService();
  final authService = AuthService();

  // UI state variables
  String? filter; // Current filter for Firestore query
  String selectedType = 'lost'; // Default type filter ('lost' or 'found')
  String selectedSort = 'latest'; // Default sort option ('latest' or 'oldest')
  final TextEditingController _searchController =
      TextEditingController(); // Search input controller

  /**
   * Build the home screen UI
   * 
   * Input: BuildContext context
   * Processing: 
   * - Create scaffold with app bar and logout button
   * - Build search and filter section
   * - Display reports grid with real-time data
   * - Handle user interactions and navigation
   * Output: Widget - Complete home screen interface
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Findr',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // Logout button in app bar
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () async {
              await authService.signOut(); // Sign out current user
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Toggle Switch for Lost/Found Filter
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleOption('lost', 'Lost'),
                      _buildToggleOption('found', 'Found'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar and Sort Dropdown Row
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple[200]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              // Trigger rebuild when search text changes
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort Dropdown Button
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.sort, color: Colors.grey),
                        onSelected: (String value) {
                          setState(() {
                            selectedSort = value;
                          });
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'latest',
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_downward, size: 16),
                                    SizedBox(width: 8),
                                    Text('Latest'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'oldest',
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_upward, size: 16),
                                    SizedBox(width: 8),
                                    Text('Oldest'),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reports Grid Section
          Expanded(
            child: StreamBuilder<List<Report>>(
              // Listen to real-time reports stream with current filter
              stream: firestore.getReports(filter),
              builder: (context, snapshot) {
                // Show loading indicator while data is being fetched
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data!;

                // Apply client-side filtering for search and type selection using custom linear search
                final filteredReports = <Report>[];
                for (final report in reports) {
                  // Filter by selected type (lost/found)
                  if (selectedType != report.type) continue;

                  // Filter by search query if text is entered - search only titles
                  if (_searchController.text.isNotEmpty) {
                    final query = _searchController.text.toLowerCase();
                    final title = report.title.toLowerCase();

                    if (!title.contains(query)) continue;
                  }

                  filteredReports.add(report);
                }

                // Apply custom selection sort based on selected sort option
                final sortedReports = _selectionSort(
                  filteredReports,
                  selectedSort,
                );

                // Display reports in a responsive grid layout
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns for responsive layout
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7, // Card aspect ratio - made taller
                  ),
                  itemCount: sortedReports.length,
                  itemBuilder: (context, index) {
                    return ReportCard(
                      report: sortedReports[index],
                      // Navigate to report detail screen on tap
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ReportDetailScreen(
                                    report: sortedReports[index],
                                  ),
                            ),
                          ),
                      // Navigate to edit screen for report modification
                      onEdit:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ReportFormScreen(
                                    report: sortedReports[index],
                                  ),
                            ),
                          ),
                      // Handle report deletion with confirmation
                      onDelete: () async {
                        final shouldDelete = await showConfirmationDialog(
                          context,
                          title: 'Delete Report',
                          message:
                              'Are you sure you want to delete this report? This action cannot be undone.',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                        );

                        if (shouldDelete == true) {
                          // Delete report from database
                          await firestore.deleteReport(sortedReports[index].id);
                          // Show success message
                          showSuccessDialog(
                            context,
                            title: 'Success!',
                            message: 'Report deleted successfully!',
                          );
                        }
                      },
                      // Handle report resolution with confirmation
                      onResolve: () async {
                        final shouldResolve = await showConfirmationDialog(
                          context,
                          title: 'Mark as Resolved',
                          message:
                              'Are you sure you want to mark this report as resolved?',
                          confirmText: 'Resolve',
                          cancelText: 'Cancel',
                        );

                        if (shouldResolve == true) {
                          // Mark report as resolved in database
                          await firestore.markResolved(sortedReports[index].id);
                          // Show success message
                          showSuccessDialog(
                            context,
                            title: 'Success!',
                            message: 'Report marked as resolved!',
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button for creating new reports
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.purple[100],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.purple[300]!, width: 2),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Navigate to report creation screen
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportFormScreen()),
              ),
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /**
   * Build toggle option for lost/found filter
   * 
   * Input: String value, String label
   * Processing: 
   * - Create selectable button for filtering reports by type
   * - Handle visual feedback for selected state
   * - Update state on user interaction
   * Output: Widget - A clickable toggle button
   */
  Widget _buildToggleOption(String value, String label) {
    final isSelected = selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => selectedType = value), // Update state on tap
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[400] : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /**
   * Custom selection sort algorithm implementation
   * 
   * Purpose: sorts a list of reports by lost/found time
   * Input: List<Report> arrElements, String sortType
   * Output: List<Report> - a sorted array of reports
   */
  List<Report> _selectionSort(List<Report> arrElements, String sortType) {
    final n = arrElements.length;

    for (int i = 0; i < n; i++) {
      // select the smallest item
      int smallest = i;

      // compare smallest to the rest of the array
      for (int j = i + 1; j < n; j++) {
        bool shouldSwap = false;

        if (sortType == 'latest') {
          // Sort by timeFoundLost descending (latest first)
          shouldSwap = arrElements[j].timeFoundLost.isAfter(
            arrElements[smallest].timeFoundLost,
          );
        } else {
          // Sort by timeFoundLost ascending (oldest first)
          shouldSwap = arrElements[j].timeFoundLost.isBefore(
            arrElements[smallest].timeFoundLost,
          );
        }

        if (shouldSwap) {
          // update the index value of smallest
          smallest = j;
        }
      }

      // the smallest item in the array has been found
      // so swap it with the current element
      if (smallest != i) {
        // swap arrElements[smallest] AND arrElements[i]
        final temp = arrElements[smallest];
        arrElements[smallest] = arrElements[i];
        arrElements[i] = temp;
      }
    }

    return arrElements;
  }

  /**
   * Custom linear search algorithm implementation
   * 
   * Purpose: searches through a list of elements for a specific query
   * Input: List<String> searchList, String searchItem
   * Output: bool - True if item found, False if not
   */
  bool _linearSearch(List<String> searchList, String searchItem) {
    bool found = false;

    for (String eachItem in searchList) {
      if (eachItem.contains(searchItem)) {
        found = true;
        break; // exit loop once found
      }
    }

    return found;
  }
}
