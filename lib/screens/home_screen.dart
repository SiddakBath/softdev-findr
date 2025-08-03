import 'package:flutter/material.dart';
import 'report_form_screen.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/report_card.dart';
import '../widgets/success_dialog.dart';
import '../widgets/confirmation_dialog.dart';
import '../models/report.dart';
import 'package:findr/screens/report_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirestoreService();
  final authService = AuthService();
  String? filter;
  String selectedType = 'lost'; // 'lost' or 'found'
  final TextEditingController _searchController = TextEditingController();

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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () async {
              await authService.signOut();
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
                // Toggle Switch
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

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
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
              ],
            ),
          ),

          // Reports Grid
          Expanded(
            child: StreamBuilder<List<Report>>(
              stream: firestore.getReports(filter),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data!;
                final filteredReports =
                    reports.where((report) {
                      // Filter by type (lost/found)
                      if (selectedType != report.type) return false;

                      // Filter by search query
                      if (_searchController.text.isNotEmpty) {
                        final query = _searchController.text.toLowerCase();
                        return report.title.toLowerCase().contains(query) ||
                            report.description.toLowerCase().contains(query) ||
                            report.tags.any(
                              (tag) => tag.toLowerCase().contains(query),
                            );
                      }

                      return true;
                    }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    return ReportCard(
                      report: filteredReports[index],
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ReportDetailScreen(
                                    report: filteredReports[index],
                                  ),
                            ),
                          ),
                      onEdit:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ReportFormScreen(
                                    report: filteredReports[index],
                                  ),
                            ),
                          ),
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
                          await firestore.deleteReport(
                            filteredReports[index].id,
                          );
                          showSuccessDialog(
                            context,
                            title: 'Success!',
                            message: 'Report deleted successfully!',
                          );
                        }
                      },
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
                          await firestore.markResolved(
                            filteredReports[index].id,
                          );
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

  Widget _buildToggleOption(String value, String label) {
    final isSelected = selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => selectedType = value),
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
}
