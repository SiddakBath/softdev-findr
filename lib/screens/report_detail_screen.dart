import 'package:findr/models/report.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({super.key, required this.report});

  bool get isOwner {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.email == report.reporterEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () {
                      // TODO: Implement edit
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // TODO: Implement delete
                    },
                  ),
                ]
                : null,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          _buildItemImage(),
          const SizedBox(height: 20),
          if (isOwner) _buildResolveButton() else _buildContactButton(),
          const SizedBox(height: 24),
          _buildSectionTitle('Description'),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 24),
          _buildDateTime(),
          const SizedBox(height: 24),
          _buildSectionTitle('Tags'),
          const SizedBox(height: 8),
          _buildTags(),
          const SizedBox(height: 24),
          _buildSectionTitle('Location'),
          const SizedBox(height: 8),
          Text(
            report.location,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.purple[100]!, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            report.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (isOwner)
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO: Implement delete
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO: Implement edit
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
                  size: 50,
                ),
              )
              : null,
    );
  }

  Widget _buildResolveButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: implement resolve
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[400],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
      ),
      child: const Text(
        'Resolve',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContactButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: implement contact
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[400],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
      ),
      child: const Text(
        'Contact',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDateTime() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Date'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // TODO: Format date
                      report.timeFoundLost.toLocal().toString().split(' ')[0],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
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
              _buildSectionTitle('Time'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // TODO: Format time
                      report.timeFoundLost
                          .toLocal()
                          .toString()
                          .split(' ')[1]
                          .substring(0, 5),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              )
              .toList(),
    );
  }
}
