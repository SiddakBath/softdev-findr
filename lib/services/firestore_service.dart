/**
 * firestore_service.dart
 * 
 * Firestore database service for report management
 * 
 * Handles CRUD operations for reports with real-time streaming and filtering.
 * Provides data conversion between Report objects and Firestore documents.
 * 
 * Author: [Your Name]
 * Created: [Date]
 * Last Modified: [Date]
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

/**
 * Firestore database service for report operations
 * 
 * Provides methods for managing lost and found reports in the Firestore database.
 * Handles real-time data streaming, filtering, and status updates for reports.
 * 
 * Key Features:
 * - Real-time report streaming with optional type filtering
 * - Report creation, updating, and deletion
 * - Report status management (mark as resolved)
 * - Automatic data type conversion between Report objects and Firestore documents
 * 
 * Database Structure:
 * - Collection: 'reports'
 * - Document ID: Auto-generated or custom
 * - Fields: All Report model fields stored as Firestore-compatible types
 */
class FirestoreService {
  // Firestore database instance
  final _db = FirebaseFirestore.instance;

  // Collection name for reports
  final _collection = 'reports';

  /**
   * Get a stream of reports with optional type filtering
   * 
   * Returns a real-time stream of reports from Firestore. The stream automatically
   * updates when reports are added, modified, or deleted. Optional filtering by
   * report type ('lost' or 'found') can be applied.
   * 
   * Parameters:
   * - typeFilter: String? - Optional filter for report type ('lost' or 'found')
   * 
   * Returns: Stream<List<Report>> - Real-time stream of report lists
   * 
   * Usage Examples:
   * - getReports(null) - Get all reports
   * - getReports('lost') - Get only lost item reports
   * - getReports('found') - Get only found item reports
   * 
   * Data Flow:
   * 1. Query Firestore collection
   * 2. Apply type filter if provided
   * 3. Convert Firestore documents to Report objects
   * 4. Return as stream for real-time updates
   */
  Stream<List<Report>> getReports(String? typeFilter) {
    // Start with base query on reports collection
    Query query = _db.collection(_collection);

    // Apply type filter if specified
    if (typeFilter != null) query = query.where('type', isEqualTo: typeFilter);

    // Return stream that converts documents to Report objects
    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    Report.fromMap(doc.id, doc.data() as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  /**
   * Add a new report to the database
   * 
   * Creates a new document in the reports collection with the provided report data.
   * The report ID is used as the document ID for easy retrieval and updates.
   * 
   * Parameters:
   * - report: Report - The report object to add to the database
   * 
   * Returns: Future<void> - Completes when report is successfully added
   * 
   * Data Conversion:
   * - Report object converted to Map using toMap() method
   * - DateTime fields automatically serialized to ISO strings
   * - All other fields stored as-is in Firestore
   */
  Future<void> addReport(Report report) {
    return _db.collection(_collection).doc(report.id).set(report.toMap());
  }

  /**
   * Update an existing report in the database
   * 
   * Updates a report document with new data. Only the fields present in the
   * report object will be updated; other fields remain unchanged.
   * 
   * Parameters:
   * - report: Report - The updated report object
   * 
   * Returns: Future<void> - Completes when report is successfully updated
   * 
   * Note: This method updates the entire document. For partial updates,
   * consider using Firestore's update() method with specific field paths.
   */
  Future<void> updateReport(Report report) {
    return _db.collection(_collection).doc(report.id).update(report.toMap());
  }

  /**
   * Delete a report from the database
   * 
   * Permanently removes a report document from the Firestore collection.
   * This action cannot be undone.
   * 
   * Parameters:
   * - id: String - The ID of the report to delete
   * 
   * Returns: Future<void> - Completes when report is successfully deleted
   * 
   * Safety Considerations:
   * - Ensure user has permission to delete the report
   * - Consider implementing soft delete (mark as deleted) for data recovery
   */
  Future<void> deleteReport(String id) {
    return _db.collection(_collection).doc(id).delete();
  }

  /**
   * Mark a report as resolved
   * 
   * Updates the resolved status of a report to true, indicating that the
   * lost item has been found or the found item has been claimed.
   * 
   * Parameters:
   * - id: String - The ID of the report to mark as resolved
   * 
   * Returns: Future<void> - Completes when report is successfully updated
   * 
   * Business Logic:
   * - Resolved reports may be filtered out of search results
   * - Resolved reports can still be viewed for reference
   * - Consider adding resolution date and claimant information
   */
  Future<void> markResolved(String id) {
    return _db.collection(_collection).doc(id).update({'resolved': true});
  }
}
