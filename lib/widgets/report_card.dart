import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onResolve;

  ReportCard({
    required this.report,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onResolve,
  });

  bool get isOwner {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.email == report.reporterEmail;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.transparent, // Make container transparent
          // The decoration is now on the inner container
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple[200]!),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getImageColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      report.imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              report.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                            ),
                          )
                          : _buildImagePlaceholder(),
                ),

                SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        report.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Description
                      Text(
                        report.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            report.tags.take(3).map((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

                // Menu button (three dots) - only show if user is owner
                if (isOwner &&
                    (onEdit != null || onDelete != null || onResolve != null))
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
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
                          if (onResolve != null && !report.resolved)
                            PopupMenuItem(
                              value: 'resolve',
                              child: Row(
                                children: [
                                  Icon(Icons.check, size: 20),
                                  SizedBox(width: 8),
                                  Text('Mark as resolved'),
                                ],
                              ),
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: _getImageColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image, color: Colors.white, size: 32),
    );
  }

  Color _getImageColor() {
    // Use the report's colour field or generate a color based on the title
    switch (report.colour.toLowerCase()) {
      case 'blue':
        return Colors.blue[300]!;
      case 'yellow':
        return Colors.yellow[300]!;
      case 'grey':
      case 'gray':
        return Colors.grey[400]!;
      case 'red':
        return Colors.red[300]!;
      case 'green':
        return Colors.green[300]!;
      case 'purple':
        return Colors.purple[300]!;
      case 'orange':
        return Colors.orange[300]!;
      default:
        // Generate a color based on the title hash
        final hash = report.title.hashCode;
        final colors = [
          Colors.blue[300]!,
          Colors.green[300]!,
          Colors.orange[300]!,
          Colors.purple[300]!,
          Colors.red[300]!,
          Colors.teal[300]!,
        ];
        return colors[hash.abs() % colors.length];
    }
  }
}
