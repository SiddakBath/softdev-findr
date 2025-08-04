/**
 * report.dart
 * 
 * Data model for lost and found item reports
 * 
 * Contains all report information and provides conversion methods
 * between Firestore documents and Dart objects.
 * 
 * Author: [Your Name]
 * Created: [Date]
 * Last Modified: [Date]
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
   * Parameters:
   * - id: String - Unique identifier
   * - title: String - Item title
   * - type: String - 'lost' or 'found'
   * - description: String - Item description
   * - tags: List<String> - Search keywords
   * - colour: String - Item color
   * - timeFoundLost: DateTime - When item was lost/found
   * - location: String - Location of loss/finding
   * - reporterName: String - Reporter's name
   * - reporterEmail: String - Reporter's email
   * - imageUrl: String? - Optional photo URL
   * - resolved: bool - Resolution status
   * - createdAt: DateTime - Creation timestamp
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
   * Converts a Firestore document snapshot into a Report object.
   * Handles data type conversions and provides default values for missing fields.
   * 
   * Parameters:
   * - id: String - Document ID from Firestore
   * - data: Map<String, dynamic> - Document data from Firestore
   * 
   * Returns: Report - New Report instance
   * 
   * Data Conversions:
   * - DateTime fields are parsed from ISO 8601 strings
   * - tags list is converted from dynamic to List<String>
   * - imageUrl remains nullable if not present
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
   * Converts the Report object into a Map that can be stored in Firestore.
   * Handles DateTime serialization to ISO 8601 strings for Firestore compatibility.
   * 
   * Returns: Map<String, dynamic> - Firestore-compatible document data
   * 
   * Data Conversions:
   * - DateTime objects converted to ISO 8601 strings
   * - All other fields remain as-is for Firestore storage
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
