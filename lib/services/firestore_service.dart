import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'reports';

  Stream<List<Report>> getReports(String? typeFilter) {
    Query query = _db.collection(_collection);
    if (typeFilter != null) query = query.where('type', isEqualTo: typeFilter);
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

  Future<void> addReport(Report report) {
    return _db.collection(_collection).doc(report.id).set(report.toMap());
  }

  Future<void> updateReport(Report report) {
    return _db.collection(_collection).doc(report.id).update(report.toMap());
  }

  Future<void> deleteReport(String id) {
    return _db.collection(_collection).doc(id).delete();
  }

  Future<void> markResolved(String id) {
    return _db.collection(_collection).doc(id).update({'resolved': true});
  }
}
