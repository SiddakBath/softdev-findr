/**
 * firestore_service.dart
 * 
 * Firestore database service for report management
 * 
 * Handles CRUD operations for reports with real-time streaming and filtering.
 * Provides data conversion between Report objects and Firestore documents.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 * Version: v1
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
   * Input: String? typeFilter
   * Processing: 
   * - Query Firestore collection
   * - Apply type filter if provided
   * - Convert Firestore documents to Report objects
   * - Return as stream for real-time updates
   * Output: Stream<List<Report>> - Real-time stream of report lists
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
   * Input: Report report
   * Processing: 
   * - Create new document in reports collection
   * - Use report ID as document ID
   * - Convert Report object to Map format
   * Output: Future<void> - Completes when report is successfully added
   */
  Future<void> addReport(Report report) {
    return _db.collection(_collection).doc(report.id).set(report.toMap());
  }

  /**
   * Update an existing report in the database
   * 
   * Input: Report report
   * Processing: 
   * - Update report document with new data
   * - Convert Report object to Map format
   * - Update entire document
   * Output: Future<void> - Completes when report is successfully updated
   */
  Future<void> updateReport(Report report) {
    return _db.collection(_collection).doc(report.id).update(report.toMap());
  }

  /**
   * Delete a report from the database
   * 
   * Input: String id
   * Processing: Permanently remove report document from Firestore collection
   * Output: Future<void> - Completes when report is successfully deleted
   */
  Future<void> deleteReport(String id) {
    return _db.collection(_collection).doc(id).delete();
  }

  /**
   * Mark a report as resolved
   * 
   * Input: String id
   * Processing: Update resolved status of report to true
   * Output: Future<void> - Completes when report is successfully updated
   */
  Future<void> markResolved(String id) {
    return _db.collection(_collection).doc(id).update({'resolved': true});
  }
}
