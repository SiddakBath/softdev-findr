/**
 * report.dart
 * 
 * Data model for lost and found item reports
 * 
 * Contains all report information and provides conversion methods
 * between Firestore documents and Dart objects.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

/**
 * Report class representing a lost or found item
 * 
 * Contains all information about a reported item including:
 * - Basic item details (title, description, type, color)
 * - Location and timing information
 * - Reporter contact information
 * - Status tracking (resolved/unresolved)
 * - Optional image attachment
 * 
 * Data Types:
 * - id: String - Unique identifier for the report
 * - title: String - Short descriptive title of the item
 * - type: String - Either 'lost' or 'found'
 * - description: String - Detailed description of the item
 * - tags: List<String> - Searchable keywords for the item
 * - colour: String - Color of the item for identification
 * - timeFoundLost: DateTime - When the item was lost/found
 * - location: String - Where the item was lost or found
 * - reporterName: String - Name of the person reporting
 * - reporterEmail: String - Contact email of the reporter
 * - imageUrl: String? - Optional URL to item photo (nullable)
 * - resolved: bool - Whether the item has been claimed/returned
 * - createdAt: DateTime - When the report was created
 */
class Report {
  final String id;
  final String title;
  final String type;
  final String description;
  final List<String> tags;
  final String colour;
  final DateTime timeFoundLost;
  final String location;
  final String reporterName;
  final String reporterEmail;
  final String? imageUrl;
  final bool resolved;
  final DateTime createdAt;

  /**
   * Constructor for creating a new Report instance
   * 
   * Input: All required report parameters (id, title, type, description, tags, colour, timeFoundLost, location, reporterName, reporterEmail, resolved, createdAt) and optional imageUrl
   * Processing: Initialize Report object with provided parameters
   * Output: Report instance
   */
  Report({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.tags,
    required this.colour,
    required this.timeFoundLost,
    required this.location,
    required this.reporterName,
    required this.reporterEmail,
    this.imageUrl,
    required this.resolved,
    required this.createdAt,
  });

  /**
   * Factory constructor to create Report from Firestore document
   * 
   * Input: String id, Map<String, dynamic> data
   * Processing: 
   * - Convert Firestore document data to Report object
   * - Handle data type conversions (DateTime parsing, List conversion)
   * - Provide default values for missing fields
   * Output: Report - New Report instance
   */
  factory Report.fromMap(String id, Map<String, dynamic> data) {
    return Report(
      id: id,
      title: data['title'],
      type: data['type'],
      description: data['description'],
      tags: List<String>.from(
        data['tags'] ?? [],
      ), // Convert to List<String> with empty default
      colour: data['colour'],
      timeFoundLost: DateTime.parse(
        data['timeFoundLost'],
      ), // Parse ISO 8601 string
      location: data['location'],
      reporterName: data['reporterName'],
      reporterEmail: data['reporterEmail'],
      imageUrl: data['image'], // Keep nullable if not present
      resolved: data['resolved'],
      createdAt: DateTime.parse(data['createdAt']), // Parse ISO 8601 string
    );
  }

  /**
   * Convert Report object to Firestore document format
   * 
   * Input: None (uses instance data)
   * Processing: 
   * - Convert Report object to Map format
   * - Serialize DateTime objects to ISO 8601 strings
   * - Prepare data for Firestore storage
   * Output: Map<String, dynamic> - Firestore-compatible document data
   */
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'description': description,
      'tags': tags,
      'colour': colour,
      'timeFoundLost': timeFoundLost.toIso8601String(), // Convert to ISO string
      'location': location,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'image': imageUrl, // Store as 'image' field in Firestore
      'resolved': resolved,
      'createdAt': createdAt.toIso8601String(), // Convert to ISO string
    };
  }
}
