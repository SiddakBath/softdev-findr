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

  factory Report.fromMap(String id, Map<String, dynamic> data) {
    return Report(
      id: id,
      title: data['title'],
      type: data['type'],
      description: data['description'],
      tags: List<String>.from(data['tags'] ?? []),
      colour: data['colour'],
      timeFoundLost: DateTime.parse(data['timeFoundLost']),
      location: data['location'],
      reporterName: data['reporterName'],
      reporterEmail: data['reporterEmail'],
      imageUrl: data['image'],
      resolved: data['resolved'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'description': description,
      'tags': tags,
      'colour': colour,
      'timeFoundLost': timeFoundLost.toIso8601String(),
      'location': location,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'image': imageUrl,
      'resolved': resolved,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
